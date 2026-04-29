require "tempfile"

class AudioGenerationJob < ApplicationJob
  queue_as :default

  def perform(article_id)
    article = Article.find(article_id)

    return if article.formatted_content.blank?

    phrases = article.formatted_content.split(/<br\s*\/?>/i).reject(&:blank?)
    plain_text = phrases.map { |p|
      s = ActionController::Base.helpers.strip_tags(p).strip
      s = s.gsub(/[,;:\-–—]/, "")
      s.end_with?(".") ? s : "#{s}."
    }.join(" ")
    audio_content = TtsService.call(plain_text)

    article.audio.attach(
      io: StringIO.new(audio_content),
      filename: "article_#{article.id}.mp3",
      content_type: "audio/mpeg"
    )
    return unless article.audio.attached?

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    Tempfile.create(["article_#{article.id}", ".mp3"], binmode: true) do |tmp|
      tmp.write(article.audio.download)
      tmp.rewind

      response = client.audio.transcribe(
        parameters: {
          model: "whisper-1",
          file: tmp,
          response_format: "verbose_json",
          language: "fr"
        }
      )
      all_words = []
      response["segments"].each do |seg|
        count = seg["text"].downcase.gsub(/[^a-zàâçéèêëîïôùûüœæ\s]/i, "").split.length
        count.times { all_words << { start: seg["start"], end: seg["end"] } }
      end

      word_pos = 0
      timestamps = phrases.map do |phrase|
        phrase_words = ActionController::Base.helpers.strip_tags(phrase)
                         .downcase.gsub(/[^a-zàâçéèêëîïôùûüœæ\s]/i, "").split

        start_time = all_words[word_pos]&.[](:start) || 0
        word_pos += phrase_words.length
        end_time = all_words[[word_pos - 1, all_words.length - 1].min]&.[](:end) || 0

        { text: ActionController::Base.helpers.strip_tags(phrase).strip,
          start: start_time,
          end: end_time }
      end
      article.update(audio_timestamps: timestamps.to_json)
    end
  end
end
