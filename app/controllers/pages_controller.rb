class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @recent_articles = current_user.articles.order(created_at: :desc).limit(2) if user_signed_in?
  end
end
