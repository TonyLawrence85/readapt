require "test_helper"

class ArticleAdaptationServiceTest < ActiveSupport::TestCase
  Response = Struct.new(:content)

  test "normalizes the adapted response without calling the network" do
    chat = Object.new
    chat.define_singleton_method(:ask) do |_message|
      Response.new("Première phrase. Deuxième phrase.")
    end

    RubyLLM.stub(:chat, chat) do
      result = ArticleAdaptationService.call("Texte original")
      assert_equal ["Première phrase.", "Deuxième phrase."], result
    end
  end
end
