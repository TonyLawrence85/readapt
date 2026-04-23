class RenameTextsToArticles < ActiveRecord::Migration[8.1]
  def change
    rename_table :texts, :articles
  end
end
