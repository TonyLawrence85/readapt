module ApplicationHelper

  def render_with_settings(text)
    return text unless user_signed_in?

    setting = current_user.setting
    return text unless setting

    content =
      if setting.syllable_mode
        TextFormatter.syllabify(text, palette: setting.syllable_palette)
      else
        text
      end

    "<div style='font-family: #{setting.font}; letter-spacing: #{setting.letter_spacing}; font-size: #{setting.font_size};'>
      #{content}
    </div>".html_safe
  end
end
