module ArticlesHelper
  def inject_karaoke_targets(html)
    sentences = html.split(/<br\s*\/?>/i).reject(&:blank?)
    sentences.map.with_index do |sentence, i|
      content_tag(:span, sentence.html_safe,
        "data-karaoke-target" => "segment",
        "data-index" => i,
        class: "karaoke-segment"
      )
    end.join.html_safe
  end
end
