# A tile on the map in BotQuest. Tiles are 0-indexed (coords begin at 0.)
class Tile < ActiveRecord::Base
  # Side length of the map.
  MAP_SIDE_LENGTH = 25

  belongs_to :item
  belongs_to :character

  validates :x, numericality: { only_integer: true }
  validates :y, numericality: { only_integer: true }
  validates :x_y_pair, uniqueness: true 
  validates :tile_type, numericality: { only_integer: true }

  before_validation do |tile|
    #tile.xn_plus_y = (tile.x * MAP_SIDE_LENGTH) + tile.y
    if tile.x_y_pair == nil then
        tile.x_y_pair = tile.x.to_s + "," + tile.y.to_s
    end
  end

  def self.MAP_SIDE_LENGTH
    MAP_SIDE_LENGTH
  end

  def self.tile_at(x, y)
    Tile.find_by_x_y_pair(x.to_s + "," + y.to_s) 
  end

  # Return the tiles with x in between x1 and x2 (inclusive)
  # and y inbetween y1 and y2
  def self.tiles_at(x1, y1, x2, y2)
    # Make sure x1 < x2 and y1 < y2
    if x1 > x2 then x1, x2 = x2, x1 end
    if y1 > y2 then y1, y2 = y2, y1 end

    return Tile.where("(x >= ? AND x <= ?) AND (y >= ? AND y <= ?)",
                      x1, x2, y1, y2)
  end

  def self.item_at(x, y)
    t = Tile.tile_at(x, y)
    if t 
      t.item
    else
      nil
    end
  end

  def self.character_at(x, y)
    t = Tile.tile_at(x, y)
    if t 
      t.character
    else
      nil
    end
  end

  def onEnter(char)
    #puts 'entering tile (' + self.x.to_s + ", " + self.y.to_s + "), id: " + self.tile_type.to_s
    #portal
    if self.tile_type == 13 then
      #the indices of the tile to warp to are stored in self.data as the string (x,y)
      indices = /\((\d*),(\d*)\)/.match(self.state)
      x = indices[1].to_i
      y = indices[2].to_i
      #make sure we're not teleporting onto another warp, to avoid infinite mutual recursion
      target = Tile.tile_at(x, y)
      if target.tile_type == 13 then return end
      char.move_to(x,y)
    end
  end

  def become(tile_type)
    self.tile_type = tile_type
    self.save
  end

  def inspectTile(dir, args)
    dx, dy = 0, 0
    if dir == 0 then
      dy = 1
    elsif dir == 2
      dy = -1
    elsif dir == 1
      dx = 1
    elsif dir == 3
      dx = -1
    end
    toInspect = Tile.tile_at(self.x + dx, self.y + dy)
    #sign
    if toInspect.tile_type == 16 then 
       return "a sign that says #{toInspect.state}"
    end  
    #return TILE_PROPERITES[self.tile_type.to_s]["description"]
    return "..."
  end

end
