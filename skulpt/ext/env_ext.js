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
	    col.push(0);
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
    return this.data[x_index][y_index]
    
}


var mapData = new MapData();
goog.exportSymbol("mapData", mapData);