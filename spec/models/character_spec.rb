require 'spec_helper'

# Side length
TEST_MAP_SIZE = 3

describe Character do

  before :all do
    @character = FactoryGirl.create(:character)
  end

  describe ".move_to" do
    it "reassigns the character's tile" do
      tile = @tiles.first
      @character.tile = tile
      @character.move_to @tiles[1].x, @tiles[1].y
      #Tile.character_at(tile.x + 1, tile.y).should eq(@character)
      @character.tile.should_not eql(tile)
      @character.tile.should eq @tiles[1]
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

  describe ".status" do
    it "returns a hash of user attributes" do
      @character.status.length.should eq(3)
    end
    it "reflects changes to user attributes" do
      @character.health = 99
      @character.save
      @character.status[:health].should eq(99)
    end
  end
end
