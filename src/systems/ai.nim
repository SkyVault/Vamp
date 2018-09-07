import 
  ../ecs,
  ../assets,
  ../body,
  ../maths,
  ../art,
  ../dialog,
  ../platform,
  ../input,
  json

type
  AiData = ref object of RootObj
  Ai* = ref object of Component
    data* : AiData

    update: proc(world: World, self: Entity)
    draw: proc (world: World, self: Entity)

  WiseOldWoman* = ref object of AiData
    showingActionBox* : bool

proc updateDef(world: World, self: Entity)= discard
proc drawDef(world: World, self: Entity)= discard

proc oldLadyAiUpdate* (world: World, self: Entity)=
  let players = getAllThatMatch(@["Player"])
  if players.len == 0: return

  let player = players[0]
  let player_body = player.get Body

  let body = self.get Body
  var ai = self.get(Ai)
  
  (ai.data.WiseOldWoman).showingActionBox = false

  if contains(body, player_body):
    (ai.data.WiseOldWoman).showingActionBox = true
    
    if isKeyPressed(Key.Space):
      showDialog(assets.getJson("sample")["OldLady"], body.position)
      
proc oldLadyAiDraw* (world: World, self: Entity)=
  if (self.get(Ai).data.WiseOldWoman).showingActionBox:
    let body = self.get Body
    R2D.setColor (1.0, 1.0, 1.0, 1.0)
    R2D.rect(body.x, body.y - 16, 16, 12)

proc newAi* (
  data: AiData,
  update:proc(world: World, self: Entity) = updateDef,
  draw:proc(world: World, self: Entity) = drawDef,
  ): auto=
  result = Ai(update: update, draw: draw, data: data)

EntityWorld.createSystem(
  @["Body", "Ai"],

  load=proc(sys: System, self: Entity)=
    discard,

  update=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.update(sys.worldRef, self)
  ,

  draw=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.draw(sys.worldRef, self)
    
)
