class Api::V1::PlayersController < Api::V1::BaseController

  #before_filter :validate
  def move
    @user = current_user
    puts "User == nil: " 
    puts @user == nil
    @character = @user.character
    puts "character == nil: "
    puts @character == nil
    direction = request[:direction] 

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
    # the tile the character is moving to
    target_tile = Tile.tile_at(@character.tile.x + dx, @character.tile.y + dy)

    # get the tile properties from a json file
    require 'json'
    tile_properties_json = File.open("/Users/michelmikhail/Google Drive/Berkeley/Classes/cs 169/edmmo-rails/config/map/tiles/properties.json").read
    tile_properties = JSON[tile_properties_json]

    # if there target tile doesn't exist 
    if target_tile == nil
      render json: { 'err' => 1 }, status: 200

    # if the target tile is not traversable
    # Note: as of 4/16 ledges cannot be walked on so a value of 2 is nontraversable
    elsif [1, 2].include? (tile_properties[target_tile.tile_type.to_s]["traversable"][direction[0]])
      render json: { 'err' => 1 }, status: 200

    # if the character is out of battery or health
    elsif current_user.character.battery <= 0 or current_user.character.health <= 0
      render json: { 'err' => 1 }, status: 200

    # otherwise, move. Note: the health and battery are updated in character.move_to()
    else
        @character.move_to(target_tile.x, target_tile.y)
        render json: { 'err' => 0 }
      
    end
  end

  def pickup
    x = request[:x].to_i
    y = request[:y].to_i
    item_id = request[:item_id].to_i
    @user = current_user
    @character = @user.character
    target_tile = Tile.tile_at(x, y)
    if @character.item != nil then
      render json: { 'err' => 3 }, status: 200
    elsif target_tile.id != @character.tile.id then
      render json: { 'err' => 2 }, status: 200
    elsif (target_tile.item == nil) || target_tile.item.id != item_id then
      render json: { 'err' => 1 }, status: 200
    else
      @character.pick_up(item_id)
      target_tile.item = nil
      target_tile.save!
      render json: { 'err' => 0 }
    end
  end

  def drop
    item_id   = request[:item_id].to_i
    user      = current_user
    character = user.character
    tile      = character.tile
    if (character.item == nil) or character.item.id !=  item_id then
      render json: {
        'err' => 1
      }
    elsif tile.item != nil then
      render json: {
        'err' => 2
      }
    else
      character.drop(item_id)
      render json: {
        'err' => 0
      }
    end
  end

  def use
    # do nothing lol
    x = request[:x]
    y = request[:y]
    item_id = request[:item_id]
    @user = current_user
    @character = @user.character
    if (@character.item == nil) or @character.item.id != item_id.to_i then
      render json: {
        'err' => 1
      }
    else
      render json: {
        'err' => 0
      }
    end
  end

  def status
    render json: current_user.character.status
  end

  def inspect
    item_id = request[:item_id]
    @user = current_user
    @character = @user.character
    if (@character.item == nil) or @character.item.id != item_id.to_i then
      render json: {
        'err'  => 1,
      }
    else
      render json: {
        'err' => 0,
        'item' => @user.character.item
      }
    end
  end

  def characters
    render json: Character.all
  end

  def dig
    # for now digging is always successful
    # consider doing something as simple as allowing digging a third of the time
    #   success = rand(3); if success == 1 then
    success = true
    if success then
      current_user.character.battery += 10
      current_user.character.save!
      # render json: {err: 0} - Michel: Why did this have a different json syntax?
      render json: { 'err' => 0 }
    else
      # render json: {err: 1}
      render json: { 'err' => 1 }, status: 200
    end
  end
end
