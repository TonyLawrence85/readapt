class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @setting = current_user.setting
  end

  def update
    @setting = current_user.setting

    if @setting.update(setting_params)
      redirect_to edit_setting_path
    else
      render :edit
    end
  end

  def download
    setting = current_user.setting

    text = "Font: #{setting.font}\n"
    text += "Color: #{setting.syllable_color}\n"
    text += "Spacing: #{setting.letter_spacing}\n"
    text += "Font size: #{setting.font_size}\n"

    send_data text, filename: "my_settings.txt"
  end

  private

  def setting_params
    params.require(:setting).permit(:font, :syllable_color, :letter_spacing, :font_size)
  end
end
