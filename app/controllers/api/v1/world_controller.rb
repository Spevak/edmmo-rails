class Api::V1::WorldController < Api::V1::BaseController
  def tiles
    #Max index on map with character at (0,0) (same as MAP_MAX_INDEX from the front end)
    #Make this set by some sort of configuration instead of hard coded?
    n = MAP_MAX_INDEX
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
    #player_x, player_y = 0, 0
    #tiles_to_return.each do |t|
    #  if t.character == character then
    #    player_x = t.x
    #    player_y = t.y
    #  end
    #end
    player_x = character_tile.x
    player_y = character_tile.y

    render json: {
      :tiles => tiles_to_return,
      :player_x => player_x,
      :player_y => player_y
    }
  end
end
