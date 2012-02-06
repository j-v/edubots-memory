(function() {
  var Animatable, Tile, TileClass, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = window;

  root.Animatable = Animatable = (function() {

    function Animatable() {}

    Animatable.prototype.anim = null;

    Animatable.prototype.animate = function(type) {
      return this.anim = {
        type: type,
        start: (new Date).getTime()
      };
    };

    return Animatable;

  })();

  root.Tile = Tile = (function(_super) {

    __extends(Tile, _super);

    function Tile(tileClass) {
      this.tileClass = tileClass;
      this.turned = false;
    }

    return Tile;

  })(Animatable);

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
