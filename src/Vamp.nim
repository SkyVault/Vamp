import
  Coral/[game, renderer, graphics, gameMath, assets],
  scenes/menu

Coral.load = proc() =
  var arial = loadFont("assets/fonts/arial.ttf", 64)
  Coral.assets.add("arial", arial)

  Coral.gotoScene MenuScene()

Coral.newGame(1280, 720, "Hello").run()
