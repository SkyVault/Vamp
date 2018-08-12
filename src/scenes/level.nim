import 
  Coral/[game, ecs, assets, graphics, renderer, gameMath],
  ../entitys/[art, body, physics, player]

type 
  LevelScene* = ref object of Scene
    cameraRef* : Camera2D

method load(level: LevelScene)=
  let player = Coral.world.newEntity()

  var entities = Coral.assets.getImage "entities"
  player.add(newBody(0, 0, 16, 32))
  player.add(newSprite(entities, newRegion(0, 0, 16, 32)))
  player.add(newPlayer(level.cameraRef))

  let (x, y) = Coral.windowSize
  #let winV2 = newV2(x, y)

  level.cameraRef.zoom = 8
  level.cameraRef.position = (player.get(Body).position * -1) + player.get(Body).size * 0.5
  echo level.cameraRef.offset
