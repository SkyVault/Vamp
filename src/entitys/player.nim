import
  Coral/[game, ecs, graphics]

type
  Player* = ref object of Component
    cameraRef: Camera2D

proc newPlayer* (cameraRef: Camera2D): auto =
  Player(cameraRef: cameraRef)

Coral.world.newSystem(
  @["Body", "Player"],

  load = proc(self: System, e: Entity)=
    echo "here"
  ,
  update = proc(self: System, e: Entity)=
    discard
)
