$(document).ready(function() {

	var stage = new Kinetic.Stage({
		container: 'map-container', // refers to a DOM node's id
		width: Bq.mapData.n * cellWidth,
		height: Bq.mapData.n * cellHeight,
	});

	// Background layer
	var bgLayer = new Kinetic.Layer();

	var bg = new Kinetic.Rect({
		width: cellWidth * Bq.mapData.n,
		height: cellHeight * Bq.mapData.n,
		x: 0,
		y: 0,
		fill: 'black'
	})
	bgLayer.add(bg);

	// Foreground layer (to be populated below)
	var fgLayer = new Kinetic.Layer();

	// Layers are set up; now let's make some cells.

	// Create a 2d array of cells.
	// A cell is a Group, containing a Rect (bg) and a Text (fg). 
	// Later we can replace the Text object with a Sprite object if we want images.
	for (var i = 0; i < Bq.mapData.n; i++) {

		if (!cells[i]) // This is gross but why loop again?
			cells[i] = [];

		for (var j = 0; j < Bq.mapData.n; j++) {
			// Just trust me
			var x = j,
			y = i;

			var cell = new Kinetic.Group({
				x: (x * cellWidth),
				y: (y * cellHeight),
				width: cellWidth,
				height: cellHeight,
				id: Bq.Cell.hashCellPair(x-offset, y-offset)
			});

			var cellBg = new Kinetic.Rect({
				width: cellWidth,
				height: cellHeight,
				fill: cellBgColor
			});

			var cellContents = new Kinetic.Text({
				text: Bq.mapData.tileAt(x-offset, y-offset),
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

	for (var i = 0; i < cells.length; i++) {
		for (var j = 0; j < cells[i].length; j++) {
			fgLayer.add(cells[i][j]);
		}
	}

	Bq.map = new Bq.Map(stage, fgLayer, bgLayer);

	// im pretty sure our app isnt called "window"
	// so i should change this pretty soon -grayson
	/**
	 * Updates the display at the locations given in updateList
	 */
	Bq.renderMap = function(toUpdate) {
		var loc;
		console.log(loc);
		while (loc = toUpdate.pop()) {
			var cell = Bq.Cell.getCellById(Bq.Cell.hashCellPair(loc[0] - 1, (Bq.mapData.n - loc[1])));
			//Initialize newcellcontents to F so the cell will display as F if the correct char fails to load
			//For some reason
			var newContents = tileChars[70]
			//use tileChars to get the character representation from the tile ID
			//if loc = (0, 0) display the player's character
			if (Bq.playerData.display && loc[0] === 0 && loc[1] === 0) {
				var dir = Bq.playerData.facing;
				if (dir === 'north') newContents = tileChars[11];
				if (dir === 'south') newContents = tileChars[12];
				if (dir === 'east') newContents = tileChars[13];
				if (dir === 'west') newContents = tileChars[14];
			}
			else {
				tileId = Bq.mapData.tileAt(loc[0], loc[1]);
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

	//////////////////////////////////////////
	//Get the page set up

	//Set up the splash page content
	Bq.map.displayTileArray(splashArt);

	//Load character's data (hp, battery, facing, x, y)
	Sk.builtin.statusFunction();

	Bq.log("<font size=4> Welcome to Bot Quest! <br> </font>" +
			"<font size=3> &nbsp &nbsp Try typing a command below </font>");

    //playerData["display"]=true;
});
