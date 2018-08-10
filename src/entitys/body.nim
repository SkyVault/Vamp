import
  Coral/[ecs, gameMath]

type
  Body = ref object of Component
    position*: V2
    size*: V2

proc x* (body: Body): auto = x.position.x
