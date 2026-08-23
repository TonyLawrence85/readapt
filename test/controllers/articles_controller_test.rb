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

  test "creates an article for the signed in user" do
    sign_in @user

    with_fake_adaptation(["Texte adapté."]) do
      assert_enqueued_with(job: AudioGenerationJob) do
        assert_difference("@user.articles.count", 1) do
          post articles_url, params: {
            article: { title: "Nouveau texte", content: "Texte original", source: "copy" }
          }
        end
      end
    end

    created_article = @user.articles.order(:created_at).last
    assert_equal "Nouveau texte", created_article.title
    assert_equal "Texte original", created_article.content
    assert_equal "Texte adapté.", created_article.formatted_content
    assert_response :redirect
    assert_equal article_path(created_article), URI.parse(response.location).path
  end

  test "toggles favourite on the users own article" do
    sign_in @user

    patch toggle_favourite_article_url(@article)

    assert_response :redirect
    assert_equal articles_path, URI.parse(response.location).path
    assert @article.reload.favourite?
  end

  test "deletes the users own article" do
    sign_in @user

    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_response :redirect
    assert_equal articles_path, URI.parse(response.location).path
    assert_not Article.exists?(@article.id)
  end

  test "prevents toggling favourite on another users article" do
    sign_in @user
    original_value = @other_article.favourite?

    patch toggle_favourite_article_url(@other_article)

    assert_response :not_found
    assert_equal original_value, @other_article.reload.favourite?
  end

  private

  def with_fake_adaptation(result)
    original_call = ArticleAdaptationService.method(:call)
    ArticleAdaptationService.define_singleton_method(:call) { |_content, **_options| result }
    yield
  ensure
    ArticleAdaptationService.define_singleton_method(:call, original_call)
  end
end
