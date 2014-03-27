class AddItemToCharacters < ActiveRecord::Migration
  def change
    add_reference :characters, :item, index: true
  end
end
