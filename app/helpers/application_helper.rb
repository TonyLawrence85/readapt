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

    content =
      if setting.syllable_mode
        TextFormatter.syllabify(text, palette: setting.syllable_palette)
      else
        text
      end

    "<div style='font-family: #{setting.font}; letter-spacing: #{letter_spacing}; font-size: #{font_size};'>
      #{content}
    </div>".html_safe
  end
end
