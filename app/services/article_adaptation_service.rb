class ArticleAdaptationService
  MODEL = "gpt-4o-mini".freeze

  PROMPT = <<~PROMPT.freeze
    Tu es un assistant spécialisé dans l'adaptation de textes pour les
    personnes dyslexiques. Ta tâche : transformer le texte fourni en une
    version plus lisible, SANS en modifier le sens ni ajouter d'information.

    RÈGLES DE RÉÉCRITURE :
    1. Phrases courtes : 15 mots maximum. Si une phrase est plus longue,
      coupe-la en plusieurs phrases simples.
    2. Une idée = une phrase. Évite les subordonnées imbriquées.
    3. Remplace les mots rares ou complexes par des synonymes courants,
      SAUF s'il s'agit d'un terme technique essentiel (dans ce cas, garde-le).
    4. Préfère la voix active à la voix passive.
    5. Évite les doubles négations.
    6. Conserve strictement les noms propres, chiffres, dates et citations.
    7. Termine chaque phrase par un point.

    FORMAT DE SORTIE (STRICT) :
    - Pas de <p>, uniquement du texte brut.
    - Retourne UNIQUEMENT le texte adapté, sans préambule ni commentaire.
    - MAXIMUM ABSOLU : 15 mots par phrase. Compte les mots. Coupe si nécessaire.
    - Après chaque point, retourne obligatoirement à la ligne.
    - Une phrase = une ligne, sans exception.
    - Un saut de ligne double entre les paragraphes logiques.
  PROMPT

  def self.call(content, syllable_mode: false)
    response = RubyLLM.chat(model: MODEL).ask(
      "#{PROMPT}\n\nTexte à reformater :\n#{content}"
    )
    lines = normalize(response.content)
    syllable_mode ? lines.map { |line| TextFormatter.syllabify(line) } : lines
  end

  def self.normalize(content)
    normalized = content.gsub(/\.\s+(?=[A-ZÀÂÉÈÊËÎÏÔÙÛÜŒÆ])/, ".\n")
    normalized.split("\n").reject(&:blank?)
  end
  private_class_method :normalize
end
