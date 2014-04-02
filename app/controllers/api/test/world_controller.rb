class Api::Test::WorldController < ApplicationController
  def tiles
    tile_list = Array.new
    (1..25).each do |x|
      (2..26).each do |y|
        #for the test we will return a map of all 0s with corners numbered 1 through 4
        #nw: 1, ne: 2, sw: 3, se: 4
        tile = 0
        #sw
        if x == 1 and y == 2 then tile = 3 end
        #nw
        if x == 1 and y == 26 then tile = 1 end
        #se
        if x == 25 and y == 2 then tile = 4 end
        #ne
        if x == 25 and y == 26 then tile = 2 end

        tile_list << {:x => x, :y => y, :tile => tile}
      end
    end
    
    render :json => {:tiles => tile_list, :player_x => 13, :player_y => 14}
  end
end
