class ProfilesController < ApplicationController
  def show
    @articles_count = current_user.articles.count
    @words_count = current_user.articles.sum do |a|
      a.content.present? ? a.content.split.size : 0
    end
    @days_count = (Date.today - current_user.created_at.to_date).to_i
  end
end
