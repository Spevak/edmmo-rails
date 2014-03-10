class PlayerController < ApplicationController
    # WEBPAGE
    def page
        @players = Players.all
        respond_to :html
    end
    # MOVE
    def move
        # Take the user as a parameter, along with password
        mydir = params[:direction]
        if mydir.nil?
            returnJSON = {:err => 1}
            render :json => returnJSON
        else
            returnJSON = {:err => 0}
            render :json => returnJSON
        end
    end
    # PICKUP
    def pickup
        # Take the user as a parameter, along with password
        myx = params[:x]
        myy = params[:y]
        myID = params[:itemID]
        # The return value of the method call login()
        if myx.nil? or myy.nil? or myID.nil?
            returnJSON = {:err => 1}
            render :json => returnJSON
            else
            returnJSON = {:err => 0}
            render :json => returnJSON
        end
    end
    # DROP
    def drop
        # Take the user as a parameter, along with password
        myID = params[:itemID]
        # The return value of the method call login()
        if myID.nil?
            returnJSON = {:err => 1}
            render :json => returnJSON
            else
            returnJSON = {:err => 0}
            render :json => returnJSON
        end
    end
    # USE
    def use
        # Take the user as a parameter, along with password
        myID = params[:itemID]
        myArgs = params[:args]
        # The return value of the method call login()
        if myID.nil? or myArgs.nil?
            returnJSON = {:err => 1}
            render :json => returnJSON
            else
            returnJSON = {:err => 0}
            render :json => returnJSON
        end
    end
    # STATUS
    def status
        if params.length != 0
            returnJSON = {:err => 1}
            render :json => returnJSON
            else
            returnJSON = {hp: 10,
                battery: 10,
                facing: 'north'}
            render :json => returnJSON
        end
    end
    # INSPECT
    def inspect
        myID = params[:itemID]
        if myID.nil?
            returnJSON = {:err => 1}
            render :json => returnJSON
            else
            returnJSON = {:err => 0}
            render :json => returnJSON
        end

end
