module ApplicationHelper
  def with_px(value)
    v = value.to_s.strip
    return "0px" if v.blank?

    v.end_with?("px") ? v : "#{v}px"
  end

  def wrap_with_settings(html_content)
    return html_content unless user_signed_in? && current_user.setting

    styled_content(html_content, current_user.setting, "1rem")
  end

  def render_with_settings(text)
    return text unless user_signed_in? && current_user.setting

    setting = current_user.setting
    content = setting.syllable_mode ? TextFormatter.syllabify(text) : text
    styled_content(content, setting, "0.8rem 1rem")
  end

  private

  def styled_content(content, setting, padding)
    palette = TextFormatter.palette_data_for(setting.syllable_palette)
    style = reading_style(setting, palette, padding)
    css = syllable_css(setting, palette[:syllables])
    "<style>#{css}</style><div style='#{style}'>#{content}</div>".html_safe
  end

  def reading_style(setting, palette, padding)
    style = "font-family: #{setting.font}; letter-spacing: #{with_px(setting.letter_spacing)}; " \
            "font-size: #{with_px(setting.font_size)};"
    return style unless palette[:bg]

    style + " background-color: #{palette[:bg]}; color: #{palette[:text]}; " \
            "padding: #{padding}; border-radius: 8px;"
  end

  def syllable_css(setting, colors)
    return ".syl-0,.syl-1,.syl-2{color:inherit}" unless setting.syllable_mode

    ".syl-0{color:#{colors[0]}}.syl-1{color:#{colors[1]}}.syl-2{color:#{colors[2]}}"
  end
end
