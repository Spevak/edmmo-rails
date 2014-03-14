class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.integer :tile_id
      t.integer :x
      t.integer :y
      t.integer :xn_plus_y
      t.integer :type
      t.belongs_to :item, index: true
      t.belongs_to :character, index: true

      t.timestamps
    end
  end
end
