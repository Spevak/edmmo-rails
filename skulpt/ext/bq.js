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
		constants: {}, // constants for other stuff such as Cell, Map
		mapData: {},
		setMapData: function(data) { this.mapData = data; },
		playerData: {},
                setPlayerData: function(data) { this.playerData = data; },
                tileProperties: {},
                setTileProperties: function(data) { this.tileProperties = data; },
		log: log
  }
})(); 

goog.exportSymbol("Bq", Bq);
