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
        returncode = Worlds.tiles(myDim)
        # Make a JSON for error and successful execution
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
    
        # We can get away with this because 1 is the only successful error code
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end


end
