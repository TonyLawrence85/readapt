module ApplicationHelper

  def with_px(value)
    v = value.to_s.strip
    return "0px" if v.blank?
    v.end_with?("px") ? v : "#{v}px"
  end

  def render_with_settings(text)
    return text unless user_signed_in?

    setting = current_user.setting
    return text unless setting

    letter_spacing = with_px(setting.letter_spacing)
    font_size      = with_px(setting.font_size)
    palette_data   = TextFormatter.palette_data_for(setting.syllable_palette)

    base_style = "font-family: #{setting.font}; letter-spacing: #{letter_spacing}; font-size: #{font_size};"

    if setting.syllable_mode && palette_data[:bg]
      base_style += " background-color: #{palette_data[:bg]}; color: #{palette_data[:text]}; padding: 0.8rem 1rem; border-radius: 8px;"
    end

    content =
      if setting.syllable_mode
        TextFormatter.syllabify(text, palette: setting.syllable_palette)
      else
        text
      end

    "<div style='#{base_style}'>#{content}</div>".html_safe
  end
end
