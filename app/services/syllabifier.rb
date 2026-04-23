
require "text/hyphen"

class Syllabifier
  HYPHENATOR = Text::Hyphen.new(language: "fr", left: 2, right: 2)

  def self.split(word)
    HYPHENATOR.visualise(word, "·").split("·")
  end

  # Ou directement sur un texte entier :
  def self.syllabify_text(text)
    text.gsub(/\p{L}+/) { |word| HYPHENATOR.visualise(word, "·") }
    
  end
end
