import 
  Coral/[game, renderer, graphics, gameMath, assets],
  game as gameScene

type 
  MenuScene* = ref object of Scene

method load(menu: MenuScene)=
  echo "Here in the menu!"

method update(menu: MenuScene)=
  if Coral.isKeyPressed(Key.Enter):
    Coral.gotoScene GameScene()

method draw(menu: MenuScene)=
  let arial = Coral.assets.getFont("arial")
  Coral.r2d.drawString(arial, "Menu", newV2(0, 0))
