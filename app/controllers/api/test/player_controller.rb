class Api::Test::PlayerController < ApplicationController

  def move
    dir = request[:direction]
    if dir
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end
  end

  def pickup
    x = request[:x]
    y = request[:y]
    id = params[:itemID]

    if x and y and id
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end
  end
end
