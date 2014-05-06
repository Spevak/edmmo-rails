//This file will be included in skulpt before comilation, as well as copied to app/assets,
//so the constants will be available both within skulpt code and outside of it.

//This is the distance of the edge of the map to the player character in all directions.
//The player character is considered to be at (0, 0), and the corners of the map are 
//(+/- MAP_MAX_INDEX, +/- MAP_MAX_INDEX). Therefore the side length of the map is 2*MAP_MAX_INDEX + 1
var MAP_MAX_INDEX = 7;

//conversion of integer to string direction
var direction = {0:'north', 1:'east',2:'south',3:'west'}

//A map of itemIds
var itemId = {
    'cake': 0,
    'nowhere' : 1,
    'handsfull' : 2,
    'nothing': 3,
    'occupied': 4
}

//A map of tile ids to their sprite representation
var tileSpritePaths = {
    0: '/assets/tiles/tile_dirt.png',
    1: '/assets/tiles/tile_sand.png',
    2: '/assets/tiles/tile_mud.png',
    3: 'assets/tiles/tile_acid.png', //acid
    4: 'assets/tiles/tile_boulder.png', //wall
    5: 'assets/tiles/tile_boulder.png', //north-facing ledge
    6: 'assets/tiles/tile_boulder.png', //west-facing ledge
    7: 'assets/tiles/tile_boulder.png', //south-facing ledge
    8: 'assets/tiles/tile_boulder.png', //east-facing ledge
    9: 'assets/tiles/tile_boulder.png', //northeast-facing ledge
    10: 'assets/tiles/tile_boulder.png', //northwest-facing ledge
    11: 'assets/tiles/tile_boulder.png', //southwest-facing ledge
    12: 'assets/tiles/tile_boulder.png', //southeast-facing ledge
    13: 'assets/tiles/tile_portal.png', //portal
    14: 'assets/tiles/tile_door_opened.png', //locked door
    15: 'assets/tiles/tile_door_closed.png', //open door
    16: 'assets/items/item_signPost.png',//sign

    //Representation of non-existant tile (off the map)
    50: 'assets/tiles/tile_placeholder.png',
    //Player character representations (one for each direction)
    51: 'assets/robot_n.png',
    52: 'assets/robot_s.png',
    53: 'assets/robot_e.png',
    54: 'assets/robot_w.png',

    //Use ascii values for Letters:
    65: 'assets/tiles/tile_placeholder.png',
    66: 'assets/tiles/tile_placeholder.png',
    67: 'assets/tiles/tile_placeholder.png',
    68: 'assets/tiles/tile_placeholder.png',
    69: 'assets/tiles/tile_placeholder.png',
    70: 'assets/tiles/tile_placeholder.png',
    71: 'assets/tiles/tile_placeholder.png',
    72: 'assets/tiles/tile_placeholder.png',
    73: 'assets/tiles/tile_placeholder.png',
    74: 'assets/tiles/tile_placeholder.png',
    75: 'assets/tiles/tile_placeholder.png',
    76: 'assets/tiles/tile_placeholder.png',
    77: 'assets/tiles/tile_placeholder.png',
    78: 'assets/tiles/tile_placeholder.png',
    79: 'assets/tiles/tile_placeholder.png',
    80: 'assets/tiles/tile_placeholder.png',
    81: 'assets/tiles/tile_placeholder.png',
    82: 'assets/tiles/tile_placeholder.png',
    83: 'assets/tiles/tile_placeholder.png',
    84: 'assets/tiles/tile_placeholder.png',
    85: 'assets/tiles/tile_placeholder.png',
    86: 'assets/tiles/tile_placeholder.png',
    87: 'assets/tiles/tile_placeholder.png',
    88: 'assets/tiles/tile_placeholder.png',
    89: 'assets/tiles/tile_placeholder.png',
    90: 'assets/tiles/tile_placeholder.png',

    97: 'assets/tiles/tile_placeholder.png',
    98: 'assets/tiles/tile_placeholder.png',
    99: 'assets/tiles/tile_placeholder.png',
    100: 'assets/tiles/tile_placeholder.png',
    101: 'assets/tiles/tile_placeholder.png',
    102: 'assets/tiles/tile_placeholder.png',
    103: 'assets/tiles/tile_placeholder.png',
    104: 'assets/tiles/tile_placeholder.png',
    105: 'assets/tiles/tile_placeholder.png',
    106: 'assets/tiles/tile_placeholder.png',
    107: 'assets/tiles/tile_placeholder.png',
    108: 'assets/tiles/tile_placeholder.png',
    109: 'assets/tiles/tile_placeholder.png',
    110: 'assets/tiles/tile_placeholder.png',
    111: 'assets/tiles/tile_placeholder.png',
    112: 'assets/tiles/tile_placeholder.png',
    113: 'assets/tiles/tile_placeholder.png',
    114: 'assets/tiles/tile_placeholder.png',
    115: 'assets/tiles/tile_placeholder.png',
    116: 'assets/tiles/tile_placeholder.png',
    117: 'assets/tiles/tile_placeholder.png',
    118: 'assets/tiles/tile_placeholder.png',
    119: 'assets/tiles/tile_placeholder.png',
    120: 'assets/tiles/tile_placeholder.png',
    121: 'assets/tiles/tile_placeholder.png',
    122: 'assets/tiles/tile_placeholder.png',

    //Characters used in the splash page ascii art start with 200
    200: 'assets/tiles/tile_placeholder.png',
    201: 'assets/tiles/tile_placeholder.png',
    202: 'assets/tiles/tile_placeholder.png',
    203: 'assets/tiles/tile_placeholder.png',
    204: 'assets/tiles/tile_placeholder.png',
    205: 'assets/tiles/tile_placeholder.png',
    206: 'assets/tiles/tile_placeholder.png',
    207: 'assets/tiles/tile_placeholder.png',
    208: 'assets/tiles/tile_placeholder.png',
    209: 'assets/tiles/tile_placeholder.png',
    210: 'assets/tiles/tile_placeholder.png',
    211: 'assets/tiles/tile_placeholder.png',
    212: 'assets/tiles/tile_placeholder.png',
    213: 'assets/tiles/tile_placeholder.png',
    214: 'assets/tiles/tile_placeholder.png',
    215: 'assets/tiles/tile_placeholder.png',
    216: 'assets/tiles/tile_placeholder.png',
    217: 'assets/tiles/tile_placeholder.png',
    218: 'assets/tiles/tile_placeholder.png',
    219: 'assets/tiles/tile_placeholder.png'

 
};

