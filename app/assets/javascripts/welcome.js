$(document).ready(function() {
	var cellWidth = 24,
			cellHeight = cellWidth,
			textWidth = 24,
			textHeight = textWidth,
			layers = [],
			cells = [],
			offset = Math.floor(mapData.n / 2);


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
		return { 'outer': cellOuter, 'inner': cellInner }
	}

	var stage = new Kinetic.Stage({
		container: 'map-container',
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
		fill: 'blue'
	})

	bgLayer.add(bg);

	// Create a 2d array of cells.
	// A cell is a Group, containing a Rect (bg) at index 0 and a Text (fg) at i=1.
	// Later we can replace the Text object with a Sprite object if we want images.

	// This is for transforming the map coordinate space
	// By default, (0, 0) would be at the top-left corner
	// So instead we'll set it to be the center tile,
	// and tiles to the left will have negative x values (above, negative y)
	for (var i = 0; i < mapData.n; i++) {
		for (var j = 0; j < mapData.n; j++) {
			// Just trust me
			var x = j,
					y = i;

			var cell = new Kinetic.Group({
				x: (j * cellWidth),
				y: (i * cellHeight),
				width: cellWidth,
				height: cellHeight,
				id: hashCellPair(x-offset, y-offset)
			});

			var cellBg = new Kinetic.Rect({
				width: cellWidth,
				height: cellHeight,
				fill: 'red'
			});

			var cellContents = new Kinetic.Text({
				text: hashCellPair(x, y),
				fill: 'green',
				width: textWidth,
				height: textHeight,
				x: 0,
				y: 0
			});

			cell.add(cellBg);
			cell.add(cellContents);

			if (!cells[i]) { cells[i] = []; }
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

	// polluting the global namespace is like polluting the globe itself.
	window.updateBotQuest = function(x, y) {
			var cell = getCellById(hashCellPair(x, y));
			var newCellContents = mapData.tileAt(x, y);
			cell.inner.setText(newCellContents);
			cell.inner.setAttr('fill', 'white');
			cell.outer.setAttr('fill', 'black');
			fgLayer.draw();
	}
});
