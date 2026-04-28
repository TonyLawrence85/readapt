require_relative "syllabifier"

class TextFormatter

  PALETTES = {
    "blue_red_green"     => { bg: nil,       text: nil,       syllables: ["#1E88E5", "#E53935", "#43A047"] },
    "orange_blue_purple" => { bg: nil,       text: nil,       syllables: ["#FB8C00", "#1E88E5", "#8E24AA"] },
    "cream_dark_blue"    => { bg: "#194F7A", text: "#FFF8E7", syllables: ["#FFF8E7", "#D4C5A9", "#FFFACD"] },
    "yellow_black"       => { bg: "#111111", text: "#FFD700", syllables: ["#FFD700", "#FFC107", "#FFEB3B"] },
    "offwhite_dark_green"=> { bg: "#1B4332", text: "#F5F5DC", syllables: ["#F5F5DC", "#E8E8C8", "#FAFAD2"] },
    "orange_dark_gray"   => { bg: "#2D2D2D", text: "#FF8C00", syllables: ["#FF8C00", "#FF6B35", "#FFA500"] }
  }

  def self.palette_data_for(palette)
    PALETTES[palette] || PALETTES["blue_red_green"]
  end

  def self.colors_for(palette)
    palette_data_for(palette)[:syllables]
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
