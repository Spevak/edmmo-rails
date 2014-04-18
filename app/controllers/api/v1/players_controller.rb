class Api::V1::PlayersController < Api::V1::BaseController

  #before_filter :validate
  def move
    @user = current_user
    @character = @user.character

    direction = request[:direction] 

    #target_tile = Tile.tile_at(@character.tile.x + dx, @character.tile.y + dy)
    #puts "target tile:"
    #puts target_tile.x.to_s + "," + target_tile.y.to_s
    #puts "user's tile:"
    #puts @character.tile.x.to_s + "," + target_tile.y.to_s

    if @character.move_direction(direction) then
      render json: { 'err' => 0 }
    else
      render json: { 'err' => 1 }
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
