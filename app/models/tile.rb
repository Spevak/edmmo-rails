# A tile on the map in BotQuest. Tiles are 0-indexed (coords begin at 0.)
class Tile < ActiveRecord::Base
  # Side length of the map.
  MAP_SIDE_LENGTH = 25

  belongs_to :item
  has_many :characters

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

  def self.characters_at(x, y)
    t = Tile.tile_at(x, y)
    if t 
      t.characters
    else
      nil
    end
  end

  def on_enter(char)
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

  #return the tile in a given direction from the current tile.
  def neighbor(dir)
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
    return Tile.tile_at(self.x + dx, self.y + dy)
  end

  #char = character that is doing the inspecting.
  #args = their arguments (empty string if no args)
  def inspect_tile(char, args = "")
    case self.tile_type
    when 16 #sign
      self.state ||= ""
      self.save
      return "Sign: '" + self.state + "'"
    when 14 #locked door
      #if request made with no args, just checking what the tile is, not entering a password
      if args == "" then
        return "The door is locked with a password"
      end

      #check if password is correct
      if args == self.state then
        char.move_to(self.x, self.y)
        
        return "Password Correct!"
      else 
        return "Access Denied!"
      end
    else
      return "..."
    end
  end

  def logged_in_characters
    self.characters.select{ |c| c.user.logged_in }
  end

end
