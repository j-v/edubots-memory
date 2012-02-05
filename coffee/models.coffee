root = window

root.Tile = class Tile
  constructor: (@tileClass) ->
    @turned = false
    @anim = null


root.TileClass = class TileClass
  constructor: (@imgName) ->
    root.loadImage @imgName, (err, img) => @image = img

