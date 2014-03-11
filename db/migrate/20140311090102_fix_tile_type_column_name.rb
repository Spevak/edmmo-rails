class FixTileTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :tiles, :type, :tile_type
  end
end
