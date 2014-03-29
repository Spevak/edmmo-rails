require 'user'
require 'tile'
require 'item'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile

  def move_to(x, y)
    if (self.tile.x - x).abs <= 1 and (self.tile.y - y).abs <= 1 then
      tile = Tile.tile_at(x, y)
      self.tile = tile
      self.save
    end
  end

  def pick_up(item_id)
    i = Item.find_by_id(item_id)
    i.character = self
    i.save
  end

  def drop(item_id)
    i = Item.find_by_id(item_id)
    i.character = nil
    i.save
  end

  def tile()
    Tile.find_by_character_id(self.id)
  end

  def tile=(tile)
    tile.character = self
    tile.save!
  end

  def use_item(x, y)
    # do nothing LOL
  end

  def status
    { :health => self.health,
      :battery => self.battery,
      :facing => self.facing }
  end

  def x
    self.tile.x
  end

  def y
    self.tile.y
  end

end
