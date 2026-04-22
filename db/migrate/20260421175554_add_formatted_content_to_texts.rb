class AddFormattedContentToTexts < ActiveRecord::Migration[8.1]
  def change
    add_column :texts, :formatted_content, :text
  end
end
