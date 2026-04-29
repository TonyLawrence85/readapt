class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @setting = current_user.setting
  end

  def edit
    @setting = current_user.setting
  end

  def update
    @setting = current_user.setting

    if @setting.update(setting_params)
      respond_to do |format|
        format.html { redirect_to setting_path(@setting), notice: "Préférences mises à jour ✅" }
        format.turbo_stream
      end
    else
      render :edit
    end
  end

  def download
    setting = current_user.setting
    text_record = current_user.texts.first

    # sécurité si aucun texte
    if text_record.nil?
      redirect_to edit_setting_path(setting), alert: "Aucun texte disponible"
      return
    end

    text = text_record.content

    # appliquer les settings
    adapted_text =
      if setting.syllable_mode
        TextFormatter.syllabify(text)
      else
        text
      end

    send_data adapted_text,
              filename: "adapted_text.txt",
              type: "text/plain"
  end

  private

  def setting_params
    params.require(:setting).permit(:font, :syllable_palette, :letter_spacing, :font_size, :syllable_mode)
  end
end
