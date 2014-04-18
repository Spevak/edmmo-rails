require 'user'
require 'tile'
require 'item'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile

  #move in direction dir. Return true on success, false on failure
  def move_direction(direction)

    #Convert the direction to a change in x and y coordinates. 
    #Also set the direction we are leaving the current tile and the direction
    #we are entering the new tile (e.g. going north we leave the current tile
    #in the north direction and enter the next tile from the south 
    dx, dy = 0, 0
    leave_dir, enterDir = nil, nil
    if direction == 'north' then
      dx, dy = 0, 1
      leave_dir, enter_dir = 'n', 's'
      self.facing = 0
    elsif direction == 'south'
      dx, dy = 0, -1
      leave_dir, enter_dir = 's', 'n'
      self.facing = 2
    elsif direction == 'east'
      dx, dy = 1, 0
      leave_dir, enter_dir = 'e', 'w'
      self.facing = 1
    elsif direction == 'west'
      dx, dy = -1, 0
      leave_dir, enter_dir = 'w', 'e'
      self.facing = 3
    end
    self.save!

    #The direction given was not one of the 4 cardinal directions
    if dx == 0 and dy == 0 then
      return false
    end

    #find the tile to be moved to
    x = self.tile.x + dx
    y = self.tile.y + dy
    target_tile = Tile.tile_at(x, y)

    #Make sure it is valid to walk over the tile
    target_tile_props = TILE_PROPERTIES[target_tile.tile_type.to_s]
    current_tile_props = TILE_PROPERTIES[self.tile.tile_type.to_s]
    leaving_traversable = current_tile_props["traversable"][leave_dir]
    entering_traversable = target_tile_props["traversable"][enter_dir]
    if leaving_traversable == 1 or leaving_traversable == 3 or
        entering_traversable == 1 or entering_traversable == 2 then
      return false
    end

    if target_tile == nil then
      return false
    end

    #update direction facing
    if y > self.tile.y then
      self.facing = 0
    elsif y < self.tile.y then
      self.facing = 2
    elsif x > self.tile.x then
      self.facing = 1
    elsif x < self.tile.x then
      self.facing = 3
    end


    # update battery & health according to tile property
    self.battery += TILE_PROPERTIES[target_tile.tile_type.to_s]["batteffect"][enter_dir]
    self.health += TILE_PROPERTIES[target_tile.tile_type.to_s]["healtheffect"][enter_dir]
    self.save!

    self.move_to(x, y)
    return true
  end

  def move_to(x, y)

    #Don't move to same tile as this causes strange bug where character's association with a tile is deleted.
    if (self.tile.x - x).abs + (self.tile.y - y).abs >= 1 then

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
