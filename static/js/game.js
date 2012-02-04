(function() {
  var $, GAME_BG_TILE_IMG, GAME_DEFAULT_HEIGHT, GAME_DEFAULT_WIDTH, GAME_STATE_CHECKING, GAME_STATE_TURN, GAME_STATE_WAIT, GAME_STATE_WON, Game, getPosition, root;

  $ = jQuery;

  root = window;

  shuffle = function(o){ //v1.0
	for(var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
	return o;

      };;

  root.loadImage = function(img_file, callback) {
    var image;
    image = new Image();
    image.onload = function() {
      var err;
      err = null;
      return callback(err, image);
    };
    return image.src = 'img/' + img_file;
  };

  root.Game = Game = {};

  GAME_DEFAULT_WIDTH = 4;

  GAME_DEFAULT_HEIGHT = 3;

  GAME_BG_TILE_IMG = "bg.png";

  Game.tileWidth = 100;

  Game.tileHeight = 100;

  Game.fps = 15;

  Game.tilePad = 20;

  GAME_STATE_TURN = 0;

  GAME_STATE_CHECKING = 1;

  GAME_STATE_WON = 2;

  GAME_STATE_WAIT = 3;

  Game.init = function(canvas, params) {
    if (params == null) params = {};
    Game.canvas = canvas;
    Game.initEvents();
    Game.ctx = canvas.getContext('2d');
    root.loadImage(GAME_BG_TILE_IMG, function(err, img) {
      return Game.tileBgImage = img;
    });
    Game.width = params.width || GAME_DEFAULT_WIDTH;
    Game.height = params.height || GAME_DEFAULT_HEIGHT;
    Game._matchesLeft = (Game.width * Game.height) / 2;
    return Game["new"]();
  };

  Game["new"] = function() {
    var curTileIndex, i, tiles, _ref;
    Game.started = false;
    Game.tile1 = null;
    Game.tile2 = null;
    Game.tileClasses = [new root.TileClass('tile1.png'), new root.TileClass('tile2.png'), new root.TileClass('tile3.png')];
    tiles = [];
    curTileIndex = 0;
    for (i = 0, _ref = (Game.width * Game.height) / 2 - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
      tiles.push(new root.Tile(Game.tileClasses[curTileIndex]));
      tiles.push(new root.Tile(Game.tileClasses[curTileIndex]));
      curTileIndex += 1;
      if (curTileIndex === Game.tileClasses.length) curTileIndex = 0;
    }
    return Game.tiles = shuffle(tiles);
  };

  Game.getTile = function(x, y) {
    return Game.tiles[y * Game.width + x];
  };

  Game.draw = function() {
    var pad, tile, x, y, _ref, _results;
    Game.ctx.clearRect(0, 0, Game.canvas.width, Game.canvas.height);
    pad = Game.tilePad;
    _results = [];
    for (x = 0, _ref = Game.width - 1; 0 <= _ref ? x <= _ref : x >= _ref; 0 <= _ref ? x++ : x--) {
      _results.push((function() {
        var _ref2, _results2;
        _results2 = [];
        for (y = 0, _ref2 = Game.height - 1; 0 <= _ref2 ? y <= _ref2 : y >= _ref2; 0 <= _ref2 ? y++ : y--) {
          tile = Game.getTile(x, y);
          if (tile.turned) {
            _results2.push(Game.ctx.drawImage(tile.tileClass.image, 0, 0, Game.tileHeight, Game.tileWidth, pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth));
          } else {
            _results2.push(Game.ctx.drawImage(Game.tileBgImage, 0, 0, Game.tileHeight, Game.tileWidth, pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth));
          }
        }
        return _results2;
      })());
    }
    return _results;
  };

  Game.start = function() {
    if (!Game.started) {
      Game._intervalId = setInterval(Game.run, 1000 / Game.fps);
      Game.started = true;
      return Game.state = GAME_STATE_TURN;
    }
  };

  Game.stop = function() {
    if (Game.started) {
      clearTimeout(Game._intervalId);
      return Game.started = false;
    }
  };

  Game.run = function() {
    return Game.draw();
  };

  getPosition = function(e) {
    var $targ, targ, x, y;
    if (!(e != null)) e = window.event;
    targ = e.target != null ? e.target : e.srcElement;
    if (targ.nodeType === 3) targ = targ.parentNode;
    $targ = $(targ);
    x = e.pageX - $targ.offset().left;
    y = e.pageY - $targ.offset().top;
    return {
      x: x,
      y: y
    };
  };

  Game.initEvents = function() {
    return $(Game.canvas).click(function(ev) {
      var newTurn, tile, tileX, tileY, x, y, _ref;
      if (Game.started && Game.state !== GAME_STATE_WAIT) {
        _ref = getPosition(ev), x = _ref.x, y = _ref.y;
        tileX = Math.floor(x / (Game.tileWidth + Game.tilePad));
        tileY = Math.floor(y / (Game.tileHeight + Game.tilePad));
        tile = Game.getTile(tileX, tileY);
        if (tile.turned) {} else if (!(Game.tile1 != null)) {
          Game.tile1 = tile;
          return tile.turned = true;
        } else {
          Game.tile2 = tile;
          tile.turned = true;
          if (Game.tile1.tileClass === Game.tile2.tileClass) {
            Game._matchesLeft -= 1;
            Game.emit('match', Game);
            if (Game._matchesLeft === 0) Game.emit('victory', Game);
            Game.tile1 = null;
            return Game.tile2 = null;
          } else {
            Game.state = GAME_STATE_WAIT;
            Game.emit('wrong', Game);
            newTurn = function() {
              Game.tile1.turned = false;
              Game.tile2.turned = false;
              Game.state = GAME_STATE_TURN;
              Game.tile1 = null;
              return Game.tile2 = null;
            };
            return setTimeout(newTurn, 1000);
          }
        }
      }
    });
  };

  Game._listeners = {};

  Game.emit = function(eventName, arg) {
    var l, _i, _len, _ref, _results;
    if (Game._listeners[eventName] != null) {
      _ref = Game._listeners[eventName];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        l = _ref[_i];
        _results.push(l(arg));
      }
      return _results;
    }
  };

  Game.on = function(eventName, listener) {
    if (!(Game._listeners[eventName] != null)) Game._listeners[eventName] = [];
    return Game._listeners[eventName].push(listener);
  };

}).call(this);
