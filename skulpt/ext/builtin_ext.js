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
    log(str + status);
    //todo: throw python error instead of printing string
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
//Change for iter 2: replace goSuccess with function that takes a direction as an arg and returns a success
//function for going that direction 
function goSuccessFunction(dir) {
  return function(response) {
    //For now, reload map and player data every time we take a step
    Sk.builtin.statusFunction();
    Sk.builtin.tilesFunction();

    if (response.err === 0) {
      var x = Bq.playerData.x.toString();
      var y = Bq.playerData.y.toString();
      log('Took a step '+dir+'. Now at position (' + x + ', ' + y + ')' );
    }
    if (response.err === 1)
      log("Can’t walk there...");
    if (response.err === 2)
      log("Immobilized!");
    //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
      return Sk.builtin.none.none$;
  };
}

/**
 * Function to be called on success of a call to players/pickup
 * args: response = the json response to the request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function pickupSuccess(response) {
  if (response.err === 0)
    log('Picked up item!');
  if (response.err === 1)
    log("That item isn't there!");
  if (response.err === 2)
    log("You can't access this tile!");
  //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
  return Sk.builtin.none.none$;
}

/**
 * Function to be called on success of a call to players/drop
 * args: response = the json response to the request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function dropSuccess(response) {
  if (response.err === 0)
    log("Dropped item");
  if (response.err === 1)
    log("You don't have that item!");
  if (response.err === 2)
    log("An item is already on this tile, drop your item elsewhere!");
  //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
  return Sk.builtin.none.none$;

}

/**
 * @suppress {missingProperties}
 */
function useSuccess(response) {
  // Update the health & battery indicators when use is called
  Sk.builtin.statusFunction();

  if (response.err === 0)
    log("Used item.")
  if (response.err === 1)
    log("You don't have that item!");
  if (response.err === 2)
    log("Erm... I don't think you can do that with that item.");
  //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
  return Sk.builtin.none.none$;

}

/**
 * Function to be called on success of a call to players/status
 * args: response = the json response to the request
 * returns: a python dict indicating the player's status, containing 3 keys: health, battery, and facing
 * @suppress {missingProperties}
 */
function statusSuccess(response) {
  var health = new Sk.builtin.nmber(response.health, Sk.builtin.nmber.int$);
  var battery = new Sk.builtin.nmber(response.battery, Sk.builtin.nmber.int$);
  //var facing = new Sk.builtin.str(reshellsponse.facing);
  //var logMsg = "Health: " + response.health.toString() + " Battery: " + response.battery.toString();
  //logMsg = logMsg + " Position: (" + response.x.toString() + ", " + response.y.toString() + ")";
  //log(logMsg);
  Bq.playerData.facing = direction[response.facing];
  Bq.playerData.health = response.health;
  Bq.playerData.battery = response.battery;
  //update the stats bar
  document.getElementById('health').innerHTML = "Health: " + response.health.toString();
  document.getElementById('battery').innerHTML = "Battery: " + response.battery.toString();
  Bq.playerData.x = response.x;
  Bq.playerData.y = response.y;
  return new Sk.builtin.tuple([health, battery]);
} 


/**
 * Function to be called on success of a call to players/inspect
 * args: response = the json response to the request
 * returns: python dict containing all the information about an item, or python None if the player 
 * does not have access to that item.  
 * @suppress {missingProperties}
 */
function inspectSuccess(response) {
  //todo: should log result of inspect instead.
    log("You see " + response.msg);
  //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
    return Sk.builtin.none.none$;

}


/**
 * Function to be called on success of a call to player/dig
 * args: response = the json response to the request
 * returns: a python number indicating success(0) or failure(1) 
 * @suppress {missingProperties}
 */
