import
  ../ecs, ../art,
  ../platform,
  ../body,
  ../items,
  renderable,
  physics,
  ../input,
  ../maths

type
  Player* = ref object of Component
    invatory*: seq[Entity]
    respawn: V2

proc newPlayer* (): Player=
  result = Player(
    invatory: newSeq[Entity]()
  )

const SPEED = 300.0

#(renderer: sdl.Renderer, x, y, w, h: float, rot=0.0)=
EntityWorld.createSystem(
  @["Body", "Player", "PhysicsBody", "Sprite"],
  load = proc(sys: System, self: Entity)=
    var phys = self.get PhysicsBody
    var body = self.get Body
    var player = self.get Player
    self.get(Player).respawn = body.position
    
    phys.solidsCollisionCallback = proc(o: PhysicsObject)=
      case o.physicsType:
      of PhysicsType.Spawn:
        player.respawn = Vec2(o.position.x, body.y)
      of PhysicsType.Kill:
        self.get(Body).position = player.respawn
      else: discard
  ,
  update = proc(s: System, self: Entity)=
    let body = self.get Body
    let phys = self.get PhysicsBody
    let sprite = self.get Sprite
    let player = self.get Player

    if isKeyDown(Key.LEFT):
      phys.velocity.x -= SPEED * GameClock.dt
      sprite.flip = true

    if isKeyDown(Key.RIGHT):
      phys.velocity.x += SPEED * GameClock.dt
      sprite.flip = false

    if phys.isOnLadder and isKeyDown(Key.DOWN):
      phys.velocity.y += SPEED * GameClock.dt * 15

    if phys.isOnLadder and isKeyDown(Key.UP):
      phys.velocity.y -= SPEED * GameClock.dt * 15

    if isKeyDown(Key.z) and phys.isOnGround and not phys.isOnLadder:
      phys.velocity.y -= 300.0

    var camera = MainCamera()

    let (ww, hh) = platform.windowSize()
    let w = (ww.float) / camera.zoom
    let h = (hh.float) / camera.zoom

    let x = body.x + phys.velocity.x * 0.5
    let y = body.y

    let dx = ((camera.x + w * 0.5) - x)
    let dy = ((camera.y + h * 0.5) - y)
    
    camera.position.x -= dx * 0.1
    camera.position.y -= dy * 0.1

    # Handle collisions with other entities
    for other in phys.collisions:
      if other.has Item:
        player.invatory.add(other)
        other.kill()
  ,

  draw = proc(s: System, self: Entity)=
    discard
  ,
  )
