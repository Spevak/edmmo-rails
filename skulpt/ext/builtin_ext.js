
/* Let's reuse the POST handler from warmup because we're fantastic like that */

function goSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$); //Assumes is 0
}

function goFailure(response) {
    if (response.err === 1)
        return Sk.builtin.str("Can’t walk there...");
    if (response.err === 2)
        return Sk.builtin.str("Immobilized!");
}

function pickupSuccess(response) {
    return response;
}

function pickupFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("That item isn't there!");
    if (response.err === 2)
        return new Sk.builtin.str("You can't access this tile!");
}

function dropSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

function dropFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("You don't have that item!");
}

function useSuccess(response) {
    return new Sk.builtin.nmber(response.err, Sk.builtin.nmber.int$);
}

function useFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("You don't have that item!");
    if (response.err === 2)
        return new Sk.builtin.str("Erm... I don't think you can do that with that item.");
}

function statusSuccess(response) {
    return new Sk.builtin.tuple(response.hp, response.battery, response.facing);
}

function statusFailure(response) {
    return new Sk.builtin.str("Something terrible has happened to cause this.");
}

function inspectSuccess(response) {
    return new Sk.builtin.str(response.item);
}

function inspectFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("I don't have that item");
}

function tilesSuccess(response) {
    var newStr = "";
    newStr += "Here are the items we found in the specified range:" + '\n';
    newStr += " NOT YET IMPLEMENTED"
    //for item in response.tiles:
    //    newStr + item.itemID + '\n';
    return new Sk.builtin.str(newStr);
}

function tilesFailure(response) {
    if (response.err === 1)
        return new Sk.builtin.str("Something terrible has happened to cause this.");
}

/* ########################################################################## */

function json_post_request(page, successFunction, failureFunction, dict) {
    alert('got to ajax call');
    /*

    $.ajax({
        type: 'POST',
        url: page,
        data: JSON.stringify(dict),
        contentType: "application/json",
        dataType: "json",
        success: successFunction,
        error: failureFunction
    });
    */
}

Sk.builtin.goFunction = function(dir) {
    json_post_request("player/move", goSuccess, goFailure, {'direction': dir});
}

Sk.builtin.pickupFunction = function(x, y, ID) {
    json_post_request("player/pickup", pickupSuccess, pickupFailure, {'x': x, 'y': y, 'itemID': ID});
}

Sk.builtin.dropFunction = function(ID) {
    json_post_request("player/drop", dropSuccess, dropFailure, {'itemID': ID});
}

Sk.builtin.useFunction = function(ID, args) {
    json_post_request("player/use", useSuccess, useFailure, {
                      'itemID': ID,
                      'args': args // Assumes args is already in an array
                      });
}

/* ########################################################################### */

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


Sk.builtin.statusFunction = function() {
    json_get_request("player/get", statusSuccess, statusFailure, {});
}

Sk.builtin.inspectFunction = function(ID) {
    json_get_request("player/pickup", inspectSuccess, inspectFailure, {'itemID': ID});
}

Sk.builtin.tilesFunction = function(n) {
    json_get_request("world/tiles", inspectSuccess, inspectFailure, {'n': n});
}