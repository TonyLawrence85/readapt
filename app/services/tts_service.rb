class TtsService
  def self.call(text)
    client = Google::Cloud::TextToSpeech.text_to_speech

    # Configuration de l'entrée (le texte)
    input_text = { text: text }

    # Choix de la voix (Langue et genre)
    voice = {
      language_code: "fr-FR",
      ssml_gender:   "NEUTRAL"
    }

    # Configuration du format de sortie
    audio_config = { audio_encoding: "MP3" }

    # Requête à l'API
    response = client.synthesize_speech(
      input:        input_text,
      voice:        voice,
      audio_config: audio_config
    )

    response.audio_content
  end
end
