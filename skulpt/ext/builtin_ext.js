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
function goSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$); 
}


/**
 * @suppress {missingProperties}
 */
function goFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("Can’t walk there...");
    if (response.err === 2)
        return new Sk.builtin.str("Immobilized!");
}

/**
 * @suppress {missingProperties}
 */
function pickupSuccess(response) {
    return new Sk.builtin.nmber(response, Sk.builtin.nmber.int$);
}

/**
 * @suppress {missingProperties}
 */
function pickupFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("That item isn't there!");
    if (response.err === 2)
        return new Sk.builtin.str("You can't access this tile!");
}

/**
 * @suppress {missingProperties}
 */
function dropSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

/**
 * @suppress {missingProperties}
 */
function dropFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("You don't have that item!");
}

/**
 * @suppress {missingProperties}
 */
function useSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

/**
 * @suppress {missingProperties}
 */
function useFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("You don't have that item!");
    if (response.err === 2)
        return new Sk.builtin.str("Erm... I don't think you can do that with that item.");
}

/**
 * @suppress {missingProperties}
 */
function statusSuccess(response) {
    return new Sk.builtin.tuple((response.hp, response.battery, response.facing));
}

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
    return new Sk.builtin.str(response.item);
}

/**
 * @suppress {missingProperties}
 */
function inspectFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("I don't have that item");
}

/**
 * @suppress {missingProperties}
 */
function tilesSuccess(response) {
    var newStr = "";
    newStr += "Here are the items we found in the specified range:" + '\n';
    newStr += " NOT YET IMPLEMENTED"
    //for item in response.tiles:
    //    newStr + item.itemID + '\n';
    return new Sk.builtin.str(newStr);
}

/**
 * @suppress {missingProperties}
 */
function tilesFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("Something terrible has happened to cause this.");
}

/* ########################################################################## */

/**
 * @suppress {missingProperties}
 */
function json_request(type, page, successFunction, failureFunction, dict) {

    /* $.ajax({
        type: 'POST',
        url: page,
        data: JSON.stringify(dict),
        contentType: "application/json",
        dataType: "json",
        success: successFunction,
        error: failureFunction
    }); */

    //Jquery-free implimentation of above ajax request

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
    var goFailure = failureFunction(MOVE_PATH);
    // get the string from the python representation (there may be a better way to do this)
    var direction = dir.v
    return json_request('POST', MOVE_PATH, goSuccess, goFailure, {'direction': direction});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.pickupFunction = function(x, y, ID) {
    json_request('POST', "player/pickup", pickupSuccess, pickupFailure, {'x': x, 'y': y, 'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.dropFunction = function(ID) {
    json_request('POST', "player/drop", dropSuccess, dropFailure, {'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.useFunction = function(ID, args) {
    json_request('POST', "player/use", useSuccess, useFailure, {
                      'itemID': ID,
                      'args': args // Assumes args is already in an array
                      });
}

/* ########################################################################### */

/**
 * @suppress {missingProperties}
 */
Sk.builtin.statusFunction = function() {
    json_request("GET", "player/status", statusSuccess, statusFailure, {});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.inspectFunction = function(ID) {
    json_request("GET", "player/pickup", inspectSuccess, inspectFailure, {'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.tilesFunction = function(n) {
    json_request("GET", "world/tiles", inspectSuccess, inspectFailure, {'n': n});
}

