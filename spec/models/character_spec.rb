require 'spec_helper'

# Side length
TEST_MAP_SIZE = 3

describe Character do

  before :all do
    @character = FactoryGirl.create(:character)
  end

  describe ".move_to" do
    it "reassigns the character's tile" do
      @tiles = (1..TEST_MAP_SIZE).collect{ FactoryGirl.create(:tile) }
      tile = Tile.tile_at(0, 0)
      @character.move_to(tile.x + 1, tile.y)
      Tile.character_at(tile.x + 1, tile.y).should eq(@character)
      @character.tile.should_not eql(tile)
    end
  end

  describe ".pick_up" do
    it "sets the character's item" do
      item = FactoryGirl.create(:item)
      @character.pick_up(item.id)
      @character.save
      @character.item.should eq(item)
    end
  end

  describe ".use_item" do
    it "does nothing" do
    end
  end
end
