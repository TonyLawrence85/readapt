class ArticlesController < ApplicationController
  def index
    @filter = params[:filter] || "all"
    @articles = @filter == "favourites" ? current_user.articles.where(favourite: true) : recent_articles
  end

  def show
    set_article
  end

  def new_copy
    @article = Article.new
  end

  def new_import
    @article = Article.new
  end

  def new_photo
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    return render_source_error if invalid_source?

    content = extract_pdf_content.presence || @article.content
    return render_creation_error unless @article.save

    adapt_article(content)
    AudioGenerationJob.perform_later(@article.id)
    redirect_to article_path(@article), notice: "Texte créé avec succès"
  end

  def status
    set_article
    render json: {
      audio_ready: @article.audio.attached?,
      timestamps_ready: @article.audio_timestamps.present?
    }
  end

  def toggle_favourite
    set_article
    @article.update(favourite: !@article.favourite)
    redirect_to articles_path
  end

  def destroy
    set_article
    @article.destroy
    redirect_to articles_path, notice: "Texte supprimé"
  end

  private

  def recent_articles
    current_user.articles.order(created_at: :desc)
  end

  def article_params
    params.require(:article).permit(:title, :content, :favourite, :document, :source)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def invalid_source?
    return true if source == "copy" && @article.content.blank?
    return false unless source == "photo"
    return true if params[:photo].blank?

    @article.content = extract_text_from_photo(params[:photo].path)
    @article.content.blank?
  end

  def source
    params[:article][:source]
  end

  def render_source_error
    template = source == "photo" ? :new_photo : :new_copy
    render template, status: :unprocessable_entity
  end

  def extract_pdf_content
    document = params[:article][:document]
    return if document.blank?

    PDF::Reader.new(document.path).pages.map(&:text).join("\n")
  end

  def adapt_article(content)
    formatted = ArticleAdaptationService.call(
      content,
      syllable_mode: current_user.setting&.syllable_mode || false
    )
    @article.update(formatted_content: formatted.join("<br>"))
  end

  def render_creation_error
    template = { "photo" => :new_photo, "import" => :new_import }.fetch(source, :new)
    render template, status: :unprocessable_entity
  end

  def extract_text_from_photo(image_path)
    prompt = "Extrais exactement tout le texte visible dans cette image. " \
             "Retourne uniquement le texte brut, sans commentaire ni mise en forme."
    RubyLLM.chat(model: "gpt-4o-mini").ask(prompt, with: { image: image_path }).content
  end
end
