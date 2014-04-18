Bq.images = { tiles: {}, items: {} }

for (var i = 0; i < tileSpritePaths.length; i++) {
  var imgObj = new Image();
  imgObj.onLoad = function() {
    Bq.images.tiles[i] = imgObj;
  }
  imgObj.src = tileSpritePaths[i];
}
