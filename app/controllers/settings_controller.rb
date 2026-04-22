class SettingsController < ApplicationController
  def edit
    @setting = Setting.find(params[:id])
  end

end
