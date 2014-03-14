class Api::Test::WorldController < ApplicationController
  def tiles
    tile_list = Array.new
    (1..25).each do |x|
      (2..26).each do |y|
        tile_list << {:x => x, :y => y, :tile => 0}
      end
    end
    
    render :json => {:tiles => tile_list, :player_x => 13, :player_y => 14}
  end
end
