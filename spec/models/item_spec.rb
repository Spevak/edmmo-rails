require 'spec_helper'

describe Item do
  before :each do
    @character = FactoryGirl.create(:character)
    tile = Tile.tile_at(4, 5)
    @character.tile = tile
    @character.save
  end

  it "should be valid" do
    FactoryGirl.build(:item).should be_valid
  end

  describe '#from_data' do
    it "produces a valid Item" do
      Item.from_data(ITEM_PROPERTIES["potato"]).should be_valid
    end
  end

  describe ".do_action" do
    context 'of player-affecting item' do
      battery_effect = ITEM_PROPERTIES["potato"]["batteryEffect"]
      it ": potato boosts the character's battery by #{battery_effect}" do
        potato = FactoryGirl.create(:potato)
        expected_battery = @character.battery + battery_effect
        @character.pick_up(potato)
        @character.use_item(potato)
        @character = Character.find(@character)
        @character.battery.should eq(expected_battery)
      end

      health_effect = ITEM_PROPERTIES["repairKit"]["healthEffect"]
      it ": repair kit boosts the character's health by #{health_effect}" do
        repair_kit = FactoryGirl.create(:repair_kit)
        expected_health = @character.health + health_effect
        @character.pick_up(repair_kit)
        @character.use_item(repair_kit)
        @character = Character.find(@character)
        @character.health.should eq(expected_health)
      end

      it "consumes item on use" do
        potato = FactoryGirl.create(:potato)
        @character.pick_up(potato)
        @character.use_item(potato)
        @character = Character.find(@character)
        @character.item.should_not eq(potato)
      end
    end

    context 'of sign' do
      it "converts the character's current tile to a Sign tile" do
        sign = FactoryGirl.create(:sign)
        @character.pick_up(sign)
        @character.use_item(sign)
        @character = Character.find(@character)
        @character.tile.tile_type.should eq(16)
      end

      it "is consumed on use" do
        sign = FactoryGirl.create(:sign)
        @character.pick_up(sign)
        @character.use_item(sign)
        @character = Character.find(@character)
        @character.item.should_not eq(sign)
      end
    end
  end
end
