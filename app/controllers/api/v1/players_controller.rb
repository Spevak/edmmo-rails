class Api::V1::PlayersController < Api::V1::BaseController

  before_filter :check_signed_in

  def check_signed_in
    unless user_signed_in?
      render json: {}, status: 404
      return 
    end
  end

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
    item_id = request[:item_id]
    @user = current_user
    @character = @user.character
    if (@character.item == nil) or @character.item.id != item_id.to_i then
      render json: {
        'err' => 1
      }
    else
      item = Item.find(item_id)
      @character.use_item(item)
      render json: {
        'err' => 0
      }
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
    #for now digging is always successful
    success = true
    if success then
      current_user.character.battery += 10
      current_user.character.save!
      render json: {err: 0}
    else
      render json: {err: 1}
    end
  end
end
