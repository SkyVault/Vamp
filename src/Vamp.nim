import 
  sdl2/sdl,
  input,
  times,
  art,
  items,
  dialog,
  nim_tiled,
  body,
  ecs,
  maths,
  math,
  random,
  systems/[physics, enemies, player, renderable],
  scenery,
  assets,
  platform,
  entity_assembler,
  json,
  os,
  system

if platform.init((1280, 720), "DevWindow") == Failure:
  discard

initInput()

let time = (200 * cpuTime() + epochTime()).int64
randomize(time)

assets.addFont(R2D.loadFont("assets/fonts/arial.ttf", 32), "arial")

# Loadeng assets
assets.addImage(R2D.loadImage "assets/images/player.png", "player")
assets.addImage(R2D.loadImage "assets/images/tilesheet.png", "tiles")
assets.addImage(R2D.loadImage "assets/images/walker_enemy.png", "walker_enemy")
assets.addImage(R2D.loadImage "assets/images/items.png", "items")

# Load json datae
assets.addJson(parseFile("assets/dialog/sample.json"), "sample")
#for file in walkFiles("./assets/dialog"):
  #echo file

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

let img = assets.getImage("tiles")

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

  if CurrentGameState() != GameState.Paused:
    Scenery.update()
    EntityWorld.update()

  dialog.update()

  if isKeyPressed(Key.ESCAPE):
    Quit()

  MainCamera.zoom = 4
  
  EntityWorld.draw()
  R2D.drawTiledMap(map, img)
  Scenery.draw()

  R2D.setColor((1, 1, 1, 1))
  R2D.drawString(assets.getFont "arial", "Hello World :)", 10, 10)

  dialog.draw()

  R2D.renderPresent()
