require 'user'
require 'tile'
require 'item'
require 'inventory'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile
  belongs_to :inventory

  #move in direction dir. Return true on success, false on failure
  def move_direction(direction)
    dx, dy = 0, 0
    if direction == 'north' then
      dx, dy = 0, 1
    elsif direction == 'south'
      dx, dy = 0, -1
    elsif direction == 'east'
      dx, dy = 1, 0
    elsif direction == 'west'
      dx, dy = -1, 0
    end

    if dx == 0 and dy == 0 then
      return false
    end

    x = self.tile.x + dx
    y = self.tile.y + dy
    target_tile = Tile.tile_at(x, y)

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

    #spent 1 unit of battery taking a step
    self.battery -= 1
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

      puts "oldTile character:"
      puts oldTile.character

      tile.character = self
      tile.save!

      puts "tile character:"
      puts tile.character
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

  def use_item(item)
    if self.inventory.items.include? item then
      item.do_action
    end
  end

  def status
    if self.tile then
      tile_x = self.tile.x
      tile_y = self.tile.y
    else
      tile_x = -1
      tile_y = -1
    end
    
    { :hp => self.health || 100,
      :battery => self.battery || 100,
      :facing => self.facing || 'north',
      :x => tile_x,
      :y => tile_y}
  end

  def x
    self.tile.x
  end

  def y
    self.tile.y
  end

end
