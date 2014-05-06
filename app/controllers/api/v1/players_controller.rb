class Api::V1::PlayersController < Api::V1::BaseController

  before_filter :check_signed_in

  def check_signed_in
    unless user_signed_in?
      render json: {}, status: 404
      return 
    end
  end

  # Face a direction (N/S/E/W)
  def face
    @user = current_user
    @character = @user.character

    direction = request[:direction]
    if @character.face(direction) then
      render json: { 'err' => 0 }
    else
      render json: { 'err' => 1 }
    end
  end

  # Move the current player in the request[:direction] direction (N/S/E/W)
  def move
    @user = current_user
    @character = @user.character
    direction = request[:direction] 

    # if battery is <= 0 then dont bother calling move_direction
    if current_user.character.battery <= 0
      render json: { 'err' => 2 }, status: 200
      return
    end
    # move_direction returns the proper error code 0, 1, or 2
    render json: { 'err' => @character.move_direction(direction) }
  end

  def pickup
    x = request[:x].to_i
    y = request[:y].to_i
    item_id = request[:item_id].to_i
    @user = current_user
    @character = @user.character
    target_tile = Tile.tile_at(x, y)
    if target_tile.id != @character.tile.id then
      render json: { 'err' => 2 }, status: 200
    # That item isn't on this tile
    elsif (target_tile.item == nil) || target_tile.item.id != item_id then
      render json: { 'err' => 1 }, status: 200
    # Pick it up
    else
      @character.pick_up(Item.find(item_id))
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
    # first check if there is already an item on this tile
    if tile.item != nil
      render json: { 'err' => 2 }
      return
    end
    # If the item in hand is the item desired, then drop it
    if !character.item.nil? 
      if character.item.id == item_id 
        character.drop(item_id)
        render json: { 'err' => 0 }
        return
      end
    end
    # otherwise if the item is in the inventory, then drop it
    if (character.inventory.items.map{|x| x.id == item_id}.include? true)
      character.drop(item_id)
      render json: { 'err' => 0 }
    # otherwise, there is no item to be used
    else
      render json: { 'err' => 1 }
    end
  end

  def use
    item_id = request[:item_id].to_i
    # If that item_id doesn't exist, then error
    item = Item.find(item_id) rescue nil
    if item.nil?
      render json: { 'err' => 1 }
      return
    end
    @user = current_user
    @character = @user.character
    # If the item in hand is the item desired, then use it
    if !@character.item.nil? 
      if @character.item.id == item_id 
        if @character.use_item(item)
          render json: { 'err' => 0 }
        else
          render json: { 'err' => 3 }
        end
        return
      end
    end
    # otherwise if the item is in the inventory, then use it
    if (@character.inventory.items.map{|x| x.id == item.id}.include? true)
      if @character.use_item(item)
        render json: { 'err' => 0 }
      else
        render json: { 'err' => 3 }
      end
    # otherwise, there is no item to be used
    else
      render json: { 'err' => 1 }
    end
  end

  def status
    if user_signed_in?
      render json: current_user.character.status
    else
      render json: {}, status: 404
    end
  end

  def inspect
    args = request[:args]
    @user = current_user
    @character = @user.character
    facing = @character.facing
    tile = @character.tile
    to_inspect = tile.neighbor(facing)
    msg = to_inspect.inspect_tile(@character, args)
    type = to_inspect.tile_type
    render :json => {:err => 0, :type => type, :msg => msg}
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
      i = Item.from_data(ITEM_PROPERTIES["potato"])
      i.save
      current_user.character.pick_up(i)
      render json: { 'err' => 0, 'id' => i.id }
    else
      render json: { 'err' => 1 }, status: 200
    end
  end
end
