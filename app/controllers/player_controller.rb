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
        returncode = Players.move(mydir)
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
    # PICKUP
    def pickup
        # Take the user as a parameter, along with password
        myx = params[:x]
        myy = params[:y]
        myID = params[:itemID]
        # The return value of the method call login()
        returncode = Players.pickup(myx, myy, myID)
        
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end
    # DROP
    def drop
        # Take the user as a parameter, along with password
        myID = params[:itemID]
        # The return value of the method call login()
        returncode = Players.drop(myID)
        
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end
    # USE
    def use
        # Take the user as a parameter, along with password
        myID = params[:itemID]
        myArgs = params[:args]
        # The return value of the method call login()
        returncode = Players.use(myID, myArgs)
        
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end
    # STATUS
    def status
        returncode = Players.status()
        
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end
    # INSPECT
    def inspect
        myID = params[:itemID]
        returncode = Players.inspect(myID)
        
        errJSON = {:err => returncode}
        returnJSON = {:err => $SUCCESS}
        
        if returncode == -1
            render :json => errJSON
            else
            render :json => returnJSON
        end
    end

end
