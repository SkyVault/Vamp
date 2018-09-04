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

type byte = uint8

type
  MapTile = ref object
    surface: sdl.Surface

  WorldButtonState = ref object
    collapsed: bool
    path: string
    mapTiles: seq[MapTile]

if platform.init((1280, 720), "DevWindow") == Failure:
  discard

initInput()

let mainFont = R2D.loadFont("../assets/fonts/Minecraft.ttf", 32)
var worldButtonStates: seq[WorldButtonState] = @[]

proc bakeMapToSurface(map: TiledMap): sdl.Surface=
  var data = newSeq[byte](map.width * map.height * 4)

  for layer in map.layers:
    if layer.properties.hasKey "fg": continue

    for y in 0..<map.height:
      for x in 0..<map.width:
        let color =
          (if layer.tiles[x + y * map.width] != 0: 0xff else: 0x00)

        if data[4 * (x + y * map.width) + 0] != 0: continue
        data[4 * (x + y * map.width) + 0] = color.byte
        data[4 * (x + y * map.width) + 1] = color.byte
        data[4 * (x + y * map.width) + 2] = color.byte
        data[4 * (x + y * map.width) + 3] = color.byte

  result = sdl.createRGBSurfaceFrom(
    addr data[0],
    map.width,
    map.height,
    depth=32,
    map.width * 4,
    0xff000000.uint32,
    0x00ff0000.uint32,
    0x0000ff00.uint32,
    0x000000ff.uint32)

  if result == nil:
    echo sdl.getError()

proc loadAllMaps()=
  for kind, path in walkDir("../assets/maps/"):
    if kind == pcDir:
      var state = WorldButtonState(
        collapsed: true,
        path: path,
        mapTiles: @[])

      worldButtonStates.add state

      for fkind, file in walkDir(path):
        if fkind == pcFile:
          let splits = file.split '.'
          if splits[splits.len - 1] != "tmx": continue

          var map = loadTiledMap(file)

          block:
            var tile = MapTile(
              surface: bakeMapToSurface(map))

            state.mapTiles.add tile
          
          block:
            var tile = MapTile(
              surface: bakeMapToSurface(map))

            state.mapTiles.add tile

loadAllMaps()

proc renderRightSidePanel()=
  let (w, h) = windowSize()
  let width = w.float * 0.25
  R2D.setColor (0.2, 0.2, 0.2, 1.0)
  R2D.rect(w.float - width, 0, width, h.float)

  var offset_y = 0.0

  for i, state in worldButtonStates:
    var hot = false
    const height = 64.0
    const margin = 8.0
    let yy = i.float * height + (margin * i.float)
    let y = yy + offset_y
    let x = w.float - width

    let (mx, my) = mousePos()
    if mx >= x and mx < x + width and my >= y and my < y + height:
      hot = true
      if isMouseLeftPressed():
        state.collapsed = not state.collapsed
        echo &"Clicked {i}"

    R2D.setColor (if not hot: (0.4, 0.4, 0.4, 1.0) else: (0.6, 0.6, 0.6, 0.6))
    R2D.rect(w.float - width, y, width, height)

    R2D.setColor (1.0, 1.0, 1.0, 1.0)
    R2D.drawString(mainFont, state.path.extractFilename, w.float - width, y, 1.0)

    # Draw triangle
    R2D.setColor (0.9, 0.9, 0.9, 1.0)

    if state.collapsed:
      R2D.line(x + width - 32, y, x + width, y + height / 2.0, 4)
      R2D.line(x + width - 32, y + height, x + width, y + height / 2.0, 4)
    else:
      R2D.line(x + width - 32, y + height, x + width, y + height / 2.0, 4)
      R2D.line(x + width - 64, y + height / 2.0, x + width - 32, y + height, 4)

      # Draw the map tiles
      var cursor_y = 0.0
      for i, mapTile in state.mapTiles:
        let surface = mapTile.surface
        var texture = sdl.createTextureFromSurface(R2D, surface)
        let scale = 1.0
        let subHeight = surface.h.float * scale
        var rect = sdl.Rect(
          x: x.int,
          y: (yy + height + (cursor_y)).int,
          w: (surface.w.float * scale).int,
          h: (surface.h.float * scale).int)
        if R2D.renderCopy(texture, nil, addr(rect)) == 0:
          discard
        offset_y += subHeight + margin
        cursor_y += subHeight + (margin)

        R2D.lineRect(rect.x.float, rect.y.float, width, subHeight)
      

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

  renderRightSidePanel()

  R2D.renderPresent()
