/** 
 * A mapdata object stores an n*n array of tiles (represented as characters)
 * @constructor
 */
function MapData() {
    //todo: instantiate with ascii art instead of zeros
    this.data = new Array();
    this.n = 2 * MAP_MAX_INDEX + 1;
    var col = null;
    for (var x = 0; x < this.n; x++) {
	col = new Array();
	for (var y=0; y < this.n; y++) {
	    col.push(-1);
	}
	this.data.push(col);
    }
}
MapData.prototype.data = new Array();
MapData.prototype.n = 0;

/**
 *This is used to access tiles in the coordinate system where the player's
 *character is at (0,0).  Returns the tile id at that location or -1 if the 
 *location is out of range.
 */
MapData.prototype.tileAt = function(x, y) {
    if (Math.abs(x) > MAP_MAX_INDEX || Math.abs(y) > MAP_MAX_INDEX) {
	return -1;
    }
    var x_index = x + MAP_MAX_INDEX;
    var y_index = y + MAP_MAX_INDEX;
    return this.data[x_index][y_index];    
}

/**
 *Just like tileAt, but for setting.
 *suppress missingProperties because updateBotQuest is not defined until page loads
 *@suppress {missingProperties}
 */
MapData.prototype.setTile = function(x, y, tileId) {
    if (Math.abs(x) > MAP_MAX_INDEX || Math.abs(y) > MAP_MAX_INDEX) {
	return -1;
    }
    var x_index = x + MAP_MAX_INDEX;
    var y_index = y + MAP_MAX_INDEX;
    this.data[x_index][y_index] = tileId;
    //window.updateBotQuest(x, y);
}


/**
 * Prints a message to the output log
 */
function log(msg) {
    var logPre = document.getElementById('log');
    logPre.innerHTML = msg;
}

var mapData = new MapData();

//Initialize player stats
var playerData = {'health': 0, 'battery': 0, 'facing':0, 'display': false} 

// This creates a global object named Bq which exposes some public
// members while keeping the ability to declare variables privately.
//
// You can modify the public members of this object anywhere.
// However, methods which refer to private members should be defined
// in this function.
//
// Example usage:
//
// Functions that don't refer to public members
// ===========================================
//
// foo.js (anywhere after this has executed):
// ------------------------------------------
// Bq.newFunction = function(args) { return 1; }
//
// bar.js (anywhere else, or the same file):
// ----------------------------------------
// Bq.newFunction()
//    => 1
//
// Functions referring to private members
// ======================================
//
// in util.js (here only):
// -----------------------
// var privateVariable = "secret";
// return {
//   trickyFunction: function() { return privateVariable; }
// }
//
// foobar.js (anywhere):
// ---------------------
// Bq.trickyFunction()
//    => "secret";

var Bq = (function() {

  // Why do we care about having private members?
  // This is recommended by basically everyone but I have no rationale.
  // Seems silly to try to prevent access to variables in the
  // user's memory space. Maybe that's just CS161 suspicion? -G
  // var privateVarsGoHere = "";

  return { // Public variables
    models: {},
    views: {},
    controllers: {},
		constants: {}, // all of these are exposed to client, hence not in constants.js
		mapData: mapData,
		playerData: playerData,
		log: log
  }
})(); 

goog.exportSymbol("Bq", Bq);
