class CreateTexts < ActiveRecord::Migration[8.1]
  def change
    create_table :texts do |t|
      t.string :title
      t.text :content
      t.string :favourite
      t.text :translated_content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
