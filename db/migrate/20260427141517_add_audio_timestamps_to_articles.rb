class AddAudioTimestampsToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :audio_timestamps, :text
  end
end
