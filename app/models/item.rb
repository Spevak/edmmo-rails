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
    def from_data(item_data) 
      unless item_data
        return
      end
      Item.new(
        item_type: item_data["type"],
        affects: item_data["affects"],
        moves_player_x: item_data["coordsEffects"]["x"],
        moves_player_y: item_data["coordsEffects"]["y"],
        consumable: item_data["consumable"],
        walkoverable: item_data["consumable"],
        pickupable: item_data["consumable"],
        battery_effect: item_data["batteryEffect"],
        health_effect: item_data["healthEffect"],
        default_message: item_data["defaultMessage"]
      )
    end

  end

  # Do the thing that the item does.
  def do_action
    if self.affects == "world" then
      player_tile = self.character.tile

      # an aoe effect is represented as a list of objects,
      # each one representing the effect on one tile
      ITEM_PROPERTIES[self.item_type]["aoe"].each do |aoe|
        dx = aoe["xCoordPlus"]
        dy = aoe["yCoordPlus"]
        tile_becomes = aoe["tileBecomes"]
        Tile.tile_at(player_tile.x + dx, player_tile.y + dy).become tile_becomes
      end

    elsif self.affects == "player" then

      dx = self.moves_player_x
      dy = self.moves_player_y

      # Move me to the place this item takes me
      if (dx != 0 or dy != 0) then
        target_tile = Tile.tile_at(self.character.tile.x + dx,
                                   self.character.tile.y + dy)
        if target_tile
          self.character.tile = target_tile
        end
      end

      if self.character.heal(self.health_effect) and self.character.charge(self.battery_effect)
        return true
      else 
        return false
      end
    end

    if self.consumable then
      self.character.item = nil
      self.destroy
    end

  end

end
