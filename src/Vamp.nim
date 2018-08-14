import 
  sdl2/sdl,
  input,
  times,
  art,
  items,
  nim_tiled,
  body,
  ecs,
  maths,
  math,
  random,
  systems/physics,
  systems/enemies,
  systems/player,
  systems/renderable,
  scenery,
  assets,
  platform,
  entity_assembler

if platform.init((1280, 720), "Hello World") == Failure:
  discard

initInput()

let time = (200 * cpuTime() + epochTime()).int64
randomize(time)

# Loadeng assets
assets.add(R2D.loadImage "assets/images/player.png", "player")
assets.add(R2D.loadImage "assets/images/tilesheet.png", "tiles")
assets.add(R2D.loadImage "assets/images/walker_enemy.png", "walker_enemy")
assets.add(R2D.loadImage "assets/images/items.png", "items")

let map = loadTiledMap "assets/maps/map_1.tmx"

makeEntity("Player", 400, 400)

makeEntity("WiseOldWoman", 460, 300)

makeEntity("Walker", 400 - 128, 400)
makeEntity("Sword", 198, 0)

var total = newSeq[TiledObject]()
for group in map.objectGroups:
  for o in group.objects:
    total.add(o)

SetTiledObjects(total)

let img = assets.get(Image, "tiles")

# Game loop
while CurrentGameState() != Quiting:
  discard R2D.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
  discard R2D.renderClear()

  inputUpdate()

  var e: sdl.Event
  while sdl.pollEvent(addr e) != 0:
    if e.kind == sdl.Quit: Quit()
    inputHandleEvent(e)

  if GameClock.ticks mod 100 == 0:
    echo GameClock.fps

  platform.update()

  Scenery.update()
  EntityWorld.update()

  if isKeyPressed(Key.ESCAPE):
    Quit()

  MainCamera.zoom = 4
  
  EntityWorld.draw()
  R2D.drawTiledMap(map, img)
  Scenery.draw()

  R2D.renderPresent()
