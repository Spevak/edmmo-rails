require 'spec_helper'

side_length = Tile.MAP_SIDE_LENGTH

describe Tile do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "#tiles_at" do
    @tiles = (1..side_length).collect { FactoryGirl.create(:tile) }
    returned_tiles = Tile.tiles_at(0, 0, side_length, side_length)

    @tiles.each do |t|
      puts "x: #{t.x}, y: #{t.y}, xn+y: #{t.xn_plus_y}"
    end

    it "fetches the right number of tiles" do
      returned_tiles.count.should eql (side_length * side_length)
    end
  end
end
