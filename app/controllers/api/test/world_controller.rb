class Api::Test::WorldController < ApplicationController
  def tiles
    render :json => {:tiles => [{:x => 0, :y => 0, :tile => 'ground'},
                                {:x => 0, :y => 1, :tile => 'ground'},
                                {:x => 1, :y => 0, :tile => 'ground'},
                                {:x => 1, :y => 1, :tile => 'stuff'}]}
  end
end
