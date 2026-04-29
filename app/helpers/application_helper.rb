module ApplicationHelper

  def with_px(value)
    v = value.to_s.strip
    return "0px" if v.blank?
    v.end_with?("px") ? v : "#{v}px"
  end

  # Pour les articles (HTML déjà formaté avec syl-0/1/2)
  def wrap_with_settings(html_content)
    return html_content unless user_signed_in?

    setting = current_user.setting
    return html_content unless setting

    letter_spacing = with_px(setting.letter_spacing)
    font_size      = with_px(setting.font_size)
    palette_data   = TextFormatter.palette_data_for(setting.syllable_palette)
    colors         = palette_data[:syllables]

    base_style = "font-family: #{setting.font}; letter-spacing: #{letter_spacing}; font-size: #{font_size};"

    if palette_data[:bg]
      base_style += " background-color: #{palette_data[:bg]}; color: #{palette_data[:text]}; padding: 1rem; border-radius: 8px;"
    end

    syl_css = if setting.syllable_mode
      ".syl-0{color:#{colors[0]}}.syl-1{color:#{colors[1]}}.syl-2{color:#{colors[2]}}"
    else
      ".syl-0,.syl-1,.syl-2{color:inherit}"
    end

    "<style>#{syl_css}</style><div style='#{base_style}'>#{html_content}</div>".html_safe
  end

  # Pour les aperçus (texte brut à syllabifier)
  def render_with_settings(text)
    return text unless user_signed_in?

    setting = current_user.setting
    return text unless setting

    letter_spacing = with_px(setting.letter_spacing)
    font_size      = with_px(setting.font_size)
    palette_data   = TextFormatter.palette_data_for(setting.syllable_palette)

    base_style = "font-family: #{setting.font}; letter-spacing: #{letter_spacing}; font-size: #{font_size};"

    if palette_data[:bg]
      base_style += " background-color: #{palette_data[:bg]}; color: #{palette_data[:text]}; padding: 0.8rem 1rem; border-radius: 8px;"
    end

    content =
      if setting.syllable_mode
        TextFormatter.syllabify(text)
      else
        text
      end

    "<div style='#{base_style}'>#{content}</div>".html_safe
  end
end
