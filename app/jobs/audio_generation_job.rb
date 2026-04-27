require "uri"
require "open-uri"

class AudioGenerationJob < ApplicationJob
  queue_as :default

  def perform(article_id)
    article = Article.find(article_id)

    return if article.formatted_content.blank?
    TtsService.call(article.formatted_content)

    article.audio.attach(
      io: File.open(Rails.root.join("public", "output.mp3")),
      filename: "article_#{article.id}.mp3",
      content_type: "audio/mpeg"
    )
    return unless article.audio.attached?

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    audio_url = Rails.application.routes.url_helpers.url_for(article.audio)

    audio_file = URI.open(audio_url)

    response = client.audio.transcribe(
      parameters: {
        model: "whisper-1",
        file: audio_file,
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

