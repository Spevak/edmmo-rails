class Api::Test::WorldController < ApplicationController
  def tiles
    tile_list = Array.new
    for x in 0..24 do
      for y in 0.24 do
        tile_list << {:x => x, :y => y, :tile => 'ground'}
      end
    end
    
    render :json => {:tiles => tile_list, :player_x => 12, :player_y => 12}
  end
end
