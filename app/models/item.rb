# An item in BotQuest.
class Item < ActiveRecord::Base
  has_one :inventory
  has_one :character
  has_many :tiles

  # Modify my singleton class.
  # http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby
  class << self

    # Build an item from the item_data.
    # item_data should be a hash.
    def from_data(item_json) 
      item_data = JSON.parse(item_json)
      Item.new(
        type: item_data[:type].to_s,
        affects: item_data[:affects].to_s,
        moves_player_x: item_data[:coordsEffects][:x].to_i,
        moves_player_y: item_data[:coordsEffects][:y].to_i,
        consumable: item_data[:consumable].to_s,
        battery_effect: item_data[:batteryEffect].to_i,
        health_effect: item_data[:healthEffect].to_i,
        aoe_x_plus: item_data[:aoe][:xCoordPlus].to_i,
        aoe_y_plus: item_data[:aoe][:yCoordPlus].to_i,
        aoe_tile_becomes: item_data[:aoe][:tileBecomes].to_i,
        default_message: item_data[:defaultMessage].to_s
      )
    end

    # Make my constructor private.
    #private :new
  end

  def do_action
    if self.affects == 'world' then
    elsif self.affects == 'player' then

    end
  end
end
