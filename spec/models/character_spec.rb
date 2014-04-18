require 'spec_helper'

# Side length
TEST_MAP_SIZE = 3

describe Character do

  before :each do
    @character = FactoryGirl.create(:character)
    @tile = Tile.tile_at(2, 2)
    @tile.character = @character
    @tile.save
  end

  describe ".move_direction" do

    context "with valid input: north" do
      it "increments self.y by 1" do
        old_x = @character.x
        old_y = @character.y
        @character.move_direction('north')
        @character.x.should eq(old_x)
        @character.y.should eq(old_y + 1)
      end
      it "causes the player to face north" do
        @character.move_direction('north')
        @character.facing.should eq(0)
      end
    end

    context "with valid input: south" do
      it "decrements self.y by 1" do
        old_x = @character.x
        old_y = @character.y
        @character.move_direction('south')
        @character.x.should eq(old_x)
        @character.y.should eq(old_y - 1)
      end
      it "causes the player to face south" do
        @character.move_direction('south')
        @character.facing.should eq(2)
      end
    end

    context "with valid input: east" do
      it "increments self.x by 1" do
        old_x = @character.x
        old_y = @character.y
        @character.move_direction('east')
        @character.x.should eq(old_x + 1)
        @character.y.should eq(old_y)
      end
      it "causes the player to face east" do
        @character.move_direction('east')
        @character.facing.should eq(1)
      end
    end

    context "with valid input: west" do
      it "decrements self.x by 1" do
        old_x = @character.x
        old_y = @character.y
        @character.move_direction('west')
        @character.x.should eq(old_x - 1)
        @character.y.should eq(old_y)
      end
      it "causes the player to face west" do
        @character.move_direction('west')
        @character.facing.should eq(3)
      end
    end

    context "with invalid input: nonexistent tile" do
      it "does nothing" do
        @tile = Tile.last
        @tile.character = @character
        @tile.save
        @character.move_direction('north')
        @character.tile.should eq(@tile)
      end
    end

    context "with invalid input: not a direction" do
      it "does nothing" do
        tile = @character.tile
        @character.move_direction("my butt")
        @character.tile.should eq(tile)
      end
    end
  end

  describe ".move_to" do
    it "reassigns the character's tile" do
      tile = @tiles.first
      tile.character = @character
      tile.save
      @character.move_to @tiles[1].x, @tiles[1].y
      #Tile.character_at(tile.x + 1, tile.y).should eq(@character)
      @character.tile.should_not eql(tile)
      @character.tile.should eq @tiles[1]
      tile.character = nil
      tile.save
    end
  end

  describe ".pick_up" do

    context 'with item held' do
      it "adds the picked up item to the inventory" do
        @item = FactoryGirl.create(:item)
        @character.pick_up(@item)
        @item2 = FactoryGirl.create(:item)
        @character.pick_up(@item2)
        @character.item.should eq(@item)
        @character.inventory.items.should include(@item2)
      end
    end

    context 'without item held' do
      it "pushes the currently held item into the inventory" do
      end

      it "sets the character's currently held item" do
        @item = FactoryGirl.create(:item)
        @character.pick_up(@item)
        @character.inventory.items.should_not include(@item)
        @character.item.should eq(@item)
      end
    end
  end

  describe ".drop" do
    context "with item in hand" do
      it "removes the item from the character's hand" do
        @item = FactoryGirl.create(:item)
        @character.pick_up(@item)
        @character.drop(@item)
        @character.item.should_not eq(@item)
      end

      it "places the item on the tile the character is standing on" do
        @item = FactoryGirl.create(:item)
        @tile = @tiles.first
        @tile.character = @character
        @tile.save

        @character.pick_up(@item)
        @character.drop(@item)
        @character.tile.item.should eq(@item)
      end
    end

    context "with item in inventory" do
      it "removes the item from the character's inventory" do
        @item = FactoryGirl.create(:item)
        @character.pick_up(@item)
        @item2 = FactoryGirl.create(:item)
        @character.pick_up(@item2)
        @character.drop(@item)
        @character.drop(@item2)
        @character.inventory.items.should_not include(@item)
      end

      it "places the item on the tile the character is standing on" do
        @item = FactoryGirl.create(:item)
        @character.pick_up(@item)
        @item2 = FactoryGirl.create(:item)
        @character.pick_up(@item2)
        @tile = @tiles.first
        @tile.character = @character
        @tile.save

        @character.pick_up(@item)
        @character.pick_up(@item2)
        @character.drop(@item2)
        @character.tile.item.should eq(@item2)
      end
    end

    context "with no item" do
      it "does nothing" do
      end
    end
  end

  describe ".use_item" do
    context "have the used item" do
      it "calls do_action on the held item" do
        item = FactoryGirl.create(:item)
        @character.pick_up(item)
        item.should receive(:do_action)
        @character.use_item(item)
      end

      it "calls do_action on an inventory item" do
        item = FactoryGirl.create(:item)
        item2 = FactoryGirl.create(:item)
        @character.pick_up(item)
        @character.pick_up(item2)
        item2.should receive(:do_action)
        @character.use_item(item2)
      end

    end

    context "don't have the used item" do
      it "does nothing" do
      end
    end
  end

  describe ".status" do
    it "returns correct user attributes" do
      status = @character.status
      inventory_map = @character.inventory.items.map do |item|
        { item.item_type => item }
      end
      status[:health].should eq(@character.health)
      status[:battery].should eq(@character.battery)
      status[:facing].should eq(@character.facing)
      status[:x].should eq(@character.x)
      status[:y].should eq(@character.y)
      status[:inventory].should eq(inventory_map)
    end
    
    it "reflects changes to user attributes" do
      @character.health = 99
      @character.save
      @character.status[:health].should eq(99)
    end
  end

  describe ".x" do
    it "returns the tile x when there is a tile" do
      tile = @tiles.first
      tile.character = @character
      tile.save
      @character.x.should eq(@character.tile.x)
    end

    it "returns -1 when there is no tile" do
      @character.tile = nil
      @character.x.should eq(-1)
    end
  end

  describe ".y" do
    it "returns the tile y when there is a tile" do
      tile = @tiles.first
      tile.character = @character
      tile.save
      @character.y.should eq(@character.tile.y)
    end

    it "returns -1 when there is no tile" do
      @character.tile = nil
      @character.y.should eq(-1)
    end
  end

  describe ".heal" do
    it "increments health by the specified amount" do
      old_health = @character.health
      @character.heal(10)
      @character.health.should eq(old_health + 10)
    end
  end

  describe ".charge" do
    it "increments battery by the specified amount" do
      old_battery = @character.battery
      @character.charge(10)
      @character.battery.should eq(old_battery + 10)
    end
  end
end
