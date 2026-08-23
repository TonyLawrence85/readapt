require "tempfile"

class AudioGenerationJob < ApplicationJob
  queue_as :default

  def perform(article_id)
    article = Article.find(article_id)
    return if article.formatted_content.blank?

    phrases = extract_phrases(article)
    attach_audio(article, phrases)
    return unless article.audio.attached?

    response = transcribe_audio(article)
    timestamps = build_timestamps(phrases, transcription_words(response))
    article.update(audio_timestamps: timestamps.to_json)
  end

  private

  def extract_phrases(article)
    article.formatted_content.split(%r{<br\s*/?>}i).reject(&:blank?)
  end

  def attach_audio(article, phrases)
    audio_content = TtsService.call(plain_text_for(phrases))
    article.audio.attach(
      io: StringIO.new(audio_content),
      filename: "article_#{article.id}.mp3",
      content_type: "audio/mpeg"
    )
  end

  def plain_text_for(phrases)
    phrases.map do |phrase|
      text = strip_tags(phrase).gsub(/[,;:\-–—]/, "")
      text.end_with?(".") ? text : "#{text}."
    end.join(" ")
  end

  def transcribe_audio(article)
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY", nil))

    Tempfile.create(["article_#{article.id}", ".mp3"], binmode: true) do |tmp|
      tmp.write(article.audio.download)
      tmp.rewind
      client.audio.transcribe(parameters: transcription_parameters(tmp))
    end
  end

  def transcription_parameters(file)
    {
      model: "whisper-1",
      file: file,
      response_format: "verbose_json",
      language: "fr"
    }
  end

  def transcription_words(response)
    response["segments"].flat_map do |segment|
      count = normalized_words(segment["text"]).length
      Array.new(count) { { start: segment["start"], end: segment["end"] } }
    end
  end

  def build_timestamps(phrases, all_words)
    word_position = 0

    phrases.map do |phrase|
      word_count = normalized_words(strip_tags(phrase)).length
      timestamp = timestamp_for(phrase, all_words, word_position, word_count)
      word_position += word_count
      timestamp
    end
  end

  def timestamp_for(phrase, all_words, word_position, word_count)
    start_time = all_words[word_position]&.[](:start) || 0
    end_position = [word_position + word_count - 1, all_words.length - 1].min
    end_time = all_words[end_position]&.[](:end) || 0

    { text: strip_tags(phrase), start: start_time, end: end_time }
  end

  def normalized_words(text)
    text.downcase.gsub(/[^a-zàâçéèêëîïôùûüœæ\s]/i, "").split
  end

  def strip_tags(text)
    ActionController::Base.helpers.strip_tags(text).strip
  end
end
