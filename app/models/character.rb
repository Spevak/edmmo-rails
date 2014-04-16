require 'user'
require 'tile'
require 'item'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile

  def move_to(x, y)

    if (self.tile.x - x).abs + (self.tile.y - y).abs <= 1 then
      #update direction facing
      if y > self.tile.y then
        self.facing = 0
        direction = 'north'
        dx, dy = 0, 1
      elsif y < self.tile.y then
        self.facing = 2
        direction = 'south'
        dx, dy = 0, -1
      elsif x > self.tile.x then
        self.facing = 1
        direction = 'east'
        dx, dy = 1, 0
      elsif x < self.tile.x then
        self.facing = 3
        direction = 'west'
        dx, dy = -1, 0
      end

      # get the tile properties from a json file
      require 'json'
      tile_properties_json = File.open("/Users/michelmikhail/Google Drive/Berkeley/Classes/cs 169/edmmo-rails/config/map/tiles/properties.json").read
      tile_properties = JSON[tile_properties_json]

      # the tile the character is moving to
      target_tile = Tile.tile_at(x + dx, y + dy)

      # update battery & health according to tile property
      self.battery += tile_properties[target_tile.tile_type.to_s]["batteffect"][direction[0]]
      self.health += tile_properties[target_tile.tile_type.to_s]["healtheffect"][direction[0]]
      self.save!

      #update tile
      tile = Tile.tile_at(x, y)
      oldTile = self.tile
      oldTile.character = nil
      oldTile.save!

      tile.character = self
      tile.save!

    end
  end

  def pick_up(item_id)
    i = Item.find_by_id(item_id)
    self.item = i
    self.save!
  end

  def drop(item_id)
    i = self.item
    t = self.tile
    t.item = i
    t.save!

    self.item = nil
    self.save!
  end

  def tile()
    Tile.find_by_character_id(self.id)
  end

  def setTile(tile)
    tile.character = self
    tile.save!
  end

  def use_item(x, y)
    # do nothing LOL
  end

  def status
    { :hp => self.health, # Michel: why the name change? let's try to keep things consistent when possible.
      :battery => self.battery,
      :facing => self.facing,
      :x => self.tile.x,
      :y => self.tile.y}
  end

  def x
    self.tile.x
  end

  def y
    self.tile.y
  end

end
