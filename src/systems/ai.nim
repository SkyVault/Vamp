import 
  ../ecs,
  ../assets,
  ../body,
  ../maths,
  ../art,
  ../dialog,
  ../platform,
  json

type
  Ai* = ref object of Component
    update: proc(world: World, self: Entity)

proc updateDef(world: World, self: Entity)= discard

proc oldLadyAi* (world: World, self: Entity)=
  let players = getAllThatMatch(@["Player"])
  if players.len == 0: return

  let player = players[0]
  let player_body = player.get Body

  let body = self.get Body
  
  #let dist = distance(player_body.position, body.position)
  #echo dist
  
  if contains(body, player_body):
    R2D.setColor (1.0, 1.0, 1.0, 1.0)
    R2D.rect(body.x, body.y - 16, 16, 12)

    #platform.Pause()
    showDialog(assets.getJson("sample")["OldLady"], body.position)

proc newAi* (update:proc(world: World, self: Entity) = updateDef): auto=
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
