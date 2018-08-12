import
  ../ecs,
  ../platform.nim,
  ../maths,
  ../art,
  ../body,
  ../tiled,
  math

type
  PhysicsType* {.pure.} = enum
    Static,
    Dynamic,
    Sensor,
    Ladder

  PhysicsObject* = ref object of Body
    physicsType*: PhysicsType

  PhysicsBody* = ref object of Component
    velocity*: V2
    friction*: float
    isOnGround*: bool
    isOnLadder*: bool
    gravity_scale*: float
    physicsType*: PhysicsType
    collisions*: seq[Entity]
    solidsCollisionCallback*: proc(solid: PhysicsObject)

const GRAVITY = (0.0, 600.0)

proc newPhysicsObject* (x, y, w, h: float, typeName: string): PhysicsObject=
  result = PhysicsObject(
    physicsType: PhysicsType.Static,
    position: Vec2(x, y),
    size: Vec2(w, h)
  )

  case typeName:
  of "Ladder":
    result.physicsType = PhysicsType.Ladder
  else: discard

proc newPhysicsBody* (vx = 0.0, vy = 0.0): PhysicsBody=
  result = PhysicsBody(
    velocity: Vec2(vx, vy),
    friction: 0.02,
    gravity_scale: 1.0,
    isOnGround: false,
    isOnLadder: false,
    physicsType: PhysicsType.Dynamic,
    collisions: newSeq[Entity](),
    solidsCollisionCallback: proc(solid: PhysicsObject)= discard
  )

var tiledObjects    = newSeq[PhysicsObject]()
var physicsEntities = newSeq[Entity]()

proc SetTiledObjects* (objs: seq[TiledObject])=
  for o in objs:
    tiledObjects.add(newPhysicsObject(
      o.x, o.y, o.width, o.height,
      o.typeName
    ))

proc placeMeeting* (point: V2): PhysicsObject=
  result = nil

  for o in tiledObjects:
    if o.contains(point): return o

var PhysicsSystem = EntityWorld.createSystem(
  @["Body", "PhysicsBody"],

  draw = proc(sys: System, self: Entity)=
    if platform.Debugging == false: return

    var body = self.get Body
    var phys = self.get PhysicsBody

    let color = if phys.collisions.len == 0:
                  (0.0, 1.0, 0.0, 1.0)
                else:
                  (1.0, 0.0, 0.0, 1.0)

    R2D.setColor(color)
    R2D.lineRect(body.x, body.y, body.width, body.height)
    R2D.setColor((1.0, 1.0, 1.0, 1.0))
  ,

  preUpdate = proc(sys: System)=
    physicsEntities = getAllThatMatch(@["PhysicsBody"])
  ,

  update = proc(sys: System, self: Entity)=
    var body = self.get Body
    var phys = self.get PhysicsBody

    var scaled_y_gravity = GRAVITY[1] * phys.gravity_scale
    scaled_y_gravity *= (if phys.velocity.y > 0: 2.0 else: 1.0)

    if not phys.isOnLadder:
      phys.velocity.y += scaled_y_gravity * GameClock.dt
     
    var xbody = newBody(body.x + phys.velocity.x * GameClock.dt, body.y, body.width, body.height)
    var ybody = newBody(body.x, body.y + phys.velocity.y * GameClock.dt, body.width, body.height)

    phys.isOnGround = false
    phys.isOnLadder = false

    for o in tiledObjects:
      var collided = false
      if o.contains(xbody) and o.physicsType != PhysicsType.Ladder:
        collided = true
        xbody = body
      
      if o.contains(ybody):
        collided = true
        phys.isOnGround = true
        phys.velocity.y = 0

        if o.physicsType == PhysicsType.Ladder:
          phys.isOnLadder = true
        else:
          ybody.y = o.y - ybody.height
      
      if collided:
        phys.solidsCollisionCallback(o)

    phys.collisions.setLen(0)
    for e in physicsEntities:
      if e == self: continue
      let ebod = e.get Body
      if ebod.contains(body):
        phys.collisions.add(e)

    phys.velocity *= math.pow(phys.friction, GameClock.dt)

    body.position = Vec2(xbody.x, ybody.y)
  ,
  preDraw = proc(s: System)=
    for o in tiledObjects:
      R2D.lineRect(o.x, o.y, o.width, o.height)
  )

