require 'user'
require 'tile'
require 'item'
require 'inventory'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile
  belongs_to :inventory

  before_save do |me|
    i = Inventory.create
    me.inventory = i
  end

  def move_to(x, y)
    if (self.tile.x - x).abs + (self.tile.y - y).abs <= 1 then
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

  def use_item(item, args*)
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
