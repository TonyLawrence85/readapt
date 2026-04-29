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

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if (params[:article][:source] == "copy") && !@article.content.present?
      render :new_copy, status: :unprocessable_entity and return
    end

    pdf_content = nil
    if params[:article][:document].present?
      reader = PDF::Reader.new(params[:article][:document].path)
      pdf_content = reader.pages.map(&:text).join("\n")
    end

    if @article.save
      setting = current_user.setting
      chat = RubyLLM.chat(model: "gpt-4o-mini")

      response = if pdf_content

                   chat.ask("#{build_prompt(setting)}\n\nTexte à reformater :\n#{pdf_content}")
                 else
                   chat.ask("#{build_prompt(setting)}\n\nTexte à reformater :\n#{@article.content}")
                 end
      normalized = response.content.gsub(/\.\s+(?=[A-ZÀÂÉÈÊËÎÏÔÙÛÜŒÆ])/, ".\n")
      lines = normalized.split("\n").reject(&:blank?)
      formatted_lines = if setting.syllable_mode
        lines.map { |line| TextFormatter.syllabify(line) }
      else
        lines
      end
      @article.update(formatted_content: formatted_lines.join("<br>"))

      AudioGenerationJob.perform_later(@article.id)
      redirect_to article_path(@article), notice: "Texte créé avec succès"
    elsif params[:article][:source] == "import"
      render :new_import, status: :unprocessable_entity
    else
      render :new, status: :unprocessable_entity
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
    params.require(:article).permit(:title, :content, :favourite, :document)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def build_prompt(setting)
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
