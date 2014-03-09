class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.integer :title_id
      t.integer :x
      t.integer :y
      t.integer :xn+y
      t.integer :type
      t.references :item_id, index: true
      t.references :character_id, index: true

      t.timestamps
    end
  end
end
