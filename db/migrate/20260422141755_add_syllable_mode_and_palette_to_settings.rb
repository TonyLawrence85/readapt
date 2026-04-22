class AddSyllableModeAndPaletteToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :syllable_mode, :boolean
    add_column :settings, :syllable_palette, :string
  end
end
