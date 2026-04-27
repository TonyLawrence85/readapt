class RemoveSyllableColorFromSettings < ActiveRecord::Migration[8.1]
  def change
    remove_column :settings, :syllable_color, :string
  end
end
