class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @recent_texts = current_user.texts.order(created_at: :desc).limit(2) if user_signed_in?
  end
end
