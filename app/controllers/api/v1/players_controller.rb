class Api::V1::PlayersController < Api::V1::BaseController

  #before_filter :validate
  def move_to(direction)
    @user = current_user
    direction = request[:direction] 

    case direction
    when 'north'
      dx, dy = 0, 1
    when 'south'
      dx, dy = 0, -1
    when 'east'
      dx, dy = 1, 0
    when 'west'
      dx, dy = -1 0
    else
      dx, dy = 0, 0
    end

    target_tile = Tile.tile_at(@user.tile.x + dx, @user.tile.y + dy)
    if target_tile == nil then
      render json: { 'err' => 1 }, status: 404
    end
    @user.move_to(target_tile)
    render json: { 'err' => 0 }
  end

  def pick_up(x, y, item_id)
    target_tile = Tile.tile_at(x, y)
    if target_tile == nil then
      render json: { 'err' => 1 }, status: 404
    end
    if target_tile.item == item then
      @user.pick_up(item.id)
    end
  end

  def use_item(x, y)
    # do nothing lol
    render json: { 'err' => 0 }
  end
end
