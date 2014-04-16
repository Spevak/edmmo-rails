class AddInventoryReferences < ActiveRecord::Migration
  def change
    add_reference :items, :inventory, index: true
    add_reference :inventories, :character, index: true
    remove_reference :characters, :item
  end
end
