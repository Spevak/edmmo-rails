require 'spec_helper'

describe Tile do
  pending "add some examples to (or delete) #{__FILE__}"

  it "has 0 or 1 characters" do
    tile = FactoryGirl.create :tile
    character = FactoryGirl.create :character
    tile.character = character
    tile.character.should eq(character)
  end

  it "has 0 or 1 items" do
    tile = FactoryGirl.create :tile
    item = FactoryGirl.create :item
    tile.item = item
    tile.item.should eq(item)
  end
end
