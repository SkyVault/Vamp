import
  sdl2/sdl,
  sdl2/sdl_ttf as ttf,
  input

var
  window: sdl.Window
  renderer: sdl.Renderer

const IS_DEBUG* = true
var Debugging* = false

template R2D* (): auto = renderer
template Win* (): auto = window

type
  Result* = enum
    Success,
    Failure

  GameState* = enum
    Running,
    Paused,
    Quiting

  Clock* = ref object
    dt*, fps*, timer*, last: float
    ticks*: int

var
  current_gamestate = Running
  clock = Clock(
    dt: 0, fps: 0, timer: 0, last: 0,
    ticks: -1 
  )

template GameClock* (): auto = clock

proc CurrentGameState* (): auto = current_gamestate

proc Pause* ()=
  current_gamestate = Paused

proc Resume* ()=
  current_gamestate = Running

proc Quit* ()=
  current_gamestate = Quiting

proc init* (size: (int, int), title: string): Result=
  result = Success
  if sdl.init(sdl.InitEverything) != 0:
    echo "ERROR:: Cannot initialize SDL: ", sdl.getError()
    result = Failure
    return 

  if ttf.init() != 0:
    echo "ERROR:: Cannot initialize SDL_ttf: ", ttf.getError()
    result = Failure
    return

  window = sdl.createWindow(
    title,
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    size[0],
    size[1],
    sdl.WINDOW_BORDERLESS or sdl.WINDOW_SHOWN or sdl.WINDOW_ALLOW_HIGHDPI or sdl.WINDOW_ALWAYS_ON_TOP)

  renderer = sdl.createRenderer(
    window,
    -1,
    sdl.RendererAccelerated or
    sdl.RendererPresentVsync)

  for i in 0..<sdl.numJoysticks():
    if sdl.isGameController(i):
      var controller = sdl.gameControllerOpen(i);
      if (controller != nil):
        echo "We have one!!"
        break
      else:
        echo("Could not open gamecontroller ", i, " ", sdl.getError())
    else:
      echo "Controller number ", i, ", is not connected"

proc update* ()=
  let now = sdl.getTicks().float
  let dt = (now - clock.last ) / 1000.0
  clock.last = now

  clock.dt = dt
  clock.fps = 1 / (if dt == 0.0: 0.016 else: dt)

  clock.timer += dt
  clock.ticks += 1

  if isKeyPressed(Key.BACKQUOTE):
    Debugging = not Debugging

proc windowSize* (): (int, int) =
  var x, y: cint
  sdl.getWindowSize(window, addr x, addr y)
  result = (x.int, y.int)

proc `windowSize=`* (size: (int, int))=
  sdl.setWindowSize(window, size[0].cint, size[1].cint)
