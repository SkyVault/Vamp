import 
    tables,
    ecs,
    maths,
    math,
    body,
    items,
    platform,
    nim_tiled,
    strformat,
    systems/[physics, ai, renderable, enemies, player],
    assets,
    art

const Entities = {
    "Player": proc(x, y: float, w, h = 0.0): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 12, 27))
        result.add(newPhysicsBody())

        result.add(newAnimatedSprite(assets.getImage("player"), @[
          newFrame(0, 0, 32, 32),
          newFrame(32, 0, 32, 32),
          newFrame(64, 0, 32, 32),
          newFrame(96, 0, 32, 32),
          newFrame(128, 0, 32, 32),
          newFrame(160, 0, 32, 32),
        ],
        Vec2(-10, -4)))

        result.add(newPlayer()),

    "Walker": proc(x, y: float, w, h = 0.0): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 26, 21))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.getImage("walker_enemy"), newRegion(0, 0, 26, 21)))
        result.add(newEnemy(EnemyType.Walker)),

    "Sword": proc(x, y: float, w, h = 0.0): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 22, 5))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.getImage("items"), newRegion(0, 0, 22, 5)))
        result.add(Item()),

    "WiseOldWoman": proc(x, y: float, w, h = 0.0): Entity=
        var img = R2D.loadImage("assets/images/old_lady.png")
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 18, 27))
        result.add(newPhysicsBody())
        result.add(newSprite(img, newRegion(8, 5, 18, 27)))
        result.add(newAi(oldLadyAi))

        var sprite = result.get Sprite
        sprite.color = (1.0, 0.0, 0.0, 1.0)

}.toTable

proc makeWater* (x, y, w, h: float): auto {.discardable.}=
  result = EntityWorld.createEntity()
  result.add(newBody(x, y, w, h))

  var offset = 0.0

  result.add(newCustom(
    proc(self: Entity)=
      let body = self.get(Body)
      let image = assets.getImage "entities"

#      offset = math.sin(GameClock.timer * 2.0) * 2.0

      let num = (body.width.int div 16)
      let reg = newRegion(0, 496, 16, 16)

      for i in 0..num:
        let offset2 = math.cos(i.float + GameClock.timer) * 1.2
        R2D.draw(
          image,
          reg,
          (body.x.int + (i * 16)).float,
          body.y + offset - offset2,
          0.0,
          false)

      R2D.setColor (99.0 / 255.0, 155.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0)
      R2D.rect(body.x, body.y + 8 + offset, body.width, body.height - 16)
  ))

proc makeEntity* (which: string, x, y: float, w, h = 0.0): auto {.discardable.}=
    if not Entities.hasKey which:
        echo "Entity: " & which & " does not exist!"
        return

    return Entities[which](x, y, w, h)

proc makeEntitiesFromTiled* (total: seq[TiledObject])=
  for entity in total:

    if Entities.hasKey(entity.objectType):
      makeEntity(entity.objectType, entity.x, entity.y, entity.width, entity.height)
    else:
      case entity.objectType:
      of "Water": makeWater(entity.x, entity.y, entity.width, entity.height)
      of "", "Kill", "Spawn", "Ladder": discard
      else:
        echo fmt"Unknown entity type {entity.objectType}"
