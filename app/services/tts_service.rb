class TtsService
  VOICE = { language_code: "fr-FR", ssml_gender: :NEUTRAL }.freeze
  AUDIO_CONFIG = { audio_encoding: :MP3 }.freeze

  def self.call(text)
    response = client.synthesize_speech(
      input: { text: text },
      voice: VOICE,
      audio_config: AUDIO_CONFIG
    )
    response.audio_content
  end

  def self.client
    Google::Cloud::TextToSpeech.text_to_speech
  end
  private_class_method :client
end
