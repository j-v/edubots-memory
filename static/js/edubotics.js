(function() {
  var $, match, root, victory, wrong;

  $ = jQuery;

  root = window;

  victory = function(game) {
    var Game, animTile;
    root.location = 'robo:victory';
    Game = game;
    animTile = function(tile, animType) {
      return tile.animate(animType);
    };
    setTimeout((function() {
      var i, t, _ref, _results;
      _results = [];
      for (i = 0, _ref = game.tiles.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        t = game.tiles[i];
        t.animate('return');
        t.turned = true;
        setTimeout(animTile, Game.tileAnimDuration, t, 'turn');
        _results.push(setTimeout(animTile, 2 * Game.tileAnimDuration, t, 'return'));
      }
      return _results;
    }), Game.tileAnimDuration);
    return setTimeout(root.Game["new"], 4 * Game.tileAnimDuration);
  };

  match = function(game) {
    return root.location = 'robo:match';
  };

  wrong = function(game) {
    return root.location = 'robo:wrong';
  };

  $.ready = function() {
    var canvas;
    canvas = $('#myCanvas')[0];
    root.Game.init(canvas);
    Game.on('victory', victory);
    Game.on('match', match);
    Game.on('wrong', wrong);
    return Game.start();
  };

}).call(this);
