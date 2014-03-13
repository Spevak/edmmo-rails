//Generate failure functions
function failureFunction(path) {
    var str = "Error on call to " + path +  ". Response: ";
    return function(status) {
	return new Sk.builtin.str(str + status);
    };
}

/**
 * @suppress {missingProperties}
 */

function goFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("Can’t walk there..."); // Unsure if want string, or to return the response.err
    if (response.err === 2)
        return new Sk.builtin.str("Immobilized!");

/**
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
 * @suppress {missingProperties}
 */
function statusSuccess(response) {
    return new Sk.builtin.tuple((response.hp, response.battery, response.facing));
} // May be better served by dict, but could not locate in builtin.js

/**
 * @suppress {missingProperties}
 */
function statusFailure(response) {
    return new Sk.builtin.str("Something terrible has happened to cause this.");
}

/**
 * @suppress {missingProperties}
 */
function inspectSuccess(response) {

    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);

}

/**
 * @suppress {missingProperties}
 */

function inspectFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("I don't have the item: " + String(response.item.name)); //Assumes there is a name field for the JSON that is in the response for 'item'.
}

/**
 * @suppress {missingProperties}
 */

function tilesSuccess(response) {
    //Want to return an array of builtin arrays
    var n = (response.tiles.length).sqrt();
    var arrOfArrs = new Array();
    for (var i=0;i<response.tiles.length;i+=n) {
        var localArr = new Array();
        for (var j=0;i<n;j++) {
            localArr[j] = response.tiles.name[i + j];
        }
        var insertArr = new Sk.builtin.list(localArr);
        arrOfArrs[(i / n)] = insertArr;
    }
    //var newStr = "";
    //newStr += "Here are the items we found in the specified range:" + '\n';
    //newStr += " NOT YET IMPLEMENTED"
    //for item in response.tiles:
    //    newStr + item.itemID + '\n';
    return new Sk.builtin.list(arrOfArrs);
}

/**
 * @suppress {missingProperties}
 */
function charactersSuccess(response) {
    return new Sk.builtin.str("charactersSuccess response handling not yet implemented");
  

}
/* ########################################################################## */

/**
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
    http.send(JSON.stringify(dict));

    if (http.status === 200) {
	return successFunction(JSON.parse(http.responseText));
    }
    return failureFunction(JSON.parse(http.responseText));		
    
}

/**
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

/* ########################################################################### */

/**
 * @suppress {missingProperties}
 */
Sk.builtin.statusFunction = function() {
    //check args count and types
    Sk.builtin.pyCheckArgs("statusFunction", arguments, 0, 0);

    var statusFailure = failureFunction(STATUS_PATH);
    return json_request("GET", STATUS_PATH, statusSuccess, statusFailure, {});
}

/**
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
 * @suppress {missingProperties}
 */
Sk.builtin.charactersFunction = function() {
    //check args count and types
    Sk.builtin.pyCheckArgs("charactersFunction", arguments, 0, 0);

    var charactersFailure = failureFunction(CHARACTERS_PATH);
    return json_request("GET", CHARACTERS_PATH, charactersSuccess, charactersFailure, {});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.tilesFunction = function(n) {
    //check args count and types
    Sk.builtin.pyCheckArgs("tilesFunction", arguments, 1, 1);
    Sk.builtin.pyCheckType("n", "integer", Sk.builtin.checkInt(n));

    //get the values from the python representations
    var n_val = Sk.builtin.asnum$(n);


    var inspectFailure = failureFunction(TILES_PATH);
    return json_request("GET", TILES_PATH, inspectSuccess, inspectFailure, {'n': n_val});
}

