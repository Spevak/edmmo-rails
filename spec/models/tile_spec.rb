require 'spec_helper'

describe Tile do
  pending "add some examples to (or delete) #{__FILE__}"

  it "fetches sets of tiles properly" do
    @tiles = (1..4**2).collect { FactoryGirl.create(:tile) }
    returned_tiles = Tile.tiles_at(1, 1, 16, 16)
    puts returned_tiles
  end
end
