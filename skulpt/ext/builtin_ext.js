//////////////////////////////////////////////////////////////////////////////////////
//SUCCESS AND FAILURE FUNCTIONS (DEFINES HOW TO HANDLE A RESPONSE TO A JSON REQUEST //
//////////////////////////////////////////////////////////////////////////////////////

/**
 * Generates the functions which are to be called on a non-200 response.
 * args: path = the path of the request
 * returns: the function to be called on a non-200 response to the request
 */
function failureFunction(path) {
    var str = "Error on call to " + path +  ". Response: ";
    return function(status) {
	return new Sk.builtin.str(str + status);
    };
}

/**
 * Function to be called on success of a call to players/go
 * args: response = the json response to the go request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function goSuccess(response) {
    //if (response.err === 1)
    //    return new Sk.builtin.str("Can’t walk there...");
    //if (response.err === 2)
    //    return new Sk.builtin.str("Immobilized!");
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

/**
 * Function to be called on success of a call to players/pickup
 * args: response = the json response to the request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function pickupSuccess(response) {
    //if (response.err === 1)
    //    return new Sk.builtin.str("That item isn't there!");
    //if (response.err === 2)
    //    return new Sk.builtin.str("You can't access this tile!");
    return new Sk.builtin.nmber(response, Sk.builtin.nmber.int$);
}

/**
 * Function to be called on success of a call to players/drop
 * args: response = the json response to the request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function dropSuccess(response) {
    //if (response.err === 1)
    //    return new Sk.builtin.str("You don't have that item!");
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

/**
 * @suppress {missingProperties}
 */
function useSuccess(response) {
    //if (response.err === 1)
    //    return new Sk.builtin.str("You don't have that item!");
    //if (response.err === 2)
    //    return new Sk.builtin.str("Erm... I don't think you can do that with that item.");
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

/**
 * Function to be called on success of a call to players/status
 * args: response = the json response to the request
 * returns: a python dict indicating the player's status, containing 3 keys: hp, battery, and facing
 * @suppress {missingProperties}
 */
function statusSuccess(response) {
    return new Sk.builtin.tuple((response.hp, response.battery, response.facing));
} 


/**
 * Function to be called on success of a call to players/inspect
 * args: response = the json response to the request
 * returns: python dict containing all the information about an item, or python None if the player 
 * does not have access to that item.  
 * @suppress {missingProperties}
 */
function inspectSuccess(response) {

    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);

}

/**
 * Function to be called on success of a call to world/tiles
 * args: response = the json response to the request
 * returns: 2d python array of cells (each cell is a python integer) corresponding to the square of
 * terrain surrounding a character.
 * @suppress {missingProperties}
 */
function tilesSuccess(response) {
    //side length of map
    var n = 2 * MAP_MAX_INDEX + 1;

    //Semi-jank implementation atm because iter 1 is due in 3 hours.
    //may want to implement more elegantly later

    var player_x = response.player_x;
    var player_y = response.player_y;
    // Coordinates of bottom left corner
    var sw_x = player_x - MAP_MAX_INDEX;
    var sw_y = player_y - MAP_MAX_INDEX;
    var tiles = response.tiles;

    var map  = [];
    for (var i = 0; i < n; i++) {
	var row = [];
	for (var j = 0; j < n; j++) {
	    row.push(1);
	}
	map.push(row);
    }
    for (i = 0; i < tiles.length; i++) {
	var x = tiles[i].x;
	var y = tiles[i].y;
	if ( x-sw_x < 0 || x-sw_x > 24 || y-sw_y < 0 || y-sw_y > 24) {
	    alert(x);
	    alert(y);
	}
	map[x-sw_x][y-sw_y] = new Sk.builtin.nmber(tiles[i].tile, Sk.builtin.nmber.int$);
    }

    var pyMap = [];
    for (var x = 0; x < n; x++) {
	pyMap.push(new Sk.builtin.list(map[x]));
    }


    //for (var i=0;i<response.tiles.length;i+=n) {
    //    var localArr = new Array();
    //    for (var j=0;i<n;j++) {
    //        localArr[j] = response.tiles.name[i + j];
    //    }
    //    var insertArr = new Sk.builtin.list(localArr);
    //    arrOfArrs[(i / n)] = insertArr;
    //}
    return new Sk.builtin.list(pyMap);
}

