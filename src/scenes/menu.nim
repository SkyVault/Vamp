import 
  Coral/[game, renderer, graphics, gameMath, assets],
  level

type 
  MenuScene* = ref object of Scene
    cameraRef* : Camera2D

method load(menu: MenuScene)=
  echo "Here in the menu!"

method update(menu: MenuScene)=
  if Coral.isKeyPressed(Key.Enter):
    Coral.gotoScene LevelScene(cameraRef: menu.cameraRef)

method draw(menu: MenuScene)=
  let arial = Coral.assets.getFont("arial")
  Coral.r2d.drawString(arial, "Menu", newV2(0, 0))
