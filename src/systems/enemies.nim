import
  ../ecs,
  ../art,
  ../platform,
  ../body,
  renderable,
  physics,
  random,
  ../input,
  ../maths

type
  EnemyType* {.pure.} = enum
    Walker,
    Zombie

  Enemy* = ref object of Component
    enemyType*: EnemyType

proc newEnemy* (enemyType: EnemyType): Enemy=
  Enemy(
    enemyType: enemyType
  )

# WALKER AI
proc WalkerUpdate(self: Entity)=
  let body = self.get Body
  let phys = self.get PhysicsBody
  let sprite = self.get Sprite
  let o = placeMeeting(Vec2(body.x - 4, body.y + body.height / 2.0))
  let o2 = placeMeeting(Vec2(body.x + body.width + 4, body.y + body.height / 2.0))
  
  if o != nil or o2 != nil:
    phys.velocity.x *= -1

  sprite.flip = if phys.velocity.x < 0: false else: true

proc WalkerPhysicsObject(self: Entity, obj: PhysicsObject)=
  discard

# ZOMBIE AI
proc ZombieUpdate(self: Entity)=
  discard

let EnemyController = EntityWorld.createSystem(
  @["Body", "PhysicsBody", "Enemy"],

  load = proc(sys: System, self: Entity)=
    case self.get(Enemy).enemyType:
    of EnemyType.Walker:
      let dir = (if random(1.0) > 0.55: 1 else: -1).float

      let physc = self.get PhysicsBody
      physc.friction = 1.0
      physc.velocity.x = 25.0 * dir

    else: discard

    self.get(PhysicsBody).solidsCollisionCallback = proc(o: PhysicsObject)=
      case self.get(Enemy).enemyType:
      of EnemyType.Walker: WalkerPhysicsObject(self, o)
      else: discard
  ,

  update = proc(sys: System, self: Entity)=
    let enemy = self.get Enemy
    
    case enemy.enemyType:
    of EnemyType.Walker: WalkerUpdate self
    else: discard
)
