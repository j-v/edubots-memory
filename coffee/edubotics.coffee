$ = jQuery
root = window

victory = (game) ->
  # root.location = 'robo:openbeak'
  root.location = 'robo:victory'
  
  # spin all the tiles
  Game = game
  animTile = (tile, animType) -> tile.animate animType
  setTimeout (() ->
    for i in [0..game.tiles.length-1]
      t = game.tiles[i]
      t.animate 'return'
      t.turned = true
      setTimeout animTile, Game.tileAnimDuration, t, 'turn'
      setTimeout animTile, 2 * Game.tileAnimDuration, t, 'return' ), Game.tileAnimDuration
  
  setTimeout root.Game.new, 4 * Game.tileAnimDuration



match = (game) ->
  #root.location = 'robo:leftwing'
  root.location = 'robo:match'

wrong = (game) ->
  # root.location = 'robo:shake'
  root.location = 'robo:wrong'

$.ready = ->
  canvas = $('#myCanvas')[0]

  root.Game.init canvas 
  Game.on 'victory', victory 
  Game.on 'match', match
  Game.on 'wrong', wrong
  Game.start()
  
