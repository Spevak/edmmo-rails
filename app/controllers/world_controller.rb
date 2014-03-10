class WorldController < ApplicationController

    # WEBPAGE
    def page
        @worlds = Worlds.all
        respond_to :html
    end
    # MOVE
    def tiles
        # Take the user as a parameter, along with password
        myDim = params[:n]
        if myID.n?
            returnJSON = {:err => 1}
            render :json => returnJSON
            else # This is a placeholder since no access to activeRecords
            returnJSON = {:err => 0}
            render :json => returnJSON
        end


end
