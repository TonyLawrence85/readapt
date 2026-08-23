require "test_helper"

class AudioGenerationJobTest < ActiveJob::TestCase
  setup do
    @user = User.create!(email: "audio-job@example.com", password: "password123")
  end

  test "does nothing when formatted content is blank" do
    article = @user.articles.create!(title: "Lecture", content: "Texte original")

    AudioGenerationJob.perform_now(article.id)

    assert_not article.reload.audio.attached?
    assert_nil article.audio_timestamps
  end
end
