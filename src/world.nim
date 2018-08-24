import
  nim_tiled,
  ecs,
  maths,
  art,
  platform,
  assets,
  body,
  strformat

type 
  GameWorld* = ref object
    chunks: seq[TiledMap]
    tileSheet: Image

proc newGameWorld* (): auto=
  result = GameWorld(
    chunks: @[],
    tileSheet: assets.getImage("tiles"))

  result.chunks.add(loadTiledMap "assets/maps/map_1.tmx")

proc update* (world: GameWorld)=
  let player = getFirstThatMatch(@["Player"])
  if player == nil: return
  
proc drawFg* (world: GameWorld)=
  for chunk in world.chunks:
    R2D.drawTiledMapFg(chunk, world.tileSheet)

proc drawBg* (world: GameWorld)=
  for chunk in world.chunks:
    R2D.drawTiledMapBg(chunk, world.tileSheet)
