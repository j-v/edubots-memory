root = window
root.Animatable = class Animatable
  anim: null
  animate: (type) ->
    @anim = 
      type: type
      start: (new Date).getTime()

root.Tile = class Tile extends Animatable
  constructor: (@tileClass) ->
    @turned = false


root.TileClass = class TileClass
  constructor: (@imgName) ->
    root.loadImage @imgName, (err, img) => @image = img

