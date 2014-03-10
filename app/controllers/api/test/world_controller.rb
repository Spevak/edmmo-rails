class Api::Test::WorldController < ApplicationController
  def tiles
    n = request[:n]
    puts request.body()
    if n
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end
  end
end
