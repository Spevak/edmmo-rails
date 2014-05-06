require 'user'
require 'tile'
require 'item'
require 'inventory'

class Character < ActiveRecord::Base
  belongs_to :item
  has_one :user
  belongs_to :tile
  belongs_to :inventory

  after_create do |c|
    i = Inventory.create
    c.inventory = i
    c.battery = 100
    c.health  = 100
    c.facing = "north"
    c.save
  end

  def self.with_name(name)
    c = Character.new(name: name)
    return c
  end

  # Face the given direction.
  def face(direction)
    directions = {
      'north' => 0,
      'east'  => 1,
      'south' => 2,
      'west'  => 3
    }
    if directions.keys.include? direction
      self.facing = directions[direction]
      self.save
      return true
    end

    false #return false on failure...
  end

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
      return 1
    end

    #find the tile to be moved to
    x = self.tile.x + dx
    y = self.tile.y + dy
    target_tile = Tile.tile_at(x, y)

    if target_tile == nil then
      return 1
    end

    #Make sure it is valid to walk over the tile
    target_tile_props = TILE_PROPERTIES[target_tile.tile_type.to_s]
    current_tile_props = TILE_PROPERTIES[self.tile.tile_type.to_s]
    leaving_traversable = current_tile_props["traversable"][leave_dir]
    entering_traversable = target_tile_props["traversable"][enter_dir]
    if [3, 1].include? leaving_traversable or
      [2, 1].include? entering_traversable or
      !(target_tile.characters.select { |c| c.user.logged_in }).empty? then
      return 1
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

    # Use heal & charge to check if move is allowed
    if !heal(TILE_PROPERTIES[target_tile.tile_type.to_s]["healtheffect"][enter_dir]) or !charge(TILE_PROPERTIES[target_tile.tile_type.to_s]["batteffect"][enter_dir])
      return 2
    end

    self.move_to(x, y)
    return 0
  end

  def move_to(x, y)
    #update tile
    tile = Tile.tile_at(x, y)
    oldTile = self.tile

    #Don't move to same tile as this causes strange bug
    #where character's association with a tile is deleted.
    if tile != oldTile then
      self.tile = tile
      self.save
      #trigger any events that happen when you enter the new tile
      tile.on_enter(self)
    end
  end

  def pick_up(item)
    if (self.item) then
      inventory = self.inventory
      inventory.items << item
      inventory.save
    else
      self.item = item
      self.save!
    end
  end

  # Remove all the items from this character
  # (not to be called by the external API)
  def divest
    # remove my current item
    self.item = nil
    self.save

    # remove my inventory
    self.inventory.destroy!
    self.inventory = Inventory.create
  end

  def drop(item_id)
    item = Item.find(item_id)
    # if item is in the inventory
    if self.inventory.items.map{|x| x.id == item_id}.include? true 
      self.inventory.items.delete(item)
      self.inventory.save!
    # if the item is the one in hand
    elsif !self.item.nil?
      if self.item.id == item_id 
        self.item = nil
        self.save
      end
    end
    # put the dropped item on this tile
    if self.tile 
      t = self.tile
      t.item = item
      t.save!
    end
  end

  def use_item(item, *args)
    # if it's the item in-hand 
    if !self.item.nil? and self.item.id == item.id
      item.character = self
      item.do_action
    # if it's in the inventory
    elsif self.inventory.items.map{|x| x.id == item.id}.include? true #self.inventory.items.include? item
      # put item currently in hand in the inventory
      if !self.item.nil?
        inventory.items << self.item
      end
      self.item = item
      self.save!
      item.character = self
      return item.do_action
    end
  end

  def status
    inventory = self.inventory.items.map do |item|
      { item.item_type => item }
    end
    { 
      :health => self.health || 100,
      :battery => self.battery || 100,
      :facing => self.facing || 'north',
      :x => self.x,
      :y => self.y,
      :inventory => inventory
    }
  end

  def x
    if self.tile then
      self.tile.x
    else
      -1
    end
  end

  def y
    if self.tile then
      self.tile.y
    else
      -1
    end
  end

  # Take damage, or heal me if the amount is negative.
  # Use this instead of directly setting so we can check if the player died.
  def heal(amount)
    # Make sure health stays >= 0 and <= 100
    new_health = self.health + amount
    if new_health < 0 or new_health > 100
      return false
    end
    # Update health
    self.health = new_health
    self.save!
    return true
  end

  def charge(amount)
    # Make sure battery stays >= 0 and <= 100
    new_battery = self.battery + amount
    if new_battery < 0 or new_battery > 100
      return false
    end
    # Update battery
    self.battery = new_battery
    self.save!
    return true
  end

end
