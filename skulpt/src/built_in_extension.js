/*Let's reuse the POST handler from warmup because we're fantastic like that*/

function goSuccess(response) {
    return Sk.builtin.int(response.err); //Assumes is 0
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
        return Sk.builtin.str("That item isn't there!");
    if (response.err === 2)
        return Sk.builtin.str("You can't access this tile!");
}

function dropSuccess(response) {
    return Sk.builtin.int(response.err);
}

function dropFailure(response) {
    if (response.err === 1)
        return Sk.builtin.str("You don't have that item!");
}

function useSuccess(response) {
    return Sk.builtin.int(response.err);
}

function useFailure(response) {
    if (response.err === 1)
        return Sk.builtin.str("You don't have that item!");
    if )response.err === 2)
        return Sk.builtin.str("Erm... I don't think you can do that with that item.");
}

function statusSuccess(response) {
    return Sk.builtin.tuple(response.hp, response.battery, response.facing);
}

function statusFailure(response) {
    return Sk.builtin.str("Something terrible has happened to cause this.");
}

function inspectSuccess(response) {
    return Sk.builtin.str(response.item);
}

function inspectFailure(response) {
    if (response.err === 1)
        return Sk.builtin.str("I don't have that item");
}

/*###########################################################################*/

function json_post_request(page, successFunction, failureFunction, dict) {
    $.ajax({
        type: 'POST',
        url: page,
        data: JSON.stringify(dict),
        contentType: "application/json",
        dataType: "json",
        success: successFunction,
        error: failureFunction
    });
}

Sk.builtin.goFunction = function(dir) {
    json_post_request("player/move", goSuccess, goFailure);
}

Sk.builtin.pickupFunction = function(x, y, ID) {
    json_post_request("player/pickup", pickupSuccess, pickupFailure);
}

Sk.builtin.dropFunction = function(ID) {
    json_post_request("player/drop", dropSuccess, dropFailure);
}

Sk.builtin.useFunction = function(ID, args) {
    json_post_request("player/use", useSuccess, useFailure);
}

/*###########################################################################*/

function json_get_request(page, successFunction, failureFunction, dict) {
    $.ajax({
           type: 'GET',
           url: page,
           data: JSON.stringify(dict),
           contentType: "application/json",
           dataType: "json",
           success: successFunction,
           error: failureFunction
           });
}

Sk.builtin.statusFunction = function() {
    json_get_request("player/get", statusSuccess, statusFailure);
}

Sk.builtin.inspectFunction = function(ID) {
    json_get_request("player/pickup", inspectSuccess, inspectFailure);
}
