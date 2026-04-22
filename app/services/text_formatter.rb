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
  colors = colors_for(palette)

  words = text.split(" ")

  words.map do |word|
    parts = word.scan(/.{1,2}/)

    parts.map.with_index do |part, i|
      color = colors[i % colors.length]
      "<span style='color: #{color}'>#{part}</span>"
    end.join
  end.join(" ")
  end


end
