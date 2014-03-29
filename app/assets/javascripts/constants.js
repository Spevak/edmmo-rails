//This file will be included in skulpt before comilation, as well as copied to app/assets,
//so the constants will be available both within skulpt code and outside of it.

//This is the distance of the edge of the map to the player character in all directions.
//The player character is considered to be at (0, 0), and the corners of the map are 
//(+/- MAP_MAX_INDEX, +/- MAP_MAX_INDEX). Therefore the side length of the map is 2*MAP_MAX_INDEX + 1
var MAP_MAX_INDEX = 12;

//A map of tile ids to their ascii representation
var tileChars = {
    0:'0',
    1:'1'
};
