require 'spec_helper'

describe Character do

  before :all do
    @character = FactoryGirl.create(:character)
  end

  describe ".move_to" do
    it "reassigns the character's tile" do
      old_tile = @character.tile
      @character.move_to(tile.x+1, tile.y)
      @character.tile.should_not eql(tile)
    end
  end

  describe ".pick_up" do
    it "sets the character's item" do
      item = FactoryGirl.create(:item)
      @character.pick_up(item.id)
      @character.save
      @character.item.should be(item)
    end
  end

  describe ".use_item" do
    it "does nothing" do
    end
  end
end
