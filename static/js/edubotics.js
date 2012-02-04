(function() {
  var $, match, root, victory, wrong;

  $ = jQuery;

  root = window;

  victory = function(game) {
    return root.location = 'robo:openbeak';
  };

  match = function(game) {
    return root.location = 'robo:leftwing';
  };

  wrong = function(game) {
    return root.location = 'robo:shake';
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
