$(document).ready(function() {
  var cellWidth = 14,
  cellHeight = cellWidth,
  cellBgColor = "#001600",//'black',
  cellFgColor =  "#00b500", // 'green',
  cellHighlightBgColor = 'yellow',
  cellHighlightFgColor = 'black',
  layers = [],
  cells = [],
  offset = MAP_MAX_INDEX; //add to coordinates s.t. player is at 0, 0

  // Abstraction for dealing with map cells, which are composed of
  // several Kinetic objects.
  // outer: a Kinetic.Rect object (or any Kinetic.Node subclass)
  // inner: a Kinetic.Text object (or any Kinetic.Node subclass)
  // layer: a Kinetic.Layer object
  Bq.Cell = function(outer, inner, layer) {
    this.outer = outer;
    this.inner = inner;
    this.layer = layer;
  }

  // cell id (given by hashCellPair) -> Cell object
  Bq.Cell.cellCache = {};

  // Flash yellow and black. For debuggin
  Bq.Cell.prototype.alert = function() {
    this.highlight()

    // Fucking js
    var that = this;
    window.setTimeout(function() {
      that.unhighlight()
    }, 1500);
  }

  //Changes the cell to the highlighted color scheme
  Bq.Cell.prototype.highlight = function() {
    this.outer.setAttr('fill', cellHighlightBgColor);
    this.inner.setAttr('fill', cellHighlightFgColor);
    this.layer.draw();
  }

  //Returns a cell to non-highlighted color scheme
  Bq.Cell.prototype.unhighlight = function() {
    this.outer.setAttr('fill', cellBgColor)
    this.inner.setAttr('fill', cellFgColor)
    this.layer.draw();
  }
  // Update the cell.
  // options = {
  //	 outer: (attributes hash for Kinetic.Rect)
  //	 inner: (attributes hash for Kinetic.Text)
  //	 text: (string)
  // }
  Bq.Cell.prototype.update = function(options) {
    if (options['outer'])
      this.outer.setAttrs(options['outer']);
    if (options['inner'])
      this.inner.setAttrs(options['inner']);
    if (options['sprite'])
      this.inner = options['sprite'];
    //inneficient to redraw everytime we update a cell if we will often update them all at the same time 
    //this.layer.draw();
  };

  // Fetch or create a Cell object representing the cell with id ID
  Bq.Cell.getCellById = function (id) {
    var cell = Bq.map.stage.find("#" + id)[0];
    var cellOuter = cell.getChildren()[0];
    var cellInner = cell.getChildren()[1];

    // Memoize...
    if (!(id in Bq.Cell.cellCache)) {
      Bq.Cell.cellCache[id] = new Bq.Cell(cellOuter, cellInner, Bq.map.fgLayer);
    }
    return Bq.Cell.cellCache[id]
  };

  // Always returns a string which is unique for any pair (x, y)
  Bq.Cell.hashCellPair = function(x, y) {
    return "(" + x + ", " + y + ")"
  };

  //Return the cell at location (x,y)
  Bq.Cell.getCell = function(x,y) {
    return Bq.Cell.getCellById(Bq.Cell.hashCellPair(x - 1, (Bq.mapData.n - y)));
  }

});
