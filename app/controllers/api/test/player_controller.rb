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

  def drop
    id = request[:itemID]
    if myID
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end 
  end

  def use
    id = request[:itemID]
    args = request[:args]
    if id and args
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end 
  end

  def status
    render :json => {:err => 1}
  end

  def inspect
    id = params[:itemID]
    if id
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end 
  end

  def characters
    render :json => {:err => 1}
  end

end
