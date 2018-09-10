import
  ../ecs

type
  AiData* = ref object of RootObj
  Ai* = ref object of Component
    data* : AiData

    interactingWith*: Entity
    hot*: bool

    x_last*, x_now*: bool

    onPlayerInteraction*: proc(self: Entity, player: Entity)

    update*: proc(world: World, self: Entity)
    draw*: proc (world: World, self: Entity)
    load*: proc(world: World, self: Entity)

proc loadDef(world: World, self: Entity)= discard
proc updateDef(world: World, self: Entity)= discard
proc drawDef(world: World, self: Entity)= discard

proc newAi* (
  data: AiData,
  load:proc(world: World, self: Entity) = loadDef,
  update:proc(world: World, self: Entity) = updateDef,
  draw:proc(world: World, self: Entity) = drawDef,
  ): auto=
  result = Ai(
    load: load,
    update: update,
    draw: draw,
    data: data,
    x_last: false,
    x_now: false,
    interactingWith: nil,
    hot: false)

