class Api::V1::WorldController < Api::V1::BaseController
    def tiles
        if user_signed_in? then
          character = current_user.character
        else
          render json: {}, status: :forbidden
        end

        character_tile = Character.find(character.tile)
        tiles_to_return = Tile.tiles_at(character_tile.x - n,
                                        character_tile.y - n,
                                        character_tile.x + n,
                                        character_tile.y + n)
        player_x, player_y = 0, 0
        tiles_to_return.each do |t|
          if t.character == character then
            player_x = t.x
            player_y = t.y
          end
        end

        render json: { tiles => tiles_to_return,
                       player_x => player_x,
                       player_y => player.y }
    end
end
