require "google/cloud/text_to_speech"
require "json"

# On vérifie que la variable est présente pour éviter de faire planter l'app au démarrage
if ENV['GOOGLE_CLOUD_JSON'].present?
  begin
    # 1. On parse la string JSON en Hash
    key_config = JSON.parse(ENV['GOOGLE_CLOUD_JSON'])

    # 2. On configure le client avec ce Hash
    Google::Cloud::TextToSpeech.configure do |config|
      config.credentials = key_config
    end

  rescue JSON::ParserError => e
    Rails.logger.error "Erreur lors du parsing de GOOGLE_CLOUD_JSON : #{e.message}"
  end
end
