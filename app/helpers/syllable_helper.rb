require "text/hyphen"

module SyllableHelper
  HYPHENATOR = Text::Hyphen.new(language: "fr")

  def syllabify(html)
    return "".html_safe if html.blank?

    fragment = Nokogiri::HTML5.fragment(html)
    fragment.xpath(".//text()").each do |node|
      next if node.ancestors("span.syl").any?

      replacement = node.content.split(/(\p{L}+)/).map do |part|
        part.match?(/\A\p{L}+\z/) ? syllabify_word(part) : ERB::Util.html_escape(part)
      end.join
      node.replace(Nokogiri::HTML5.fragment(replacement))
    end
    fragment.to_html.html_safe
  end

  private

  def syllabify_word(word)
    syllables = HYPHENATOR.visualise(word).split("-")
    return ERB::Util.html_escape(word) if syllables.length <= 2

    syllables.each_with_index.map do |syl, i|
      escaped = ERB::Util.html_escape(syl)
      i.odd? ? %(<span class="syl">#{escaped}</span>) : escaped
    end.join
  end
end
