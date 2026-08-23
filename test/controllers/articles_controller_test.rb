require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "owner@example.com", password: "password123")
    @other_user = User.create!(email: "other@example.com", password: "password123")
    @article = @user.articles.create!(title: "Privé", content: "Contenu privé")
    @other_article = @other_user.articles.create!(title: "Autre", content: "Autre contenu")
  end

  test "requires authentication to view articles" do
    get articles_url

    assert_response :redirect
  end

  test "allows a user to view their own article" do
    sign_in @user

    get article_url(@article)

    assert_response :success
  end

  test "prevents a user from viewing another users article" do
    sign_in @user

    get article_url(@other_article)

    assert_response :not_found
  end

  test "prevents a user from deleting another users article" do
    sign_in @user

    assert_no_difference("Article.count") do
      delete article_url(@other_article)
    end

    assert_response :not_found
    assert Article.exists?(@other_article.id)
  end
end
