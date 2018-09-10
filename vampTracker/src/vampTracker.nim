import
  ../../src/platform,
  ../../src/input,
  ../../src/art,

  math,
  strformat,
  strutils,
  ospaths,
  nim_tiled,
  tables,
  sdl2/sdl,
  os

if platform.init((1280, 720), "DevWindow") == Failure:
  discard

initInput()

let mainFont = R2D.loadFont("../assets/fonts/Minecraft.ttf", 32)

# Game loop
while CurrentGameState() != Quiting:
  discard R2D.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
  discard R2D.renderClear()

  inputUpdate()

  var e: sdl.Event
  while sdl.pollEvent(addr e) != 0:
    if e.kind == sdl.Quit: Quit()
    inputHandleEvent(e)

  # if GameClock.ticks mod 100 == 0:
  #   echo GameClock.fps
  
  platform.update()

  if isKeyPressed(Key.ESCAPE):
    Quit()

  R2D.renderPresent()
