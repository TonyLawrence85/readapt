class ArticlesController < ApplicationController
  def index
    @filter = params[:filter] || "all"

    @articles =
      case @filter
      when "favourites"
        current_user.articles.where(favourite: true)
      else
        current_user.articles.order(created_at: :desc)
      end
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

    pdf_content = extract_pdf_content

    if @article.save
      adapt_article(pdf_content)
      AudioGenerationJob.perform_later(@article.id)
      redirect_to article_path(@article), notice: "Texte créé avec succès"
    else
      render_creation_error
    end
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

  def article_params
    params.require(:article).permit(:title, :content, :favourite, :document, :source)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def invalid_source?
    return true if copy_without_content?
    return false unless photo_source?
    return true if params[:photo].blank?

    extracted = extract_text_from_photo(params[:photo].path)
    return true if extracted.blank?

    @article.content = extracted
    false
  end

  def copy_without_content?
    source == "copy" && @article.content.blank?
  end

  def photo_source?
    source == "photo"
  end

  def source
    params[:article][:source]
  end

  def render_source_error
    template = photo_source? ? :new_photo : :new_copy
    render template, status: :unprocessable_entity
  end

  def extract_pdf_content
    document = params[:article][:document]
    return if document.blank?

    PDF::Reader.new(document.path).pages.map(&:text).join("\n")
  end

  def adapt_article(pdf_content)
    input = pdf_content.presence || @article.content
    response = RubyLLM.chat(model: "gpt-4o-mini").ask(
      "#{build_prompt}\n\nTexte à reformater :\n#{input}"
    )
    lines = normalize_response(response.content)
    formatted_lines = format_lines(lines)
    @article.update(formatted_content: formatted_lines.join("<br>"))
  end

  def normalize_response(content)
    normalized = content.gsub(/\.\s+(?=[A-ZÀÂÉÈÊËÎÏÔÙÛÜŒÆ])/, ".\n")
    normalized.split("\n").reject(&:blank?)
  end

  def format_lines(lines)
    return lines unless current_user.setting&.syllable_mode

    lines.map { |line| TextFormatter.syllabify(line) }
  end

  def render_creation_error
    template = case source
               when "photo" then :new_photo
               when "import" then :new_import
               else :new
               end
    render template, status: :unprocessable_entity
  end

  def extract_text_from_photo(image_path)
    chat = RubyLLM.chat(model: "gpt-4o-mini")
    prompt = "Extrais exactement tout le texte visible dans cette image. " \
             "Retourne uniquement le texte brut, sans commentaire ni mise en forme."
    response = chat.ask(prompt, with: { image: image_path })
    response.content
  end

  def build_prompt
    <<-PROMPT
    Tu es un assistant spécialisé dans l'adaptation de textes pour les
    personnes dyslexiques. Ta tâche : transformer le texte fourni en une
    version plus lisible, SANS en modifier le sens ni ajouter d'information.

    RÈGLES DE RÉÉCRITURE :
    1. Phrases courtes : 15 mots maximum. Si une phrase est plus longue,
      coupe-la en plusieurs phrases simples.
    2. Une idée = une phrase. Évite les subordonnées imbriquées.
    3. Remplace les mots rares ou complexes par des synonymes courants,
      SAUF s'il s'agit d'un terme technique essentiel (dans ce cas, garde-le).
    4. Préfère la voix active à la voix passive.
    5. Évite les doubles négations.
    6. Conserve strictement les noms propres, chiffres, dates et citations.
    7. Termine chaque phrase par un point.

    FORMAT DE SORTIE (STRICT) :
    - Pas de <p>, uniquement du texte brut.
    - Retourne UNIQUEMENT le texte adapté, sans préambule ni commentaire.
    - MAXIMUM ABSOLU : 15 mots par phrase. Compte les mots. Coupe si nécessaire.
    - Après chaque point, retourne obligatoirement à la ligne. Une phrase = une ligne, sans exception.
    - Un saut de ligne double entre les paragraphes logiques.

    PROMPT
  end
end
