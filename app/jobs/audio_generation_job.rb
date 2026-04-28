require "tempfile"

class AudioGenerationJob < ApplicationJob
  queue_as :default

  def perform(article_id)
    article = Article.find(article_id)

    return if article.formatted_content.blank?

    plain_text = ActionController::Base.helpers.strip_tags(article.formatted_content).gsub(/\s+/, " ").strip
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
      timestamps = response["segments"].map do |segment|
        {
          text: segment["text"],
          start: segment["start"],
          end: segment["end"]
        }
      end
      article.update(audio_timestamps: timestamps.to_json)
    end
  end
end
