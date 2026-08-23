require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates default settings after registration" do
    user = User.create!(
      email: "user-test@example.com",
      password: "password123"
    )

    assert_not_nil user.setting
    assert_equal "OpenDyslexic", user.setting.font
    assert_equal "12", user.setting.font_size
    assert_not user.setting.syllable_mode
  end

  test "destroys associated articles" do
    user = User.create!(
      email: "destroy-test@example.com",
      password: "password123"
    )
    article = user.articles.create!(title: "Test", content: "Contenu")

    user.destroy!

    assert_not Article.exists?(article.id)
  end
end
