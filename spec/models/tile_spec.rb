require 'spec_helper'

# The :tiles factory defined in /spec/factories/tile.rb generates tiles in
# successive rows of length Tile.MAP_SIDE_LENGTH, e.g.
# (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), ... (Tile.MAP_SIDE_LENGTH, 0),
# (0, 1), (1, 1), (2, 1), (3, 1), ...
# ... (Tile.MAP_SIDE_LENGTH, Tile.MAP_SIDE_LENGTH)

describe Tile do

  describe ".tiles_at" do

    it "fetches the right number of tiles" do
      returned_tiles = Tile.tiles_at(0, 0, @side_length, @side_length)
      returned_tiles.count.should eq (@side_length * @side_length)
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
      (0..@side_length - 2).each do |i|
        (0..@side_length - 2).each do |j|
          t = Tile.tile_at(i, j)
          t.x.should eq i
          t.y.should eq j
        end
      end
    end
  end

  describe ".item_at" do
    it "returns a valid item id when there is one" do
      tile = Tile.first
      tile.item = Item.create
      item_at = Tile.item_at(tile.x, tile.y)
      item_at.should be_valid
    end

    it "returns nil when there's no item" do
      tile = Tile.first
      tile.item = nil
      tile.save # Make sure u save kiddos or u will stupidly debug for 30 min
      Tile.item_at(tile.x, tile.y).should eql nil
    end
  end

  describe ".characters_at" do
    it "returns a correct list of valid characters when there is one" do
      tile = Tile.first
      5.times do
        character = Character.create
        character.tile = tile
        character.save
      end
      chars_at = Tile.characters_at(tile.x, tile.y)
      chars_at.each do |c|
        c.should be_valid
      end
    end

    it "returns an empty list when there're no characters" do
      tile = Tile.first
      tile.characters.each do |c|
        c.tile = nil
        c.save
      end
      Tile.characters_at(tile.x, tile.y).length.should eq 0
    end
  end

  describe ".inspect_tile" do
    context "on a sign (16)" do
      it "begins with Sign: " do
        tile = Tile.first
        tile.tile_type = 16
        tile.save!
        tile.inspect_tile(nil, "").should start_with "Sign: "
      end

      it "contains the tile's message" do
        tile = Tile.first
        tile.tile_type = 16
        tile.state = "a message"
        tile.save!
        tile.inspect_tile(nil, "").should include "a message"
      end
    end

    context "on a locked door (14)" do
      context "with no args (just looking)" do
        it "returns 'The door is locked with a password'" do
          tile = Tile.first
          tile.tile_type = 14
          tile.save
          tile.inspect_tile(nil, "").should eq "The door is locked with a password"
        end
      end

      context "with correct password" do
        it "returns 'Password Correct!'" do
          tile = Tile.first
          tile.tile_type = 14
          tile.save
          character = Character.create
          character.tile = tile
          character.save

          tile_above = Tile.tile_at(tile.x, tile.y+1)
          tile_above.tile_type = 14
          tile_above.state = "hunter2"
          tile_above.save

          tile_above.inspect_tile(character, "hunter2").should eq "Password Correct!"
        end

        it "moves the character" do
          tile = Tile.first
          character = Character.create
          character.tile = tile
          character.save

          tile_above = Tile.tile_at(tile.x, tile.y+1)
          tile_above.tile_type = 14
          tile_above.state = "hunter2"
          tile_above.save
          tile_above.inspect_tile(character, "hunter2")
          character.tile.should eql tile_above
        end
      end

      context "with incorrect password" do
        it "returns 'Access Denied!'" do
          tile = Tile.first
          character = Character.create
          character.tile = tile
          character.save

          tile_above = Tile.tile_at(tile.x, tile.y+1)
          tile_above.tile_type = 14
          tile_above.state = "hunter2"
          tile_above.save
          tile_above.inspect_tile(character, "WRONG").should eq "Access Denied!"
        end
      end
    end
  end

  describe ".neighbor" do
    context "north" do
      it "returns the tile to the north" do
        tile = Tile.first
        tile.neighbor(0).should eq (Tile.tile_at(tile.x, tile.y + 1))
      end
    end
    context "south" do
      it "returns the tile to the north" do
        tile = Tile.first
        tile.neighbor(2).should eq (Tile.tile_at(tile.x, tile.y - 1))
      end
    end
    context "west" do
      it "returns the tile to the north" do
        tile = Tile.first
        tile.neighbor(1).should eq (Tile.tile_at(tile.x + 1, tile.y))
      end
    end
    context "east" do
      it "returns the tile to the north" do
        tile = Tile.first
        tile.neighbor(3).should eq (Tile.tile_at(tile.x - 1, tile.y))
      end
    end
  end

end
