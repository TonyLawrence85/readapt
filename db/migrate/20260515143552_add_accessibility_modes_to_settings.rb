class AddAccessibilityModesToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :silent_letters_mode, :boolean, default: false, null: false
    add_column :settings, :confused_letters_mode, :boolean, default: false, null: false
  end
end
