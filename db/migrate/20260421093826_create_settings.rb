class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.string :font
      t.string :syllable_color
      t.string :letter_spacing
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
