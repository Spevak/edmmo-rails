class Api::Test::PlayerController < ApplicationController

  def move
    dir = request[:direction]
    if dir == 'north' or dir == 'east'
      render :json => {:err => 0}
    elsif dir == 'south'
      render :json => {:err => 2}
    else
      render :json => {:err => 1}
    end
  end

  def pickup
    #x = request[:x]
    #y = request[:y]
    id = params[:item_id]

    if id == 1 #"nowhere"
      render :json => {:err => 2} #can't access 
    elsif id == 2 #"handsfull"
      render :json => {:err => 3} #hands are full
    elsif id == 0 #"cake"
      render :json => {:err =>1} #doesn't exist
    else
      render :json => {:err => 0} #success
    end
  end

  def drop
    id = request[:item_id]
    if id == 3 #'nothing'
      render :json => {:err => 1}
    elsif id ==4 #'occupied'
      render :json => {:err => 2}
    else
      render :json => {:err => 0}
    end
  end

  def dig
    render :json => {:err => 0}
  end

  def use
    id = request[:item_id]
    args = request[:args]
    if id == 0 #'cake'
      render :json => {:err => 1}
    elsif args == 'bad'
      render :json => {:err => 2}
    else
      render :json => {:err => 0}
    end
  end

  def status
    render :json => {:x => 13, :y => 13, :hp => 100, :battery => 100, :facing =>0}
  end

  def inspect
    id = params[:item_id]
    if id == 0 #'cake'
      render :json => {:err => 1}
    else
      render :json => {:err => 0}
    end 
  end

  def characters
    render :json => {:err => 0}
  end

end
