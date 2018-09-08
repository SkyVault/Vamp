import
  tables,
  math,
  ecs,
  body,
  assets,
  art,
  platform,
  systems/renderable,
  systems/enemies,
  systems/physics

type
  ItemType* = enum
    Weapon,
    Food
    
  ItemID* {.pure.} = enum
    None,
    QuestCoin

type
  Item* = ref object of Component
    itemType* : ItemType
    itemID* : ItemID

EntityWorld.createSystem(
  @["Item", "Sprite", "Body"],
  load = proc(sys: System, self: Entity)=
    discard
  ,

  update = proc(sys: System, self: Entity)=
    let sprite = self.get Sprite
    let body = self.get Body

    const speed = 8

    let height = body.height * 0.5
    let y = height
    sprite.offset.y = -y + math.cos(GameClock.timer * speed) * height
    sprite.rotation = math.cos(GameClock.timer * speed * 0.25) * 10
)
