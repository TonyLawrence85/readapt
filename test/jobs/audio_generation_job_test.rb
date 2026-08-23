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

  test "generates audio and timestamps without external API calls" do
    article = @user.articles.create!(
      title: "Lecture audio",
      content: "Texte original",
      formatted_content: "Bonjour monde<br>Deuxième phrase"
    )
    response = {
      "segments" => [
        { "text" => "Bonjour monde", "start" => 0.0, "end" => 1.5 },
        { "text" => "Deuxième phrase", "start" => 1.5, "end" => 3.0 }
      ]
    }

    with_fake_tts("fake mp3 data") do
      with_fake_transcription(response) { AudioGenerationJob.perform_now(article.id) }
    end

    article.reload
    timestamps = JSON.parse(article.audio_timestamps)
    assert article.audio.attached?
    assert_equal 2, timestamps.length
    assert_equal "Bonjour monde", timestamps.first["text"]
    assert_equal 0.0, timestamps.first["start"]
    assert_equal 1.5, timestamps.first["end"]
    assert_equal "Deuxième phrase", timestamps.second["text"]
    assert_equal 1.5, timestamps.second["start"]
    assert_equal 3.0, timestamps.second["end"]
  end

  private

  def with_fake_tts(audio_content)
    original_call = TtsService.method(:call)
    TtsService.define_singleton_method(:call) { |_text| audio_content }
    yield
  ensure
    TtsService.define_singleton_method(:call, original_call)
  end

  def with_fake_transcription(response)
    audio_api = Object.new
    audio_api.define_singleton_method(:transcribe) { |parameters:| response }
    client = Struct.new(:audio).new(audio_api)
    original_new = OpenAI::Client.method(:new)
    OpenAI::Client.define_singleton_method(:new) { |**_options| client }
    yield
  ensure
    OpenAI::Client.define_singleton_method(:new, original_new)
  end
end
