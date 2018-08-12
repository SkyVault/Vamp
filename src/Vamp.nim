import
  Coral/[game, renderer, graphics, gameMath, assets],
  scenes/[menu, level],
  opengl

var camera = newCamera2D(0, 0)

Coral.load = proc() =
  var arial = loadFont("assets/fonts/arial.ttf", 64)
  var entities = loadImage("assets/images/Entities.png", GL_NEAREST)

  camera.offset = newV2(
    float(Coral.windowSize[0]) * 0.5,
    float(Coral.windowSize[1]) * 0.5)

  Coral.assets.add("arial", arial)
  Coral.assets.add("entities", entities)

  Coral.gotoScene LevelScene(cameraRef: camera)

Coral.draw = proc =
  Coral.r2d.view = camera

Coral.newGame(1280, 720, "Hello").run()
