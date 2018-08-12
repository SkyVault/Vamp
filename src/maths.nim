type
  V2* = ref object
    x*, y*: float

proc Vec2* (x = 0.0, y = 0.0): V2=
  result = V2(x: x, y: y)

proc `+`* (a, b: V2): V2= return Vec2(a.x + b.x, a.y + b.y)
proc `-`* (a, b: V2): V2= return Vec2(a.x - b.x, a.y - b.y)
proc `*`* (a, b: V2): V2= return Vec2(a.x * b.x, a.y * b.y)
proc `/`* (a, b: V2): V2= return Vec2(a.x / b.x, a.y / b.y)
proc `+`* (a: V2, b: float): V2= return Vec2(a.x + b, a.y + b)
proc `-`* (a: V2, b: float): V2= return Vec2(a.x - b, a.y - b)
proc `*`* (a: V2, b: float): V2= return Vec2(a.x * b, a.y * b)
proc `/`* (a: V2, b: float): V2= return Vec2(a.x / b, a.y / b)

proc `+=`* (a, b: V2)= a.x += b.x; a.y += b.y
proc `-=`* (a, b: V2)= a.x -= b.x; a.y -= b.y
proc `*=`* (a, b: V2)= a.x *= b.x; a.y *= b.y
proc `/=`* (a, b: V2)= a.x /= b.x; a.y /= b.y
proc `+=`* (a: V2, b: float)= a.x += b; a.y += b
proc `-=`* (a: V2, b: float)= a.x -= b; a.y -= b
proc `*=`* (a: V2, b: float)= a.x *= b; a.y *= b
proc `/=`* (a: V2, b: float)= a.x /= b; a.y /= b

proc `+`* (a: V2, b: (float, float)): V2= return Vec2(a.x + b[0], a.y + b[1])
proc `-`* (a: V2, b: (float, float)): V2= return Vec2(a.x - b[0], a.y - b[1])
proc `*`* (a: V2, b: (float, float)): V2= return Vec2(a.x * b[0], a.y * b[1])
proc `/`* (a: V2, b: (float, float)): V2= return Vec2(a.x / b[0], a.y / b[1])

proc `+=`* (a: V2, b: (float, float))= a.x += b[0]; a.y += b[1]
proc `-=`* (a: V2, b: (float, float))= a.x -= b[0]; a.y -= b[1]
proc `*=`* (a: V2, b: (float, float))= a.x *= b[0]; a.y *= b[1]
proc `/=`* (a: V2, b: (float, float))= a.x /= b[0]; a.y /= b[1]

# Tuple of 2 floats * float
proc `+`* (a: (float, float), b: float): V2= return Vec2(a[0] + b, a[1] + b)
proc `-`* (a: (float, float), b: float): V2= return Vec2(a[0] - b, a[1] - b)
proc `*`* (a: (float, float), b: float): V2= return Vec2(a[0] * b, a[1] * b)
proc `/`* (a: (float, float), b: float): V2= return Vec2(a[0] / b, a[1] / b)