/**
 * Function to be called on success of a call to players/characters
 * args: response = the json response to the request
 * returns: python list of characters. Characters are python objects (not sure yet how they 
 * should be represented: builtin class or dictionary?) 
 * @suppress {missingProperties}
 */
function charactersSuccess(response) {
    return new Sk.builtin.str("charactersSuccess response handling not yet implemented");
  

}
//////////////////////////////////////////////////////////////////////////////////////
// UTILITY FUNCTIONS AND GAME STATE                                                 //
//////////////////////////////////////////////////////////////////////////////////////
/**
 * Makes a json request to the backend.
 * args: type = the type of request, either 'GET' or 'POST'
 *       page = the path of the request being made. e.g. api/test/player/go.  A variable for each path is
 *              defined in paths.js; use these variables so we don't have to change code if actual paths
 *              change.  e.g. GO_PATH
 *       successFunction = function to be called on 200 status response.  This should contain everything the 
 *              frontend is expected to do with the json response. 
 *       failureFunction = the function to be called on non-200 status response.  This is more generic than
 *              the success function, as it only needs to handle a failed request and does not have to interpret
 *              and act on a json response.
 *       dict = a dictionary to be converted into json format and sent along with the request.
 * @suppress {missingProperties}
 */
function json_request(type, page, successFunction, failureFunction, dict) {
 
   //Jquery-free implimentation of ajax request since Skulpt is compiled without jquery
    var ajaxFinished = false;
    var result;
    var http = new XMLHttpRequest();
    //3rd param: set to false to make request NOT asynchronous, since we need the result before returning
    http.open(type, page, false);
    http.setRequestHeader("Content-type", "application/json");
    //get the csrf token
    var metadata = document.getElementsByTagName('meta');
    var token = 'no token found'
    for (var i = 0; i < metadata.length; i++)  {
	if (metadata[i].getAttribute('name') == 'csrf-token') {
	    token = metadata[i].getAttribute('content');
	}
    }
    http.setRequestHeader("X-CSRF-Token", token);

    //Send request
    http.send(JSON.stringify(dict));

    //Handle response 
    if (http.status === 200) {
	return successFunction(JSON.parse(http.responseText));
    }
    return failureFunction(JSON.parse(http.responseText));		
    
}

//Position of the player.  Initialize to (0,0), north but update when we get data from the server.
//var character_x = 0;
//var character_y = 0;

//////////////////////////////////////////////////////////////////////////////////////
// ADDITIONAL BUILT-IN FUNCTION DEFINITIONS                                         //
//////////////////////////////////////////////////////////////////////////////////////

/**
 * Implementation of the built-in python funtion 'go'
 *   args: dir = python string. Should be one of 'north', 'south', 'east', 'west'
 * @suppress {missingProperties}
 */
Sk.builtin.goFunction = function(dir) {
    Sk.builtin.pyCheckArgs("goFunction", arguments, 1, 1);
    Sk.builtin.pyCheckType("dir", "string", Sk.builtin.checkString(dir));
    // get the string from the python representation (there may be a better way to do this)
    var direction = dir.v

    var goFailure = failureFunction(MOVE_PATH);
    return json_request('POST', MOVE_PATH, goSuccess, goFailure, {'direction': direction});
}

/**
 * Implementation of the built-in python funtion 'pickup'
 *   args: x = python integer indicating x coordinate of item to pickup
 *         y = python integer indicating y coordinate of item to pickup
 *         ID = python string indicating id of item to pickup
 * @suppress {missingProperties}
 */
