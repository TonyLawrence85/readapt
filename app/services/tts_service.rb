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

    # Le contenu audio est dans response.audio_content
    # Tu peux l'enregistrer dans un fichier ou l'envoyer vers ActiveStorage
    File.open("public/output.mp3", "wb") do |file|
      file.write(response.audio_content)
    end
  end
end
