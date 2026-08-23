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
    text_record = current_user.texts.first
    return redirect_without_text unless text_record

    send_data downloadable_text(text_record.content),
              filename: "adapted_text.txt",
              type: "text/plain"
  end

  private

  def redirect_without_text
    redirect_to edit_setting_path(current_user.setting), alert: "Aucun texte disponible"
  end

  def downloadable_text(text)
    return text unless current_user.setting.syllable_mode

    TextFormatter.syllabify(text)
  end

  def setting_params
    sp = params.require(:setting).permit(
      :font, :syllable_palette, :letter_spacing, :font_size,
      :syllable_mode, :silent_letters_mode, :confused_custom,
      confused_pairs: []
    )
    pairs = Array(sp[:confused_pairs]).compact.reject(&:blank?)
    sp.merge(confused_pairs: pairs.join(","))
  end
end
