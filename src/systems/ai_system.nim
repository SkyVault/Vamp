import 
  ../ecs,
  ../assets,
  ../body,
  ../maths,
  ../art,
  ../dialog,
  ../platform,
  ../input,
  ai,
  json

type
  WiseOldWoman* = ref object of AiData
    showingActionBox* : bool

proc oldLadyAiLoad* (world: World, this: Entity)=
  this.get(Ai).onPlayerInteraction = proc(self, player: Entity)=
    let body = self.get(Body)
    showDialog(assets.getJson("sample")["OldLady"], body.position, self, player)

proc oldLadyAiUpdate* (world: World, self: Entity)=
  discard
      
proc oldLadyAiDraw* (world: World, self: Entity)=
  discard

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

    if ai.hot == false:
      ai.interactingWith = nil

    ai.hot = false
    if contains(body, player_body):
      ai.hot = true
      if isKeyPressed(Key.Space):
        if ai.onPlayerInteraction != nil:
          ai.onPlayerInteraction(self, player)
        ai.interactingWith = player

    ai.update(sys.worldRef, self)
  ,

  draw=proc(sys: System, self: Entity)=
    let ai = self.get Ai
    ai.draw(sys.worldRef, self)
    if ai.hot:
      let body = self.get Body
      R2D.setColor (1.0, 1.0, 1.0, 1.0)
      R2D.rect(body.x, body.y - 16, 16, 12)
)
