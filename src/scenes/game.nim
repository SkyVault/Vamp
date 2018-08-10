import 
  Coral/[game, ecs],
  ../entitys/[art, body, physics, player]

type 
  GameScene* = ref object of Scene

method load(menu: GameScene)=
  let player = Coral.world.newEntity()
  player.add(newBody(10, 10, 100, 100))
  player.add(newSprite(nil, nil))
