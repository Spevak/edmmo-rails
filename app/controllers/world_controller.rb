class WorldController < ApplicationController
    def tile
        character_id = request["character_id"]
        n = request["n"]
        tiles_to_return = []
        character_tile = Character.find(character_id)
        character_pos = [character_tile.x, character_tile.y]
        tiles_to_return = Tiles.tiles_at(character_pos[0]-n, character_pos[1]-n, character_pos[0]+n, character_pos[1]+n)
        render json: tiles_to_return
    end
    def editor
      unless Rails.env.development? then
        raise ActionController::RoutingError.new('Not Found')
      end
    end
end
