class ReverseAndPluralizeTileCharacterAssociation < ActiveRecord::Migration
  def change
    add_reference :characters, :tile, index: true
    remove_reference :tiles, :character
  end
end
