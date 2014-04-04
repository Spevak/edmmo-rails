$(document).ready(function() {
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
    
    // Holds all the cells - mapData.n**2 of them - needed to buffer
    // half a map away on each side of the map.
    // stage: a Kinetic.Stage
    // cells: a square 2d array of cells w/ side length mapData.n ** 2
    var MapBuffer = function(stage, cells) {
	this.stage = stage;
	this.cells = cells;
    }
    
    // options: {
    //	direction: '[north|south|east|west]' (required)
    //	distance: [0..floor(mapWidth/2)]. default = 1
    // }
    // returns false if unsuccessful.
    // otherwise, returns an array of cells to populate the map.
    MapBuffer.prototype.scroll = function(options) {
	var distance, direction;
	if (!options['direction']) {
	    return false;
	} 
	distance = options['distance'] || 1;
	direction = options['direction'];
    }
    
    // Always returns a string which is unique for any pair (x, y)
    var hashCellPair = function(x, y) {
	x += offset;
	y += offset;
	return (x * mapData.n) + y;
    }
    
    // Set up the DOM
    var stage = new Kinetic.Stage({
	container: 'map-container', // refers to a DOM node's id
	width: mapData.n * cellWidth,
	height: mapData.n * cellHeight,
    });
    
    var bgLayer = new Kinetic.Layer();
    var fgLayer = new Kinetic.Layer();
    layers.unshift(bgLayer);
    layers.unshift(fgLayer);
    
    var bg = new Kinetic.Rect({
	width: cellWidth * mapData.n,
	height: cellHeight * mapData.n,
	x: 0,
	y: 0,
	fill: 'black'
    })
    
    bgLayer.add(bg);
    
    // Layers are set up; now let's make some cells.
    
    // Create a 2d array of cells.
    // A cell is a Group, containing a Rect (bg) at index 0 and a Text (fg) at i=1.
    // Later we can replace the Text object with a Sprite object if we want images.
    for (var i = 0; i < mapData.n; i++) {
	
	if (!cells[i]) // This is gross but why loop again?
	    cells[i] = [];
	
	for (var j = 0; j < mapData.n; j++) {
	    // Just trust me
	    var x = j,
	        y = i;
	    
	    var cell = new Kinetic.Group({
		x: (x * cellWidth),
		y: (y * cellHeight),
		width: cellWidth,
		height: cellHeight,
		id: hashCellPair(x-offset, y-offset)
	    });
	    
	    var cellBg = new Kinetic.Rect({
		width: cellWidth,
		height: cellHeight,
		fill: cellBgColor
	    });
	    
	    var cellContents = new Kinetic.Text({
		text: mapData.tileAt(x-offset, y-offset),
		fill: cellFgColor,
		width: textWidth,
		height: textHeight,
		align: "center",
                //strokeWidth: 5,
                //scaleX: .5,
		fontFamily:'Lucida Console,Monaco,Courier New,Consolas,Liberation Mono,Bitstream Vera Sans Mono, DejaVu Sans Mono, monospace',
		x: 0,
		y: 0
	    });
	    //cellContents.skewX(2);
	    
	    cell.add(cellBg);
	    cell.add(cellContents);
	    
	    cells[i].push(cell);
	}
    }
    
    // Abstraction for dealing with map cells, which are composed of
    // several Kinetic objects.
    // outer = a Kinetic.Node object
    // inner = a Kinetic.Node object
    // layer = a Kinetic.Layer object
    var Cell = function(outer, inner, layer) {
	this.outer = outer;
	this.inner = inner;
	this.layer = layer;
    }
    
    // Flash yellow and black. For debuggin
    Cell.prototype.alert = function() {
	this.outer.setAttr('fill', cellHighlightBgColor)
	this.inner.setAttr('fill', cellHighlightFgColor)
	this.layer.draw();
	
	// Fucking js
	var that = this;
	window.setTimeout(function() {
	    that.outer.setAttr('fill', cellBgColor)
	    that.inner.setAttr('fill', cellFgColor)
	    that.layer.draw();
	}, 1500);
    }
    
    // Update the cell.
    // options = {
    //	 outer: (attributes hash for Kinetic.Rect)
    //	 inner: (attributes hash for Kinetic.Text)
    //	 text: (string)
    // }
    Cell.prototype.update = function(options) {
	if (options['outer'])
	    this.outer.setAttrs(options['outer']);
	if (options['inner'])
	    this.inner.setAttrs(options['inner']);
	if (options['text'])
	    this.inner.setText(options['text']);
	//inneficient to redraw everytime we update a cell if we will often update them all at the same time 
	//this.layer.draw();
    };
    
    Cell.prototype.flash = function(text) {
	var oldText = this.inner.getText();
	this.update({ 'text': text });
	var that = this;
	window.setTimeout(function() {
	    that.update({ 'text': oldText });
	}, 1500);
    }
    
    var getCellById = function (id) {
	var cell = stage.find("#" + id)[0];
	var cellOuter = cell.getChildren()[0];
	var cellInner = cell.getChildren()[1];
	return new Cell(cellOuter, cellInner, fgLayer);
    }

  // Abstraction for dealing with map cells, which are composed of
  // several Kinetic objects.
  // outer = a Kinetic.Node object
  // inner = a Kinetic.Node object
  // layer = a Kinetic.Layer object
  var Cell = function(outer, inner, layer) {
    this.outer = outer;
    this.inner = inner;
    this.layer = layer;
  }

  // Flash yellow and black. For debuggin
  Cell.prototype.alert = function() {
    this.outer.setAttr('fill', cellHighlightBgColor)
    this.inner.setAttr('fill', cellHighlightFgColor)
    this.layer.draw();

    // Fucking js
    var that = this;
    window.setTimeout(function() {
      that.outer.setAttr('fill', cellBgColor)
      that.inner.setAttr('fill', cellFgColor)
      that.layer.draw();
    }, 1500);
  }

  // Update the cell.
  // options = {
  //   outer: (attributes hash for Kinetic.Rect)
  //   inner: (attributes hash for Kinetic.Text)
  //   text: (string)
  // }
  Cell.prototype.update = function(options) {
    if (options['outer'])
      this.outer.setAttrs(options['outer']);
    if (options['inner'])
      this.inner.setAttrs(options['inner']);
    if (options['text'])
      this.inner.setText(options['text']);
    //inneficient to redraw everytime we update a cell if we will often update them all at the same time 
    //this.layer.draw();
  };

  Cell.prototype.flash = function(text) {
    var oldText = this.inner.getText();
    this.update({ 'text': text });
    var that = this;
    window.setTimeout(function() {
      that.update({ 'text': oldText });
    }, 1500);
  }

  var getCellById = function (id) {
    var cell = stage.find("#" + id)[0];
    var cellOuter = cell.getChildren()[0];
    var cellInner = cell.getChildren()[1];
    return new Cell(cellOuter, cellInner, fgLayer);
  }

  for (var i = 0; i < cells.length; i++) {
    for (var j = 0; j < cells[i].length; j++) {
      fgLayer.add(cells[i][j]);
    }
  }

  stage.add(bgLayer);
  stage.add(fgLayer);

  // im pretty sure our app isnt called "window"
  // so i should change this pretty soon -grayson
  /**
   * Updates the display at the locations given in updateList
   */
  window.renderMap = function(toUpdate) {
    var loc;
    while (loc = toUpdate.pop()) {
      var cell = getCellById(hashCellPair(loc[0] - 1, (mapData.n - loc[1])));
      //Initialize newcellcontents to F so the cell will display as F if the correct char fails to load
      //For some reason
      var newContents = tileChars[70]
      //use tileChars to get the character representation from the tile ID
      //if loc = (0, 0) display the player's character
	if (loc[0] === 0 && loc[1] === 0) {
	    var dir = playerData.facing;
	    if (dir === 'north') newContents = tileChars[11];
	    if (dir === 'south') newContents = tileChars[12];
	    if (dir === 'east') newContents = tileChars[13];
	    if (dir === 'west') newContents = tileChars[14];
	}
	else {
	    tileId = mapData.tileAt(loc[0], loc[1]);
	    if (tileId === -1) {
		//Tile id of non-existant location (off the map)
		tileId = 15;
	    }
	    newContents = tileChars[tileId];
	}
      cell.update({"text": newContents});
    }
    //draw after updating all the tiles for efficiency when drawing updating entire map at once.
    fgLayer.draw();
  }

  //print tiles to screen from 2d array of tile IDs
  window.displayTileArray= function(arr) {
    //indices = []
    for (i = 0; i < mapData.n; i++) {
      var row = arr[i];
      //Start at top of splashart array, so y starts at max value
      var y = MAP_MAX_INDEX - i;
      for (j=0; j<mapData.n; j++) {
        //x starts from right so min value first
        x = j - MAP_MAX_INDEX;
        //indices.push([x, y]);
        mapData.setTile(x,y,row[j]);
      }
    }
      renderMap(window.getMapIndices());
  }

    //a list of all valid indeces on map
    window.getMapIndices = function() {
	var mapIndices = [];
	for (var x = -MAP_MAX_INDEX; x <= MAP_MAX_INDEX; x++) {
	    for (var y = -MAP_MAX_INDEX; y <= MAP_MAX_INDEX; y++) {
		mapIndices.push([x,y]);
	    }
	}
	return mapIndices;
    }


  //Set up the splash page content
  displayTileArray(splashArt);
  log("<font size=4> Welcome to Bot Quest! <br> </font>" +
      "<font size=3> &nbsp &nbsp Try typing a command below </font>");

});
