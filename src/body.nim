import
  ecs,
  maths

type
  Body* = ref object of Component
    position*, size*: V2

proc newBody* (x, y, w, h: float): Body=
  result = Body(
    position: Vec2(x, y),
    size: Vec2(w, h)
  )

proc x* (b: Body): float= b.position.x
proc `x=`* (b: Body, v: float) = b.position.x = v

proc y* (b: Body): float= b.position.y
proc `y=`* (b: Body, v: float) = b.position.y = v

proc width* (b: Body): float= b.size.x
proc `width=`* (b: Body, v: float) = b.size.x = v

proc height* (b: Body): float= b.size.y
proc `height=`* (b: Body, v: float) = b.size.y = v

proc center* (b: Body): V2= Vec2(b.x + b.width / 2, b.y + b.height / 2)

proc `$`* (o: Body): string=
  result = "Body { x: " & $o.x & ", y: " & $o.y & ", w: " & $o.width & ", h: " & $o.height & "}"

proc contains* (body, other: Body): bool =
  return body.x + body.width > other.x and 
         body.x < other.x + other.width and
         body.y + body.height > other.y and 
         body.y < other.y + other.height

proc contains* (body: Body, other: V2): bool =
  return other.x > body.x and other.x < body.x + body.width and
         other.y > body.y and other.y < body.y + body.height