//A map of tile ids to their ascii representation
var tileChars = {
    0: ' ', //dirt
    1: '…', //sand
    2: '~', //mud
    3: '%', //acid
    4: '█', //wall
    5: '¯', //north-facing ledge
    6: '[', //west-facing ledge
    7: '_', //south-facing ledge
    8: ']', //east-facing ledge
    9: '╗', //northeast-facing ledge
    10: '╔', //northwest-facing ledge
    11: '╚', //southwest-facing ledge
    12: '╝', //southeast-facing ledge
    13: '@', //portal
    14: '☒', //locked door
    15: 'ロ', //open door
    16: '=',
    

    //Representation of non-existant tile (off the map)
    50: '#',
    //Player character representations (one for each direction)
    51: '^',
    52: 'v',
    53: '>',
    54: '<',

    //Use ascii values for Letters:
    65: 'A',
    66: 'B',
    67: 'C',
    68: 'D',
    69: 'E',
    70: 'F',
    71: 'G',
    72: 'H',
    73: 'I',
    74: 'J',
    75: 'K',
    76: 'L',
    77: 'M',
    78: 'N',
    79: 'O',
    80: 'P',
    81: 'Q',
    82: 'R',
    83: 'S',
    84: 'T',
    85: 'U',
    86: 'V',
    87: 'W',
    88: 'X',
    89: 'Y',
    90: 'Z',

    97: 'a',
    98: 'b',
    99: 'c',
    100: 'd',
    101: 'e',
    102: 'f',
    103: 'g',
    104: 'h',
    105: 'i',
    106: 'j',
    107: 'k',
    108: 'l',
    109: 'm',
    110: 'n',
    111: 'o',
    112: 'p',
    113: 'q',
    114: 'r',
    115: 's',
    116: 't',
    117: 'u',
    118: 'v',
    119: 'w',
    120: 'x',
    121: 'y',
    122: 'z',

    //Digits
    150: '0',
    151: '1',
    152: '2',
    153: '3',
    154: '4',
    155: '5',
    156: '6',
    157: '7',
    158: '8',
    159: '9',


    //Characters used in the splash page ascii art start with 200
    200: '█',
    201: '╗',
    202: '╔',
    203: '═',
    204: '╚',
    205: '╝',
    206: '║',
    207: '_',
    208: '|',
    209: '[',
    210: ']',
    211: '\\',
    212: '/',
    213: '(',
    214: ')',
    215: '^',
    216: ',',
    217: '¯',
    218: '.',
    219: '>'

 
};

