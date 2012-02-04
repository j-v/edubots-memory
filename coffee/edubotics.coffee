$ = jQuery
root = window

victory = (game) ->
  root.location = 'robo:openbeak'
  # root.location = 'robo:victory'

match = (game) ->
  root.location = 'robo:leftwing'
  # root.location = 'robo:match'

wrong = (game) ->
  root.location = 'robo:shake'
  # root.location = 'robo:wrong'

$.ready = ->
  canvas = $('#myCanvas')[0]

  root.Game.init canvas 
  Game.on 'victory', victory 
  Game.on 'match', match
  Game.on 'wrong', wrong
  Game.start()
  
