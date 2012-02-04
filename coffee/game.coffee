$ = jQuery
root = window

`shuffle = function(o){ //v1.0
	for(var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
	return o;

      };`


root.loadImage = (img_file, callback) ->
  image = new Image()
  image.onload = ->
    err = null
    callback(err, image)
  image.src = 'img/' + img_file

root.Game = Game = {}

# GAME PARAMS
GAME_DEFAULT_WIDTH = 4
GAME_DEFAULT_HEIGHT = 3 
GAME_BG_TILE_IMG = "bg.png"
Game.tileWidth = 100
Game.tileHeight = 100
Game.fps = 15
Game.tilePad = 20
# ----------

GAME_STATE_TURN = 0
GAME_STATE_CHECKING = 1
GAME_STATE_WON = 2
GAME_STATE_WAIT = 3

Game.init = (canvas, params = {} ) ->

  Game.canvas = canvas
  Game.initEvents()

  Game.ctx = canvas.getContext '2d'
  root.loadImage GAME_BG_TILE_IMG, (err, img) ->
    Game.tileBgImage = img

  Game.width = params.width || GAME_DEFAULT_WIDTH
  Game.height = params.height || GAME_DEFAULT_HEIGHT
  Game._matchesLeft = (Game.width * Game.height)/2

  Game.new()


Game.new = () ->

  Game.started = false
  Game.tile1 = null
  Game.tile2 = null
  Game.tileClasses = [
    new root.TileClass('tile1.png'),
    new root.TileClass('tile2.png'),
    new root.TileClass('tile3.png')
  ]

  # put together the board
  tiles = []
  curTileIndex = 0
  for i in [0..(Game.width*Game.height)/2 - 1]
    tiles.push new root.Tile(Game.tileClasses[curTileIndex])
    tiles.push new root.Tile(Game.tileClasses[curTileIndex])
    curTileIndex += 1
    curTileIndex = 0 if curTileIndex == Game.tileClasses.length
  Game.tiles = shuffle(tiles)
  
Game.getTile = (x,y) ->
  return Game.tiles[y*Game.width + x]
  
Game.draw = () ->
  Game.ctx.clearRect 0, 0, Game.canvas.width, Game.canvas.height
  pad = Game.tilePad
  for x in [0..Game.width - 1]
    for y in [0..Game.height - 1]
      tile = Game.getTile(x,y)
      if tile.turned
        Game.ctx.drawImage tile.tileClass.image, 0, 0, Game.tileHeight, Game.tileWidth,
          pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth
      else
        Game.ctx.drawImage Game.tileBgImage, 0, 0, Game.tileHeight, Game.tileWidth,
          pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth


Game.start = () ->
  if not Game.started
    # Start the game loop
    Game._intervalId = setInterval Game.run, 1000 / Game.fps
    Game.started = true
    Game.state = GAME_STATE_TURN

Game.stop = () ->
  if Game.started
    clearTimeout Game._intervalId
    Game.started = false
    

Game.run = () ->
  #Game.update()
  Game.draw()

 getPosition = (e) ->
  e = window.event if not e?
  targ = if e.target? then e.target else e.srcElement
  targ = targ.parentNode if targ.nodeType == 3 # safari bugfix

  $targ = $(targ)
  x = e.pageX - $targ.offset().left
  y = e.pageY - $targ.offset().top

  {x: x, y: y}

Game.initEvents = () ->
  $(Game.canvas).click (ev) ->
      if Game.started and Game.state != GAME_STATE_WAIT
        {x, y} = getPosition(ev)
        tileX = Math.floor(x/(Game.tileWidth+Game.tilePad))
        tileY = Math.floor(y/(Game.tileHeight+Game.tilePad))
        tile = Game.getTile(tileX,tileY)

        if tile.turned
          # do nothing
        else if not Game.tile1?
          Game.tile1 = tile
          tile.turned = true 
        else # choose tile2
          Game.tile2 = tile
          tile.turned = true

          if Game.tile1.tileClass == Game.tile2.tileClass  # MATCH
            Game._matchesLeft -= 1
            Game.emit 'match', Game
            if Game._matchesLeft == 0
              Game.emit 'victory', Game
            Game.tile1 = null
            Game.tile2 = null
          else # NO MATCH
            Game.state = GAME_STATE_WAIT
            Game.emit 'wrong', Game

            newTurn = ->
              Game.tile1.turned = false
              Game.tile2.turned = false
              Game.state = GAME_STATE_TURN
              Game.tile1 = null
              Game.tile2 = null
            setTimeout newTurn, 1000



# Event Emitter
Game._listeners = {}
Game.emit = (eventName, arg) ->
  if Game._listeners[eventName]?
    for l in Game._listeners[eventName]
      l arg
Game.on = (eventName, listener) ->
  if not Game._listeners[eventName]?
    Game._listeners[eventName] = []
  Game._listeners[eventName].push listener
