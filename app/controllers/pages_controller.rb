class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home extension_privacy]

  def home
    @recent_articles = current_user.articles.order(created_at: :desc).limit(2) if user_signed_in?
  end

  def extension_privacy
  end
end
