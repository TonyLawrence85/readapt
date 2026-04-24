require_relative "syllabifier"

class TextFormatter

  PALETTES = {
    "blue_red_green" => ["blue", "red", "green"],
    "orange_blue_purple" => ["orange", "blue", "purple"],
    "yellow_blue_green" => ["yellow", "blue", "green"]
  }

  def self.colors_for(palette)
    PALETTES[palette] || ["blue", "red", "green"]
  end

  def self.syllabify(text, palette: "blue_red_green")
    i = 0
    words = text.split(" ")
    words.map do |word|
      parts = Syllabifier.split(word)
      parts.map do |part|
        classe = "syl-#{i % 3}"
        i += 1
        "<span class='#{classe}'>#{part}</span>"
      end.join
    end.join(" ")
  end

end
