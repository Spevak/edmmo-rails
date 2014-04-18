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
      Item.new(
        item_type: item_data["type"].to_s,
        affects: item_data["affects"].to_s,
        moves_player_x: item_data["coordsEffects"]["x"].to_i,
        moves_player_y: item_data["coordsEffects"]["y"].to_i,
        consumable: item_data["consumable"],
        walkoverable: item_data["consumable"],
        pickupable: item_data["consumable"],
        battery_effect: item_data["batteryEffect"].to_i,
        health_effect: item_data["healthEffect"].to_i,
        default_message: item_data["defaultMessage"].to_s
      )
    end

    # Make my constructor private.
    #private :new
  end

  def do_action
    if self.affects == 'world' then
      player_tile = self.character.tile

      self.item_type.aoe.each do |aoe|
        dx = aoe[:xCoordPlus]
        dy = aoe[:yCoordPlus]
        tile_becomes = aoe[:tileBecomes]
        Tile.tile_at(player_tile.x + dx, player_tile.y + dy).become tile_becomes
      end

    elsif self.affects == 'player' then

      player = self.character

      dx = self.moves_player_x
      dy = self.moves_player_y

      if (dx != 0 && dy != 0) then
        target_tile = Tile.tile_at(player.tile.x + dx, player.tile.y + y)
        player.tile = target_tile
      end

      player.battery += self.battery_effect
      player.health += self.health_effect

      player.save!
    end

  end
end
