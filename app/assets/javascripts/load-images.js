Bq.images = { tiles: {}, items: {} };

Bq.images.loadImage = function (pathdict, imgdict, keyIndex) {
  var pathdictKeys = Object.keys(pathdict);
  if (pathdictKeys[keyIndex] == null) {
    Bq.map.stage.draw();
    return;
  }
  var key=pathdictKeys[keyIndex];
  imgdict[key] = new Image();
  imgdict[key].onload = function() {
    Bq.images.loadImage(pathdict, imgdict, keyIndex+1)    
  };
  imgdict[key].src = pathdict[key];
};

Bq.images.loadImage(tileSpritePaths, Bq.images.tiles, 0);
