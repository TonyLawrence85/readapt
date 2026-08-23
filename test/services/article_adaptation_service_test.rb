require "test_helper"

class ArticleAdaptationServiceTest < ActiveSupport::TestCase
  Response = Struct.new(:content)

  test "normalizes the adapted response without calling the network" do
    with_fake_chat("Première phrase. Deuxième phrase.") do
      result = ArticleAdaptationService.call("Texte original")
      assert_equal ["Première phrase.", "Deuxième phrase."], result
    end
  end

  test "removes blank lines returned by the model" do
    with_fake_chat("Première phrase.\n\nDeuxième phrase.\n") do
      result = ArticleAdaptationService.call("Texte original")
      assert_equal ["Première phrase.", "Deuxième phrase."], result
    end
  end

  test "applies syllabification when syllable mode is enabled" do
    with_fake_chat("Bonjour monde.") do
      TextFormatter.stub(:syllabify, ->(line) { "adapté: #{line}" }) do
        result = ArticleAdaptationService.call("Texte original", syllable_mode: true)
        assert_equal ["adapté: Bonjour monde."], result
      end
    end
  end

  test "does not syllabify by default" do
    with_fake_chat("Bonjour monde.") do
      TextFormatter.stub(:syllabify, ->(_line) { flunk "unexpected syllabification" }) do
        assert_equal ["Bonjour monde."], ArticleAdaptationService.call("Texte original")
      end
    end
  end

  private

  def with_fake_chat(content)
    response_class = Response
    chat = Object.new
    chat.define_singleton_method(:ask) { |_message| response_class.new(content) }
    original_chat = RubyLLM.method(:chat)
    RubyLLM.define_singleton_method(:chat) { |**_options| chat }
    yield
  ensure
    RubyLLM.define_singleton_method(:chat, original_chat)
  end
end
