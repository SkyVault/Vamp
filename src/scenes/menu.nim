import
  ../scenery,
  ../assets,
  ../platform,
  ../art,
  ../input,
  game,
  ../world

type
  MenuScene* = ref object of Scene
    gameWorld* : GameWorld

method event* (self: MenuScene, state: SceneState)=
  case state:
  of LoadScene:
    discard
  of UpdateScene:

    if isKeyPressed(Key.Return):
      Scenery.push(GameScene(gameWorld: self.gameWorld))

  of RenderScene:
    MainCamera.unProject:
      let font = assets.getFont "minecraft"
      R2D.drawString(font, "hello world", 0, 0)

  else: discard
