class TextsController < ApplicationController

  def index
    @texts = current_user.texts
  end

  def show
    set_text
  end

  def new_copy
    @text = Text.new
  end

  def new_import
    @text = Text.new
  end

  def create
    @text = Text.new(text_params)
    @text.user = current_user

    if params[:text][:source] == "copy"
      unless @text.content.present?
        render :new_copy, status: :unprocessable_entity and return
      end
    end

    if @text.save
      setting = current_user.setting
      chat = RubyLLM.chat(model: "gpt-4o-mini")

        if @text.document.attached?
          pdf_content = @text.document.open do |file|
            reader = PDF::Reader.new(file)
            reader.pages.map(&:text).join("\n")
          end
          response = chat.ask("#{build_prompt(setting)}\n\nTexte à reformater :\n#{pdf_content}")
        else
          response = chat.ask("#{build_prompt(setting)}\n\nTexte à reformater :\n#{@text.content}")
        end

      @text.update(formatted_content: response.content)
      redirect_to text_path(@text), notice: "Texte créé avec succès"
    else
      if params[:text][:source] == "import"
        render :new_import, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def toggle_favourite
    set_text
    @text.update(favourite: !@text.favourite)
    redirect_to texts_path
  end

  def destroy
    set_text
    @text.destroy
    redirect_to texts_path, notice: "Texte supprimé"
  end

  private

  def text_params
    params.require(:text).permit(:title, :content, :favourite, :translated_content, :document)
  end

  def set_text
    @text = Text.find(params[:id])
  end

  def build_prompt(setting)
    <<-PROMPT
    Tu es un assistant spécialisé pour les personnes dyslexiques.
    Reformate le texte pour le rendre  plus accessible.
    Police souhaitée : #{setting&.font || 'OpenDyslexic'}.
    Espacement : #{setting&.letter_spacing || 'normal'}.
    Règles : coupe les phrases longues en phrases courtes,
    ajoute un saut de ligne entre chaque phrase,
    garde le sens original intact.
    Retourne uniquement le texte reformaté, sans commentaire.
    PROMPT
  end
end