function digSuccess(response) {
  var id = response.id.toString();
  log("You dig around for a while and find a potato with id " + id + ". This could make a good battery.");
  //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
    return Sk.builtin.none.none$;

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
  var n = Bq.mapData.n;

  //make sure character is displayed
  Bq.playerData.display = true;

  var player_x = response.player_x;
  var player_y = response.player_y;
  // Coordinates of bottom left corner
  var sw_x = player_x - MAP_MAX_INDEX;
  var sw_y = player_y - MAP_MAX_INDEX;
  var tiles = response.tiles;

  var other_players = response.other_players;

  //var map  = [];
  //for (var i = 0; i < n; i++) {
  //  var row = [];
  //  for (var j = 0; j < n; j++) {
  //      row.push(-1);
  //  }
  //  map.push(row);
  //    }
  var x;
  var y;

  //If we are at the edge of the map, only existing tiles will be returned
  //In this case, we need to fill in the remaining locations with the off-the-map tile
  if (tiles.length < (2 * MAP_MAX_INDEX + 1) * (2 * MAP_MAX_INDEX + 1)) {
    for (var x = -MAP_MAX_INDEX; x <= MAP_MAX_INDEX; x++) {
      for (var y = -MAP_MAX_INDEX; y <= MAP_MAX_INDEX; y++) {
        Bq.mapData.setTile(x,y, -1);
      }
    }
  }

  //Go through tiles returned and save them to mapData
  for (var i = 0; i < tiles.length; i++) {
    x = tiles[i].x;
    y = tiles[i].y;
    if ( x-sw_x < 0 || x-sw_x > n || y-sw_y < 0 || y-sw_y > n) {
      alert('tile indices out of range');
    }

    if (other_players["x,y".replace("x", x).replace("y", y)]) {
      var dir = other_players["x,y".replace("x", x).replace("y", y)].facing;
      if (dir === 0) Bq.mapData.setTile(x-player_x, y-player_y, 51); 
      if (dir === 2) Bq.mapData.setTile(x-player_x, y-player_y, 52);
      if (dir === 1) Bq.mapData.setTile(x-player_x, y-player_y, 53);
      if (dir === 3) Bq.mapData.setTile(x-player_x, y-player_y, 54);
      
    } else {
      Bq.mapData.setTile(x-player_x, y-player_y, tiles[i].tile_type);
    }

  }
  Bq.map.render(Bq.Map.getIndices());
  //return new Sk.builtin.nmber(0, Sk.builtin.int$);
  return Sk.builtin.none.none$;

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

/**
 * Function to be called on success of a call to players/face
 * args: response = the json response to the face request
 * returns: python integer corresponding to the err code of the request. (this choice of return is 
 * for iteration 1 and may be changed to a more meaningful response later on)
 * @suppress {missingProperties}
 */
function faceSuccessFunction(dir) {
  return function(response) {
    //For now, reload map and player data every time we take a step
    Sk.builtin.statusFunction();
    Sk.builtin.tilesFunction();

    if (response.err === 0) {
      var x = Bq.playerData.x.toString();
      var y = Bq.playerData.y.toString();
      log('Now facing '+dir+'.')
    }
    if (response.err === 1)
      log("Can’t face that way...");
    //return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
    return Sk.builtin.none.none$;

  };
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
  var goSuccess = goSuccessFunction(direction);

  return json_request('POST', MOVE_PATH, goSuccess, goFailure, {'direction': direction});
}

/**
 * Implementation of the built-in python funtion 'pickup'
 *   args:  name = python string indicating name of item to pickup
 * @suppress {missingProperties}
 */
Sk.builtin.pickupFunction = function(name) {
  //Check argument count and types
  Sk.builtin.pyCheckArgs("pickupFunction", arguments, 1, 1);
  //Sk.builtin.pyCheckType("x", "integer", Sk.builtin.checkInt(x));
  //Sk.builtin.pyCheckType("y", "integer", Sk.builtin.checkInt(y));
  Sk.builtin.pyCheckType("name", "string", Sk.builtin.checkString(name));

  //Get Values from python representation
  //var x_val = Sk.builtin.asnum$(x);
  //var y_val = Sk.builtin.asnum$(y);
  var x_val = Bq.playerData.x;
  var y_val = Bq.playerData.y;
  // var item_id = itemId[name.v]; - Michel made this change
  var item_id = name.v;

  var pickupFailure = failureFunction(PICKUP_PATH)
  return json_request('POST', PICKUP_PATH, pickupSuccess, pickupFailure, {'x': x_val, 'y': y_val, 'item_id': item_id});
}

/**
 * Implementation of the built-in python funtion 'drop'
 *   args: name = python string indicating name of item to drop
 * @suppress {missingProperties}
 */
Sk.builtin.dropFunction = function(name) {
  //Check arg count and types
  Sk.builtin.pyCheckArgs("dropFunction", arguments, 1, 1);
  Sk.builtin.pyCheckType("name", "string", Sk.builtin.checkString(name));

  //get values from python representation
  if (name.v in itemId) {
    var item_id = itemId[name.v];
  } else {
    var item_id = name.v
  }

  var dropFailure = failureFunction(DROP_PATH);
  return json_request('POST', DROP_PATH, dropSuccess, dropFailure, {'item_id': item_id});
}

/**
 * Implementation of the built-in python funtion 'use'
 *   args: name = python string indicating name of item to use
 *         args = python string of arguments to the item's use function 
 * @suppress {missingProperties}
 */
Sk.builtin.useFunction = function(name, args) {
  //Check arg count and types
  Sk.builtin.pyCheckArgs("useFunction", arguments, 2, 2);
  Sk.builtin.pyCheckType("name", "string", Sk.builtin.checkString(name));
  Sk.builtin.pyCheckType("args", "string", Sk.builtin.checkString(args));

  //get values from python representation
  if (name.v in itemId) {
    var item_id = itemId[name.v];
  } else {
    var item_id = name.v
  }
  var use_args = args.v;

  var useFailure = failureFunction(USE_PATH);
  return json_request('POST', USE_PATH, useSuccess, useFailure, {'item_id': item_id, 'args': use_args});
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
 * Implementation of the built-in python funtion 'dig'
 * @suppress {missingProperties}
 */
Sk.builtin.digFunction = function() {
  //check args count and types
  Sk.builtin.pyCheckArgs("digFunction", arguments, 0, 0);

  var digFailure = failureFunction(DIG_PATH);
  return json_request("POST", DIG_PATH, digSuccess, digFailure, {});
}

/**
 * Implementation of the built-in python funtion 'inspect'
 *   args: name = python string containing name of item to inspect
 * @suppress {missingProperties}
 */
Sk.builtin.inspectFunction = function(args) {
  //check args count and types
  Sk.builtin.pyCheckArgs("inspectFunction", arguments, 0, 1);
    var argString = "";
  if (args !== undefined) { 
    Sk.builtin.pyCheckType("args", "string", Sk.builtin.checkString(args));
    argString = args.v
  }

  //get the value from the python representation 
  
  var inspectFailure = failureFunction(INSPECT_PATH);
  return json_request("POST", INSPECT_PATH, inspectSuccess, inspectFailure, {'args': argString});
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

/**
 *Wrapper for tiles that is more intuitively named
 */
Sk.builtin.lookFunction = function() {
    //For the tutorial, log some help if you're on the starting tile.
    if (Bq.playerData.x == 11 && Bq.playerData.y == 10) {
	log("You are the arrow in the middle of the map.  To look closer at what's in front of you, type inspect()");
    }
    Sk.builtin.pyCheckArgs("lookFunction", arguments, 0, 0);
    return Sk.builtin.tilesFunction()
}

/**
 * Implementation of the built-in python function 'face'
 * @suppress {missingProperties}
 */
Sk.builtin.faceFunction = function(dir) {
  // check args count and types
  Sk.builtin.pyCheckArgs("faceFunction", arguments, 1, 1);
  Sk.builtin.pyCheckType("dir", "string", Sk.builtin.checkString(dir));

  // get the string from the python representation (there may be a better way to do this)
  var direction = dir.v

  var faceFailure = failureFunction(FACE_PATH);
  var faceSuccess = faceSuccessFunction(direction);

  return json_request('POST', FACE_PATH, faceSuccess, faceFailure, {'direction': direction});
}

