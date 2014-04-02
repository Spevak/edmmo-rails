class Api::V1::WorldController < Api::V1::BaseController
  def tiles
    if user_signed_in? then
      character = current_user.character
      if !character then
        c = Character.new(health: 100, battery: 100, facing: 'north', name: nil)
        c.save
        t = Tile.tile_at(15, 15)
        t.character = c
        t.save
        current_user.character = c
        current_user.save
      end
    else
      render json: {}, status: :forbidden
    end

    character_tile = current_user.character.tile
    tiles_to_return = Tile.tiles_at(character_tile.x - n,
                                    character_tile.y - n, #lower left
                                    character_tile.x + n,
                                    character_tile.y + n) #upper right
    player_x, player_y = 0, 0
    tiles_to_return.each do |t|
      if t.character == character then
        player_x = t.x
        player_y = t.y
      end
    end

    render json: {
      tiles => tiles_to_return,
      player_x => player_x,
      player_y => player.y
    }
  end
end
