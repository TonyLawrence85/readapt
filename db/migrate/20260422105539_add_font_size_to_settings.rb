class AddFontSizeToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :font_size, :string
  end
end
