(function() {
  var Tile, TileClass, root;

  root = window;

  root.Tile = Tile = (function() {

    function Tile(tileClass) {
      this.tileClass = tileClass;
      this.turned = false;
      this.anim = null;
    }

    return Tile;

  })();

  root.TileClass = TileClass = (function() {

    function TileClass(imgName) {
      var _this = this;
      this.imgName = imgName;
      root.loadImage(this.imgName, function(err, img) {
        return _this.image = img;
      });
    }

    return TileClass;

  })();

}).call(this);
