
/* Let's reuse the POST handler from warmup because we're fantastic like that */

/**
 * @suppress {missingProperties}
 */
function goSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$); //Assumes is 0
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
function json_post_request(page, successFunction, failureFunction, dict) {
    alert('got to ajax call');


    /*$.ajax({
        type: 'POST',
        url: page,
        data: JSON.stringify(dict),
        contentType: "application/json",
        dataType: "json",
        success: successFunction,
        error: failureFunction
    });*/
    
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.goFunction = function(dir) {
    json_post_request("player/move", goSuccess, goFailure, {'direction': dir});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.pickupFunction = function(x, y, ID) {
    json_post_request("player/pickup", pickupSuccess, pickupFailure, {'x': x, 'y': y, 'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.dropFunction = function(ID) {
    json_post_request("player/drop", dropSuccess, dropFailure, {'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.useFunction = function(ID, args) {
    json_post_request("player/use", useSuccess, useFailure, {
                      'itemID': ID,
                      'args': args // Assumes args is already in an array
                      });
}

/* ########################################################################### */

/**
 * @suppress {missingProperties}
 */
function json_get_request(page, successFunction, failureFunction, dict) {
    alert('got to json get request');
    /* 
    $.ajax({
           type: 'GET',
           url: page,
           data: JSON.stringify(dict),
           contentType: "application/json",
           dataType: "json",
           success: successFunction,
           error: failureFunction
           });
  */
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.statusFunction = function() {
    json_get_request("player/get", statusSuccess, statusFailure, {});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.inspectFunction = function(ID) {
    json_get_request("player/pickup", inspectSuccess, inspectFailure, {'itemID': ID});
}

/**
 * @suppress {missingProperties}
 */
Sk.builtin.tilesFunction = function(n) {
    json_get_request("world/tiles", inspectSuccess, inspectFailure, {'n': n});
}
