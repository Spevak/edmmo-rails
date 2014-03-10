class WorldController < ApplicationController

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
