require 'json'

#the maximum index 
MAP_MAX_INDEX = 7

TILE_PROPERTIES = JSON.parse(open("config/map/tiles/properties.json").read)
ITEM_PROPERTIES = JSON.parse(open("config/item/itemproperties.json").read)
