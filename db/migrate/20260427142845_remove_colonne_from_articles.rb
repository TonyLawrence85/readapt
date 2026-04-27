class RemoveColonneFromArticles < ActiveRecord::Migration[8.1]
  def change
    remove_column :articles, :translated_content, :text
  end
end
