import
  os,
  system,
  nim_tiled,
  entity/[door],
  ecs,
  maths,
  art,
  platform,
  assets,
  entity_assembler,
  systems/physics,
  body,
  strformat

type 
  GameWorld* = ref object
    chunks: seq[TiledMap]
    tileSheet: Image

    doorId: string
    worldId: string

    roomStack: seq[TiledMap]
    
var worlds = newSeq[string]()
for ttype, thing in walkDir("assets/maps/"):
  case ttype:
  of pcDir:
    worlds.add extractFilename(thing)
  else: discard

echo worlds

proc currentWorld* (world: GameWorld): string=
  result = world.worldId

proc movePlayerToDoor* (world: GameWorld)

proc pushRoom* (world: GameWorld, path: string, movePlayer = true)=
  let map = loadTiledMap(path)
  world.roomStack.add(map)

  # Handle entity creation
  var total = newSeq[TiledObject]()
  for group in map.objectGroups:
    for o in group.objects:
      total.add(o)

  makeEntitiesFromTiled(total)
  setTiledObjects(total)

  if not movePlayer: return

  world.movePlayerToDoor()

proc popRoom* (world: GameWorld)=
  # Destroy entities that arent persistant

  discard world.roomStack.pop()

proc movePlayerToDoor* (world: GameWorld)=
  let player = getFirstThatMatch(@["Player"])
  let doors = getAllThatMatch(@["Door"])
  for door in doors:
    if door.get(Door).id == world.doorId:
      var body = player.get(Body)
      body.position = door.get(Body).position - Vec2(0, body.height) * 1

      let (ww, wh) = platform.windowSize()
      MainCamera().position = body.center - Vec2((ww.float / 2.0), (wh.float / 2.0))

proc newGameWorld* (): auto=
  result = GameWorld(
    chunks: @[],
    roomStack: @[],
    doorId: "",
    worldId: "World1",
    tileSheet: assets.getImage("tiles"))

proc update* (world: GameWorld)=
  let player = getFirstThatMatch(@["Player"])
  if player != nil:
    discard

  if world.roomStack.len == 0:
    return

  let map = world.roomStack[world.roomStack.len-1]
  let (ww, _) = platform.windowSize()

  if MainCamera.x < 0: MainCamera.x = 0
  if (MainCamera.x + ww.float) / MainCamera.zoom > map.width.float * map.tilewidth.float:
    MainCamera.x = map.width.float * map.tilewidth.float - (ww.float / MainCamera.zoom);

  let doors = getAllThatMatch(@["Door"])
  for door in doors:
    let doorC = door.get(Door)
    if doorC.pushTheRoom:
      killAll()
      world.doorId = doorC.id
      world.pushRoom(doorC.toPath)
      doorC.pushTheRoom = false

    if doorC.popTheRoom:
      killAll()
      world.popRoom()

      world.doorId = doorC.id

      let map = world.roomStack[world.roomStack.len - 1]
      var total = newSeq[TiledObject]()
      for group in map.objectGroups:
        for o in group.objects:
          total.add(o)

      makeEntitiesFromTiled(total)
      setTiledObjects(total)

      world.movePlayerToDoor()

      doorC.popTheRoom = false

proc drawFg* (world: GameWorld)=
  if world.roomStack.len == 0: return

  let top = world.roomStack[world.roomStack.len - 1]
  R2D.drawTiledMapFg(top, world.tileSheet)

proc drawBg* (world: GameWorld)=
  if world.roomStack.len == 0: return

  let top = world.roomStack[world.roomStack.len - 1]
  R2D.drawTiledMapBg(top, world.tileSheet)
