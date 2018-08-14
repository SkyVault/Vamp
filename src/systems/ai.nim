import 
  ../ecs

type
  Ai* = ref object of Component
    update: proc(world: World, self: Entity)

proc updateDef(world: World, self: Entity)= discard

proc newAi* (update = updateDef): auto=
  result = Ai(update: update)

EntityWorld.createSystem(
  @["Body", "Ai"],

  load=proc(sys: System, self: Entity)=
    discard,

  update=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.update(sys.worldRef, self)
  ,

  draw=proc(sys: System, self: Entity)=
    discard
)