//this could probably go in a better place but it's here for now
var splashArt = [
[200,200,200,200,200,200,201,  0,  0,200,200,200,200,200,200,201,  0,200,200,200,200,200,200,200,200],
[200,200,202,203,203,200,200,201,200,200,202,203,203,203,200,200,201,204,203,203,200,200,202,203,203],
[200,200,200,200,200,200,202,205,200,200,206,  0,  0,  0,200,200,206,  0,  0,  0,200,200,206,  0,  0],
[200,200,202,203,203,200,200,201,200,200,206,  0,  0,  0,200,200,206,  0,  0,  0,200,200,206,  0,  0],
[200,200,200,200,200,200,202,205,204,200,200,200,200,200,200,202,205,  0,  0,  0,200,200,206,  0,  0],
[204,203,203,203,203,203,205,  0,  0,204,203,203,203,203,203,205,  0,  0,  0,  0,204,203,205,  0,  0],
[  0,  0,207,207,207,207,  0,207,  0,  0,207,  0,207,207,207,207,  0,207,207,207,207,  0,207,207,207],
[  0,  0,208,  0,  0,208,  0,208,  0,  0,208,  0,208,207,207,207,  0,209,207,207,  0,  0,  0,208,  0],
[  0,  0,208,207,211,208,  0,208,207,207,208,  0,208,207,207,207,  0,207,207,207,210,  0,  0,208,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,207,  0,  0,  0,  0,  0,  0,  0,  0,207,  0,  0,  0,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,213,207,214,  0,  0,  0,  0,  0,  0,213,207,214,  0,  0,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,211,211,207,207,207,207,207,207,212,212,207,207,  0,  0],
[  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,212,211,211,  0,  0,  0,  0,212,212,  0,  0,212,208,  0],
[  0,  0,207,  0,  0,207,  0,  0,  0,  0,212,207,207,207,207,207,207,207,207,207,207,212,  0,208,  0],
[  0,212,212,  0,  0,211,211,  0,  0,  0,208,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,208,  0,208,  0],
[208,208,  0,  0,  0,208,208,  0,  0,  0,208,  0,  0,  0,215,  0,  0,215,  0,  0,  0,208,  0,208,  0],
[  0,211,211,  0,212,212,  0,  0,  0,  0,208,  0,  0,  0,  0,207,207,216,  0,  0,  0,208,  0,212,  0],
[  0,  0,208,  0,208,  0,  0,  0,  0,212,208,207,207,207,207,207,207,207,207,207,207,208,212,217,212],
[  0,  0,211,  0,211,  0,  0,  0,212,  0,  0,  0,  0,  0,208,  0,  0,  0,208,  0,  0,  0,  0,212,  0],
[  0,  0,  0,211,  0,211,  0,208,217,217,217,217,217,217,217,217,217,217,217,217,217,217,217,208,  0],
[  0,  0,  0,  0,211,  0,217,208,  0,208,217,217,217,217,217,217,217,217,217,217,217,208,  0,208,  0],
[  0,  0,  0,  0,  0,211,207,208,  0,208, 80,121,116,104,111,110,  0,  152,218,  156,  0,208,  0,208,  0],
[  0,  0,  0,  0,  0,  0,  0,208,  0,208,219,219,219,  0,  0,  0,  0,  0,  0,  0,  0,208,  0,208,  0]
]

Bq.constants.MAP_MAX_INDEX = MAP_MAX_INDEX;
Bq.constants.direction = direction;
Bq.constants.itemId = itemId;
Bq.constants.tileChars = tileChars;
Bq.constants.splashArt = splashArt;
Bq.constants.cellHeight = 30;
Bq.constants.cellWidth = 30;
