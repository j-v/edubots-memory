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

# GAME PARAS
GAME_DEFAULT_WIDTH = 5
GAME_DEFAULT_HEIGHT = 4 
GAME_BG_TILE_IMG = "bg2.png"
Game.tileWidth = 150
Game.tileHeight = 150
Game.fps = 15
Game.tilePad = 20
Game.tileAnimDuration = 1000
# ----------

GAME_STATE_TURN = 0
GAME_STATE_CHECKING = 1
GAME_STATE_WON = 2
GAME_STATE_WAIT = 3


Game.init = (canvas, params = {} ) ->
  Game._lastUpdate = (new Date).getTime()

  Game.canvas = canvas
  Game.initEvents()

  Game.ctx = canvas.getContext '2d'
  root.loadImage GAME_BG_TILE_IMG, (err, img) ->
    Game.tileBgImage = img

  Game.width = params.width || GAME_DEFAULT_WIDTH
  Game.height = params.height || GAME_DEFAULT_HEIGHT

  Game.new()


Game.new = () ->
  Game.state = GAME_STATE_WAIT

  Game._matchesLeft = (Game.width * Game.height)/2

  Game.tile1 = null
  Game.tile2 = null
  Game.tileClasses = [
    new root.TileClass('t1.png'),
    new root.TileClass('t2.png'),
    new root.TileClass('t3.png'),
    new root.TileClass('t4.png')
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

  # spin board
  animateTile = (tile, animType) ->
    tile.animate animType
  shuffTiles = shuffle((t for t in Game.tiles))
  for i in [0..shuffTiles.length-1]
    tile = shuffTiles[i]
    # setTimeout setAnim, i * 150, tile, {type:'turn',start: (new Date).getTime() + i*150}
    setTimeout animateTile, i * 150, tile, 'turn'
    setTimeout animateTile, i * 150 + Game.tileAnimDuration, tile, 'return'
  
  setTimeout (() ->  Game.state = GAME_STATE_TURN), shuffTiles.length * 150 + Game.tileAnimDuration
  
Game.getTile = (x,y) ->
  return Game.tiles[y*Game.width + x]
  
Game.draw = () ->
  time = (new Date).getTime()

  Game.ctx.clearRect 0, 0, Game.canvas.width, Game.canvas.height
  pad = Game.tilePad
  for x in [0..Game.width - 1]
    for y in [0..Game.height - 1]
      tile = Game.getTile(x,y)
      if not tile.anim?
        if tile.turned
          Game.ctx.drawImage tile.tileClass.image, 0, 0, Game.tileHeight, Game.tileWidth,
            pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth
        else
          Game.ctx.drawImage Game.tileBgImage, 0, 0, Game.tileHeight, Game.tileWidth,
            pad + ((Game.tileWidth + pad) * x), pad + ((Game.tileHeight + pad) * y), Game.tileHeight, Game.tileWidth
      else
        elapsed = time - tile.anim.start
        if tile.anim.type == 'turn'
          if elapsed < (Game.tileAnimDuration / 2)
            fraction = elapsed / (Game.tileAnimDuration / 2)
            renderWidth = (1-fraction) * Game.tileWidth
            Game.ctx.drawImage Game.tileBgImage, 0, 0, Game.tileHeight,
              Game.tileWidth, pad + ((Game.tileWidth + pad) * x) + (Game.tileWidth-renderWidth)/2,
              pad + ((Game.tileHeight + pad) * y), renderWidth, Game.tileHeight
          else
            fraction = elapsed / (Game.tileAnimDuration / 2 ) - 1
            renderWidth = (fraction) * Game.tileWidth
            Game.ctx.drawImage tile.tileClass.image, 0, 0, Game.tileHeight, Game.tileWidth,
              pad + ((Game.tileWidth + pad) * x) + (Game.tileWidth-renderWidth)/2, pad + ((Game.tileHeight + pad) * y), renderWidth, Game.tileHeight
        else if tile.anim.type == 'return'

          if elapsed < (Game.tileAnimDuration / 2)
            fraction = elapsed / (Game.tileAnimDuration / 2)
            renderWidth = (1-fraction) * Game.tileWidth
            Game.ctx.drawImage tile.tileClass.image, 0, 0, Game.tileHeight, Game.tileWidth, pad + ((Game.tileWidth + pad) * x) + (Game.tileWidth-renderWidth)/2, pad + ((Game.tileHeight + pad) * y), renderWidth, Game.tileHeight
          else
            fraction = elapsed / (Game.tileAnimDuration / 2 ) - 1
            renderWidth = (fraction) * Game.tileWidth
            Game.ctx.drawImage Game.tileBgImage, 0, 0, Game.tileHeight, Game.tileWidth, pad + ((Game.tileWidth + pad) * x) + (Game.tileWidth-renderWidth)/2,  pad + ((Game.tileHeight + pad) * y), renderWidth, Game.tileHeight

      if elapsed > Game.tileAnimDuration
        tile.anim = null


Game.start = () ->
  if not Game.started
    # Start the game loop
    Game._intervalId = setInterval Game.run, 1000 / Game.fps
    Game.started = true

Game.stop = () ->
  if Game.started
    clearTimeout Game._intervalId
    Game.started = false
    

Game.run = () ->
  #Game.update()
  Game.draw()
  Game._lastUpdate = (new Date).getTime()

 getPosition = (e) ->
  e = window.event if not e?
  targ = if e.target? then e.target else e.srcElement
  targ = targ.parentNode if targ.nodeType == 3 # safari bugfix

  $targ = $(targ)
  x = e.pageX - $targ.offset().left
  y = e.pageY - $targ.offset().top

  {x: x, y: y}

Game.initEvents = () ->
  # $(Game.canvas).click (ev) ->
  clickListener = (ev) ->
      if Game.started and Game.state != GAME_STATE_WAIT
        {x, y} = getPosition(ev)
        if x > Game.tilePad + Game.width * (Game.tileWidth+Game.tilePad) or y > Game.tilePad + Game.height * (Game.tileHeight+Game.tilePad)
          return #  click out of bounds


        tileX = Math.floor(x/(Game.tileWidth+Game.tilePad))
        tileY = Math.floor(y/(Game.tileHeight+Game.tilePad))
        tile = Game.getTile(tileX,tileY)

        if tile.turned
          # do nothing
        else if not Game.tile1?
          Game.tile1 = tile
          tile.turned = true 
          tile.anim = {type:'turn', start: (new Date).getTime()}
        else # choose tile2
          Game.tile2 = tile
          tile.turned = true
          tile.anim = {type:'turn', start: (new Date).getTime()}

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
              Game.tile1.anim = {type:'return', start:(new Date).getTime()}
              Game.tile2.anim = {type:'return', start:(new Date).getTime()}
              Game.tile1.turned = false
              Game.tile2.turned = false
              Game.state = GAME_STATE_TURN
              Game.tile1 = null
              Game.tile2 = null
            setTimeout newTurn, 1800
 

  # if root.isIpad 
    # alert('ipad mode')
    # if root.detectIphoneOrIpod()
    # $(Game.canvas).onTouchStart clickListener
    #  else 
    
  if root.isIpad
    $(Game.canvas)[0].ontouchstart = clickListener
  else
    $(Game.canvas).click clickListener

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
