import 
  Coral/[game]

type 
  GameScene* = ref object of Scene

method load(menu: GameScene)=
  echo "Here in the game!"
