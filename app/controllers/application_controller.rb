class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_setting

  def current_setting
    return nil unless user_signed_in?

    current_user.setting
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
