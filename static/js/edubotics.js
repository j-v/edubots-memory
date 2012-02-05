(function() {
  var $, match, root, victory, wrong;

  $ = jQuery;

  root = window;

  victory = function(game) {
    root.location = 'robo:victory';
    return setTimeout(root.Game["new"](), 1500);
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
