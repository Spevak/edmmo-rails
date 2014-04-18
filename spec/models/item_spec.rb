require 'spec_helper'

describe Item do
  before :each do
    @character = FactoryGirl.create(:character)
    t = Tile.tile_at(4, 5)
    t.character = @character
    t.save
  end

  it "should be valid" do
    FactoryGirl.build(:item).should be_valid
  end

  describe ".do_action" do
    context 'of potato' do
      battery_effect = ITEM_PROPERTIES["potato"]["batteryEffect"]
      it "boosts the character's battery by #{battery_effect}" do
        potato = FactoryGirl.create(:potato)
        expected_battery = @character.battery + battery_effect
        @character.pick_up(potato)
        @character.use_item(potato)
        @character = Character.find(@character)
        @character.battery.should eq(expected_battery)
      end

      it "is consumed on use" do
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
