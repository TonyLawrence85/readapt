class AddConfusedPairsToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :confused_pairs, :string, default: ""
    add_column :settings, :confused_custom, :string, default: ""
    remove_column :settings, :confused_letters_mode, :boolean
  end
end
