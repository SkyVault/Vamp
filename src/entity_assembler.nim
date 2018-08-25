import 
    tables,
    ecs,
    maths,
    body,
    items,
    platform,
    systems/[physics, ai, renderable, enemies, player],
    assets,
    art

const Entities = {
    "Player": proc(x, y: float): Entity=
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

    "Walker": proc(x, y: float): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 26, 21))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.getImage("walker_enemy"), newRegion(0, 0, 26, 21)))
        result.add(newEnemy(EnemyType.Walker)),

    "Sword": proc(x, y: float): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 22, 5))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.getImage("items"), newRegion(0, 0, 22, 5)))
        result.add(Item()),

    "WiseOldWoman": proc(x, y: float): Entity=
        var img = R2D.loadImage("assets/images/old_lady.png")
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 18, 27))
        result.add(newPhysicsBody())
        result.add(newSprite(img, newRegion(8, 5, 18, 27)))
        result.add(newAi(oldLadyAi))

        var sprite = result.get Sprite
        sprite.color = (1.0, 0.0, 0.0, 1.0)

}.toTable

proc makeEntity* (which: string, x, y: float): auto {.discardable.}=
    if not Entities.hasKey which:
        echo "Entity: " & which & " does not exist!"
        return

    return Entities[which](x, y)
