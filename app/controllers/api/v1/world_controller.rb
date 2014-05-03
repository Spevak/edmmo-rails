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
        t = Tile.tile_at(10, 10)
        t.character = c
        t.save
        current_user.character = c
        current_user.save
      end
    else
      render json: {}, status: :forbidden
      return
    end

    character = current_user.character
    if (!character.tile)
      character.tile = Tile.first
      character.save
    end
    tiles_to_return = Tile.tiles_at(character.x - n,
                                    character.y - n, #lower left
                                    character.x + n,
                                    character.y + n) #upper right

    tiles_to_return ||= Hash.new # no nil map errors...

    # Create a hash of { tile xy pair hash => character on tile } entries
    other_players = (tiles_to_return.map do |tile|
      tile_chars = tile.logged_in_characters
      if tile_chars.include? character then
        { tile.x_y_pair => character }
      elsif !(tile_chars.empty?) then
        { tile.x_y_pair => tile.characters.first }
      end # emits nil if above not executed
    end).inject { |hash, hashlet| hash.to_h.merge(hashlet.to_h) }
    # Combine into one hash, removing nil entries

    # Create a hash of { tile xy pair hash => item on tile } entries
    world_items = (tiles_to_return.map do |tile|
      if tile.item then
        { tile.x_y_pair => tile.item }
      end
    end).inject { |hash, hashlet| hash.to_h.merge(hashlet.to_h) }
    # Combine into one hash, removing nil entries

    render json: {
      :tiles         => tiles_to_return,
      :player_x      => character.x,
      :player_y      => character.y,
      :other_players => other_players || {}, # always send a map
      :world_items   => world_items || {}
    }
  end
end
