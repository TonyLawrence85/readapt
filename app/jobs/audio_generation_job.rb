require "uri"
require "open-uri"

class AudioGenerationJob < ApplicationJob
  queue_as :default

  def perform(article_id)
    article = Article.Find(article_id)

    return if article.formatted_content.blank?

    return unless article.audio.attached?

    client = OpenAI::Client.new(access_token: ENV["OPEN_API_KEY"])
    audio_url = Rails.application.routes.url_helpers.url_for(articles.audio)


    response = client.audio.transcribe(
      parameters: {
        model: "whisper-1"
        file: URI.open(audio_url),
        response_format: "verbose_json"
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
