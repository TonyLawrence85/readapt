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
end
