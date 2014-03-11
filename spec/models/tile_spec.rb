require 'spec_helper'

side_length = Tile.MAP_SIDE_LENGTH

describe Tile do
  pending "add some examples to (or delete) #{__FILE__}"

  describe ".tiles_at" do

    it "fetches the right number of tiles" do
      @tiles = (1..side_length ** 2).collect { FactoryGirl.create(:tile) }
      returned_tiles = Tile.tiles_at(0, 0, side_length, side_length)

      returned_tiles.count.should eq (side_length * side_length)
    end

    it "returns a single tile as a collection" do
      single_tile = Tile.tiles_at(0, 0, 0, 0)
      single_tile.respond_to?("count").should eql true
    end
  end

  describe ".tile_at" do
    it "returns a single tile as a record" do
      single_tile = Tile.tile_at(0, 0)
      single_tile.respond_to?("count").should eql false
    end

    it "returns the correct tile" do
      @tiles = (1..side_length ** 2).collect { FactoryGirl.create(:tile) }
      (0..side_length - 2).each do |i|
        (0..side_length - 2).each do |j|
          t = Tile.tile_at(i, j)
          t.x.should eq i
          t.y.should eq j
        end
      end
    end
  end

  describe ".item_at" do
    it "returns a valid item id" do
      item = FactoryGirl.create(:item)
      tile = FactoryGirl.create(:tile)
      tile.item = item
      tile.save!

      item_at = Tile.item_at(0, 0)
      puts item_at
    end

    it "returns nil when there's no item" do
      tile = FactoryGirl.create(:tile)
      Tile.item_at(0, 0).should eql nil
    end
  end

  describe ".character_at" do
  end
end
