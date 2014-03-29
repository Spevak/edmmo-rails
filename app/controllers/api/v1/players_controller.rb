class Api::V1::PlayersController < Api::V1::BaseController

  #before_filter :validate
  def move
    @user = current_user
    @character = @user.character
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

    target_tile = Tile.tile_at(@character.tile.x + dx, @character.tile.y + dy)
    if target_tile == nil then
      render json: { 'err' => 1 }, status: 404
    else
      @character.move_to(target_tile.x, target_tile.y)
      render json: { 'err' => 0 }
    end
  end

  def pick_up(x, y, item_id)
    @user = current_user
    @character = @user.character
    target_tile = Tile.tile_at(x, y)
    if @character.item != nil then
      render json: { 'err' => 3 }, status: 404
    elsif target_tile == nil then
      render json: { 'err' => 0 }, status: 404
    elsif target_tile.item == item then
      @character.pick_up(item_id)
    else
      render json: { 'err' => 1 }, status: 404
    end
  end

  def drop(item_id)
    @user = current_user
    @character = @user.character
    if @character.item.id == item_id then
      @character.item = nil
    end
  end

  def use_item(x, y)
    # do nothing lol
    render json: { 'err' => 0 }
  end

  def status
    render json: current_user.character.status
  end

  def inspect
    @user = current_user
    render json: { 'err'  => 0,
                   'item' => @user.character.item }
  end

end
