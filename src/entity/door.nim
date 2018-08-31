import
  ../ecs,
  ../art,
  ../platform,
  ../body,
  ../input,
  ../systems/player,
  ../systems/physics,
  ../maths

type 
  Door* = ref object of Component
    toPath* , id*: string
    pushTheRoom*: bool
    popTheRoom*: bool

EntityWorld.createSystem(
  @["Body", "Door"],

  load = proc(sys: System, self: Entity)=
    self.get(PhysicsBody).solidsCollisionCallback = proc(o: PhysicsObject)=
      discard

  ,
  update = proc(sys: System, self: Entity)=
    let phys = self.get PhysicsBody

    for other in phys.collisions:
      if other.has Player:
        if isKeyPressed(Key.UP):
          var door = self.get(Door)
          if door.toPath == "-1":
            door.popTheRoom = true
          else:
            door.pushTheRoom = true
)
