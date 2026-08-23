require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "article-test@example.com",
      password: "password123"
    )
  end

  test "is valid with a title and content" do
    article = @user.articles.new(title: "Lecture", content: "Un texte à adapter.")

    assert article.valid?
  end

  test "requires a title" do
    article = @user.articles.new(content: "Un texte à adapter.")

    assert_not article.valid?
    assert article.errors.added?(:title, :blank)
  end

  test "requires content when no document is attached" do
    article = @user.articles.new(title: "Lecture")

    assert_not article.valid?
    assert article.errors.added?(:content, :blank)
  end

  test "accepts a PDF document without text content" do
    article = @user.articles.new(title: "Document")
    article.document.attach(
      io: StringIO.new("%PDF-1.4 test"),
      filename: "lecture.pdf",
      content_type: "application/pdf"
    )

    assert article.valid?
  end

  test "rejects a non PDF document" do
    article = @user.articles.new(title: "Document")
    article.document.attach(
      io: StringIO.new("not a pdf"),
      filename: "lecture.txt",
      content_type: "text/plain"
    )

    assert_not article.valid?
    assert_includes article.errors[:document], "doit être un fichier PDF"
  end
end
