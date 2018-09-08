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

    interactingWith*: Entity
    onPlayerInteraction*: proc(self: Entity, player: Entity)

    update: proc(world: World, self: Entity)
    draw: proc (world: World, self: Entity)
    load: proc(world: World, self: Entity)

  WiseOldWoman* = ref object of AiData
    showingActionBox* : bool

proc loadDef(world: World, self: Entity)= discard
proc updateDef(world: World, self: Entity)= discard
proc drawDef(world: World, self: Entity)= discard

proc oldLadyAiLoad* (world: World, this: Entity)=
  this.get(Ai).onPlayerInteraction = proc(self, player: Entity)=
    let body = self.get(Body)
    showDialog(assets.getJson("sample")["OldLady"], body.position)

proc oldLadyAiUpdate* (world: World, self: Entity)=
  discard
  #let players = getAllThatMatch(@["Player"])
  #if players.len == 0: return

  #let player = players[0]
  #let player_body = player.get Body

  #let body = self.get Body
  #var ai = self.get(Ai)
  
  #(ai.data.WiseOldWoman).showingActionBox = false

  #if contains(body, player_body):
    #(ai.data.WiseOldWoman).showingActionBox = true
    #if isKeyPressed(Key.Space):
      
proc oldLadyAiDraw* (world: World, self: Entity)=
  if (self.get(Ai).data.WiseOldWoman).showingActionBox:
    let body = self.get Body
    R2D.setColor (1.0, 1.0, 1.0, 1.0)
    R2D.rect(body.x, body.y - 16, 16, 12)

proc newAi* (
  data: AiData,
  load:proc(world: World, self: Entity) = loadDef,
  update:proc(world: World, self: Entity) = updateDef,
  draw:proc(world: World, self: Entity) = drawDef,
  ): auto=
  result = Ai(load: load, update: update, draw: draw, data: data, interactingWith: nil)

EntityWorld.createSystem(
  @["Body", "Ai"],

  load=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.load(sys.worldRef, self)
  ,

  update=proc(sys: System, self: Entity)=
    let ai = self.get Ai

    let players = getAllThatMatch(@["Player"])
    if players.len == 0: return

    let player = players[0]
    let player_body = player.get Body

    let body = self.get Body
    
    #(ai.data.WiseOldWoman).showingActionBox = false

    if contains(body, player_body):
      #(ai.data.WiseOldWoman).showingActionBox = true
      if isKeyPressed(Key.Space):
        if ai.onPlayerInteraction != nil:
          ai.onPlayerInteraction(self, player)
        #showDialog(assets.getJson("sample")["OldLady"], body.position)

    ai.update(sys.worldRef, self)
  ,

  draw=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.draw(sys.worldRef, self)
    
)