Sk.builtin.pickupFunction = function(x, y, ID) {
    //Check argument count and types
    Sk.builtin.pyCheckArgs("pickupFunction", arguments, 3, 3);
    Sk.builtin.pyCheckType("x", "integer", Sk.builtin.checkInt(x));
    Sk.builtin.pyCheckType("y", "integer", Sk.builtin.checkInt(y));
    Sk.builtin.pyCheckType("ID", "string", Sk.builtin.checkString(ID));

    //Get Values from python representation
    var x_val = Sk.builtin.asnum$(x);
    var y_val = Sk.builtin.asnum$(y);
    var item_id = ID.v;

    var pickupFailure = failureFunction(PICKUP_PATH)
    return json_request('POST', PICKUP_PATH, pickupSuccess, pickupFailure, {'x': x_val, 'y': y_val, 'itemID': item_id});
}

/**
 * Implementation of the built-in python funtion 'drop'
 *   args: ID = python string indicating id of item to drop
 * @suppress {missingProperties}
 */
Sk.builtin.dropFunction = function(ID) {
    //Check arg count and types
    Sk.builtin.pyCheckArgs("dropFunction", arguments, 1, 1);
    Sk.builtin.pyCheckType("ID", "string", Sk.builtin.checkString(ID));

    //get values from python representation
    var item_id = ID.v

    var dropFailure = failureFunction(DROP_PATH);
    return json_request('POST', DROP_PATH, dropSuccess, dropFailure, {'itemID': item_id});
}

/**
 * Implementation of the built-in python funtion 'use'
 *   args: ID = python string indicating id of item to use
 *         args = python string of arguments to the item's use function 
 * @suppress {missingProperties}
 */
Sk.builtin.useFunction = function(ID, args) {
    //Check arg count and types
    Sk.builtin.pyCheckArgs("useFunction", arguments, 2, 2);
    Sk.builtin.pyCheckType("ID", "string", Sk.builtin.checkString(ID));
    Sk.builtin.pyCheckType("args", "string", Sk.builtin.checkString(args));

    //get values from python representation
    var item_id = ID.v;
    var use_args = args.v;

    var useFailure = failureFunction(USE_PATH);
    return json_request('POST', USE_PATH, useSuccess, useFailure, {'itemID': item_id, 'args': use_args});
}

/**
 * Implementation of the built-in python funtion 'status'
 * @suppress {missingProperties}
 */
Sk.builtin.statusFunction = function() {
    //check args count and types
    Sk.builtin.pyCheckArgs("statusFunction", arguments, 0, 0);

    var statusFailure = failureFunction(STATUS_PATH);
    return json_request("GET", STATUS_PATH, statusSuccess, statusFailure, {});
}

/**
 * Implementation of the built-in python funtion 'inspect'
 *   args: ID = python string containing id of item to inspect
 * @suppress {missingProperties}
 */
Sk.builtin.inspectFunction = function(ID) {
    //check args count and types
    Sk.builtin.pyCheckArgs("inspectFunction", arguments, 1, 1);
    Sk.builtin.pyCheckType("ID", "string", Sk.builtin.checkString(ID));

    //get the value from the python representation 
    var item_id = ID.v

    var inspectFailure = failureFunction(INSPECT_PATH);
    return json_request("GET", INSPECT_PATH, inspectSuccess, inspectFailure, {'itemID': item_id});
}

/**
 * Implementation of the built-in python funtion 'characters'
 * @suppress {missingProperties}
 */
Sk.builtin.charactersFunction = function() {
    //check args count and types
    Sk.builtin.pyCheckArgs("charactersFunction", arguments, 0, 0);

    var charactersFailure = failureFunction(CHARACTERS_PATH);
    return json_request("GET", CHARACTERS_PATH, charactersSuccess, charactersFailure, {});
}

/**
 * Implementation of the built-in python funtion 'tiles' 
 * @suppress {missingProperties}
 */
Sk.builtin.tilesFunction = function() {
    //check args count and types
    Sk.builtin.pyCheckArgs("tilesFunction", arguments, 0, 0);

    var tilesFailure = failureFunction(TILES_PATH);
    return json_request("GET", TILES_PATH, tilesSuccess, tilesFailure, {});
}

