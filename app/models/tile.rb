class Tile < ActiveRecord::Base
  belongs_to :item
  belongs_to :character

  validates :x, numericality: { only_integer: true }
  validates :y, numericality: { only_integer: true }
  validates :xn_plus_y, uniqueness: true, numericality: { only_integer: true }
  validates :tile_type, numericality: { only_integer: true }

  # Side length of the map.
  MAP_SIDE_LENGTH = 16

  def self.MAP_SIDE_LENGTH
    MAP_SIDE_LENGTH
  end

  def self.tile_at(x, y)
    return Tile.find_by_xn_plus_y((x * MAP_SIDE_LENGTH) + y) 
  end

  # Return the tiles with x in between x1 and x2 (inclusive)
  # and y inbetween y1 and y2
  def self.tiles_at(x1, y1, x2, y2)
    # Make sure x1 < x2 and y1 < y2
    if x1 > x2 then x1, x2 = x2, x1 end
    if y1 > y2 then y1, y2 = y2, y1 end

    # Avoid doing dumb SQL query
    if x1 == x2 and y1 == y2
      return Tile.tile_at(x1, y1)
    end

    return Tile.where("(x >= ? AND x <= ?) AND (y >= ? AND y <= ?)",
                      x1, x2, y1, y2)
  end

  def self.item_at(x, y)
    Tile.tile_at(x, y).item
  end

  def self.character_at(x, y)
    Tile.tile_at(x, y).character
  end
end
