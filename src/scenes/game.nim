import
  ../scenery,
  ../assets,
  ../platform,
  ../art,
  ../world,
  ../entity_assembler

type
  GameScene* = ref object of Scene
    bg: Image
    gameWorld*: GameWorld

method event* (self: GameScene, state: SceneState)=
  case state:
  of LoadScene:

    self.bg = R2D.loadImage "assets/images/day_background_1.png"
    makeEntity("Player", 200, 400)
    self.gameWorld.pushRoom("assets/maps/map_1.tmx", false);

  of UpdateScene:
    discard

  of RenderScene:

    let (ww, wh) = platform.windowSize()
    R2D.drawUnprojected(self.bg, 0, 0, ww.float, wh.float)

  else: discard
