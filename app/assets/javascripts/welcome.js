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

      ( function(cells) { 
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

      var imageObject = new Image();
      imageObject.onload = function() {
        var cellFg = new Kinetic.Sprite({
          width: cellWidth,
          height: cellHeight,
          x: 0,
          y: 0,
          image: imageObject
        });
        //console.log("cellfg: " + cellFg);
        cell.add(cellFg);
        //console.log("cell: " + cell.children);
      }
      imageObject.src = '/assets/tiles/tile_placeholder.png';
      cell.add(cellBg);
      fgLayer.add(cell);
      } )(cells);
      fgLayer.draw();
    }
  }
  fgLayer.draw();
  Bq.map = new Bq.Map(stage, fgLayer, bgLayer);

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
