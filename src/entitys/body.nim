import
  Coral/[ecs, gameMath]

type
  Body = ref object of Component
    position*: V2
    size*: V2

proc newBody* (x, y, w, h = 0.0): Body=
  Body(
    position: newV2(x, y),
    size: newV2(w, h)
  )

proc x* (body: Body): auto = body.position.x
proc y* (body: Body): auto = body.position.y
proc width* (body: Body): auto = body.size.x
proc height* (body: Body): auto = body.size.y

proc `x=`* (body: Body, v: float)= body.position.x = v
proc `y=`* (body: Body, v: float)= body.position.y = v
proc `width=`* (body: Body, v: float)= body.size.x = v
proc `height=`* (body: Body, v: float)= body.size.y = v

proc left* (body: Body): auto= body.x
proc right* (body: Body): auto= body.x + body.width
proc top* (body: Body): auto= body.y
proc bottom* (body: Body): auto= body.y + body.height

proc center* (body: Body): V2= body.position + body.size / 2.0
proc centerX* (body: Body): float= body.center.x
proc centerY* (body: Body): float= body.center.y

proc contains* (self, other: Body): bool=
  result =
    self.x + self.width > other.x and self.x < other.x + other.width and
    self.y + self.height > other.y and self.y < other.y + other.height
