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
    //alert('Call to tileAt: x=' + x + ', y=' + y);
    if (Math.abs(x) > MAP_MAX_INDEX || Math.abs(y) > MAP_MAX_INDEX) {
	return -1;
    }
    var x_index = x + MAP_MAX_INDEX;
    var y_index = y + MAP_MAX_INDEX;
    //alert('got to end of tileAt');
    return this.data[x_index][y_index]
    
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
    //alert("x_index=" + x_index+ " y_index=" + y_index);
    this.data[x_index][y_index] = tileId;
    window.updateBotQuest(x, y);
    //alert("got to end of setTile");
}

var mapData = new MapData();
goog.exportSymbol("mapData", mapData);

/**
 * Prints a message to the output log
 */
function log(msg) {
    var logPre = document.getElementById('log');
    logPre.innerHTML += msg;
}
goog.exportSymbol("log", log);