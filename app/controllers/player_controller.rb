class PlayerController < ApplicationController
    # WEBPAGE
    def page
        @players = Players.all
        respond_to :html
    end
    
    def move
        # Take the user as a parameter, along with password
        mydir = params[:direction]
        returncode = Players.move(mydir)
        # Make a JSON for error and successful execution
        errJSON = {:errCode => returncode}
        returnJSON = {:errCode => $SUCCESS}
        
        # We can get away with this because 1 is the only successful error code
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end
    # LOGIN
    def pickup
        # Take the user as a parameter, along with password
        myx = params[:x]
        myy = params[:y]
        myID = params[:itemID]
        # The return value of the method call login()
        returncode = Users.pickup(myx, myy, myID)
        
        errJSON = {:errCode => returncode}
        returnJSON = {:errCode => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end

end
