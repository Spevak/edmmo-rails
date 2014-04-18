var cellWidth = 14,
    cellHeight = cellWidth,
    textWidth = 14,
    textHeight = textWidth,
    cellBgColor = "#001600",//'black',
    cellFgColor =  "#00b500", // 'green',
    cellHighlightBgColor = 'yellow',
    cellHighlightFgColor = 'black',
    layers = [],
    cells = [],
    offset = MAP_MAX_INDEX; //add to coordinates s.t. player is at 0, 0

Bq.Map = function(stage, fgLayer, bgLayer) {
  this.stage = stage;

  this.stage.add(bgLayer);
  this.stage.add(fgLayer);

  this.fgLayer = fgLayer;
  this.bgLayer = bgLayer;
};

Bq.Map.prototype.render = function(toUpdate) {
  var loc;
  while (loc = toUpdate.pop()) {
    var cell = Bq.Cell.getCellById(Bq.Cell.hashCellPair(loc[0] - 1, (Bq.mapData.n - loc[1])));
    //Initialize newcellcontents to F so the cell will display as F if the correct char fails to load
    var newContents = tileChars[70]
    //use tileChars to get the character representation from the tile ID
    //if loc = (0, 0) display the player's character
    if (Bq.playerData.display && loc[0] === 0 && loc[1] === 0) {
      var dir = Bq.playerData.facing;
      if (dir === 'north') newContents = tileChars[51];
      if (dir === 'south') newContents = tileChars[52];
      if (dir === 'east') newContents = tileChars[53];
      if (dir === 'west') newContents = tileChars[54];
    }
    else {
      tileId = Bq.mapData.tileAt(loc[0], loc[1]);
      if (tileId === -1) {
        //Tile id of non-existant location (off the map)
        tileId = 50;
      }
      newContents = tileChars[tileId];
    }
    cell.update({"text": newContents});
  }
  //draw after updating all the tiles for efficiency when drawing updating entire map at once.
  this.fgLayer.draw();
}

//a list of all valid indecencies on map
Bq.Map.getIndices = function() {
  var mapIndices = [];
  for (var x = -MAP_MAX_INDEX; x <= MAP_MAX_INDEX; x++) {
    for (var y = -MAP_MAX_INDEX; y <= MAP_MAX_INDEX; y++) {
      mapIndices.push([x,y]);
    }
  }
  return mapIndices;
}

Bq.Map.prototype.getIndices = Bq.Map.getIndices;

//print tiles to screen from 2d array of tile IDs
Bq.Map.prototype.displayTileArray= function(arr) {
  //indices = []
  for (i = 0; i < Bq.mapData.n; i++) {
    var row = arr[i];
    //Start at top of splashart array, so y starts at max value
    var y = MAP_MAX_INDEX - i;
    for (j=0; j < Bq.mapData.n; j++) {
      //x starts from right so min value first
      x = j - MAP_MAX_INDEX;
      //indices.push([x, y]);
      Bq.mapData.setTile(x,y,row[j]);
    }
  }
  this.render(Bq.Map.getIndices());
}
