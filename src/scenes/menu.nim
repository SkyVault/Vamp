import
  ../scenery,
  ../assets,
  ../platform,
  ../art,
  ../input,
  ../world,
  sdl2/sdl_ttf as ttf,
  game

type
  MenuScene* = ref object of Scene
    gameWorld* : GameWorld

method event* (self: MenuScene, state: SceneState)=
  case state:
  of LoadScene: discard

  of UpdateScene:

    if isKeyPressed(Key.Return):
      Scenery.push(GameScene(gameWorld: self.gameWorld))

  of RenderScene:
    MainCamera.unProject:
      let font = assets.getFont "minecraft"
      let (ww, wh) = windowSize()

      const msg = "Press Enter"
      const scale = 5.0 

      var w, h: cint
      discard ttf.sizeText(font, msg.cstring, addr w, addr h)

      let xpos = (ww.float / 2.0) - ((w.float * scale) / 2.0)
      let ypos = (wh.float / 2.0) - ((h.float * scale) / 2.0)

      R2D.drawString(font, msg, xpos, ypos, scale=5.0)

  else: discard
