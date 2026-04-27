require_relative "syllabifier"

class TextFormatter

  PALETTES = {
    "blue_red_green"     => ["#1E88E5", "#E53935", "#43A047"],
    "orange_blue_purple" => ["#FB8C00", "#1E88E5", "#8E24AA"]
  }

  def self.colors_for(palette)
    PALETTES[palette] || PALETTES["blue_red_green"]
  end

  def self.syllabify(text, palette: "blue_red_green")
    colors = colors_for(palette)
    i = 0
    text.split(" ").map do |word|
      Syllabifier.split(word).map do |part|
        color = colors[i % 3]
        i += 1
        "<span style='color:#{color}'>#{part}</span>"
      end.join
    end.join(" ")
  end

end
