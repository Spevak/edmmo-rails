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
      return
    end

    character_tile = current_user.character.tile
    if (!character_tile)
      character_tile = Tile.first
      character_tile.character = current_user.character
      character_tile.save
    end
    tiles_to_return = Tile.tiles_at(character_tile.x - n,
                                    character_tile.y - n, #lower left
                                    character_tile.x + n,
                                    character_tile.y + n) #upper right
    player_x = character_tile.x
    player_y = character_tile.y

    # Create a hash of { tile xy pair hash => character on tile } entries
    other_players = (tiles_to_return.map do |tile|
      if tile.character and tile.character != character then
        { tile.x_y_pair => tile.character }
      end
    end)
    .select { |entry| !(entry.nil?) } # Remove nil entries (characterless tiles)
    .inject { |hash, hashlet| hash.merge(hashlet) } # Combine into one hash

    # Create a hash of { tile xy pair hash => item on tile } entries
    world_items = (tiles_to_return.map do |tile|
      if tile.item then
        { tile.x_y_pair => tile.item }
      end
    end)
    .select { |entry| !(entry.nil?) } # Remove nil entries (itemless tiles)
    .inject { |hash, hashlet| hash.merge(hashlet) } # Combine into one hash

    render json: {
      :tiles         => tiles_to_return,
      :player_x      => player_x,
      :player_y      => player_y,
      :other_players => other_players || {}, # always send a map
      :world_items   => world_items || {}
    }
  end
end
