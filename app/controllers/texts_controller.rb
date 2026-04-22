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
    7. Aère le texte : un saut de ligne entre chaque phrase, un saut de
      ligne double entre les paragraphes logiques.

    FORMAT DE SORTIE (STRICT) :
    - Retourne UNIQUEMENT le texte adapté, sans préambule ni commentaire.
    - Découpe chaque mot de plus de 2 syllabes en syllabes
    - Entoure UNE syllabe sur deux avec des <span class="syl">...</span>
      Exemple : "oridnateur" -> or<span class="syl">di</span>na<span class="syl">teur</span>
    - Les mots de 1 ou 2 syllabes restent intacts.
    - Retourne du HTML pur, sans balise <html>, <body> ou <p>.
    Police souhaitée : #{setting&.font || 'OpenDyslexic'}.
    Espacement : #{setting&.letter_spacing || 'normal'}.

    PROMPT
  end
end
