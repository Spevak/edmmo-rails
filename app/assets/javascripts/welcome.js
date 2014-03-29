$(document).ready(function() {
	var cellWidth = 12,
			cellHeight = cellWidth,
			textWidth = 12,
			textHeight = textWidth,
			cellBgColor = 'white',
			cellFgColor = 'red',
			cellHighlightBgColor = 'yellow',
			cellHighlightFgColor = 'black',
			layers = [],
			cells = [],
			offset = Math.floor(mapData.n / 2); //add to coordinates s.t. player is at 0, 0


	// Always returns a string which is unique for any pair (x, y)
	var hashCellPair = function(x, y) {
		x -= offset;
		y -= offset;
		return (x * mapData.n) + y;
	}

	// Abstraction for dealing with map cells, which are composed of
	// several Kinetic objects.
	var getCellById = function (id) {
		var cell = stage.find("#" + id)[0];
		var cellOuter = cell.getChildren()[0];
		var cellInner = cell.getChildren()[1];
		return {
			'outer': cellOuter,
			'inner': cellInner,
			'alert': function() {
				this.outer.setAttr('fill', cellHighlightBgColor)
				this.inner.setAttr('fill', cellHighlightFgColor)
			}}
	}

	// Set up the DOM
	var stage = new Kinetic.Stage({
		container: 'map-container', // refers to a DOM node's id
		width: mapData.n * cellWidth,
		height: mapData.n * cellWidth,
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
				text: hashCellPair(x, y),
				fill: cellFgColor,
				width: textWidth,
				height: textHeight,
				x: 0,
				y: 0
			});

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

	stage.add(bgLayer);
	stage.add(fgLayer);

	// im pretty sure our app isnt called "window"
	// so i should change this pretty soon -grayson
	window.updateBotQuest = function(x, y) {
			var cell = getCellById(hashCellPair(x, y));
			var newCellContents = mapData.tileAt(x, y);
			cell.inner.setText(newCellContents);
			cell.alert();
			fgLayer.draw(); // must call to update the <canvas>.
	}
});
