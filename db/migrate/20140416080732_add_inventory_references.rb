class AddInventoryReferences < ActiveRecord::Migration
  def change
    add_reference :items, :inventory, index: true
    add_reference :characters, :inventory, index: true
  end
end
