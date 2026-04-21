class ChangeTextsFavouriteToBoolean < ActiveRecord::Migration[8.1]
  def change
    change_column :texts, :favourite, :boolean, default: false, null: false, using: 'favourite::boolean'
  end
end
