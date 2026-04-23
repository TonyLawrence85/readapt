class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def current_setting
    return nil unless user_signed_in?
    current_user.setting
  end
  helper_method :current_setting
end
