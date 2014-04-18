class ChangeTilesHash < ActiveRecord::Migration
  def change
    change_column :tiles, :xn_plus_y, :string
    rename_column :tiles, :xn_plus_y, :x_y_pair
  end
end
