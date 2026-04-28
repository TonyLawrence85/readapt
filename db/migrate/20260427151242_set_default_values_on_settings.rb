class SetDefaultValuesOnSettings < ActiveRecord::Migration[8.1]
  def up
    change_column_default :settings, :font,             "OpenDyslexic"
    change_column_default :settings, :letter_spacing,   "0"
    change_column_default :settings, :font_size,        "12"
    change_column_default :settings, :syllable_mode,    false
    change_column_default :settings, :syllable_palette, "blue_red_green"

    Setting.find_each do |s|
      s.update_columns(
        font:             s.font.presence            || "OpenDyslexic",
        letter_spacing:   s.letter_spacing.presence  || "0",
        font_size:        s.font_size.presence        || "12",
        syllable_mode:    s.syllable_mode.nil?         ? false : s.syllable_mode,
        syllable_palette: s.syllable_palette.presence || "blue_red_green"
      )
    end
  end

  def down
    change_column_default :settings, :font,             nil
    change_column_default :settings, :letter_spacing,   nil
    change_column_default :settings, :font_size,        nil
    change_column_default :settings, :syllable_mode,    nil
    change_column_default :settings, :syllable_palette, nil
  end
end
