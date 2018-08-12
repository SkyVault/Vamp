import 
    tables,
    ecs,
    body,
    items,
    systems/physics,
    systems/renderable,
    systems/player,
    systems/enemies,
    assets,
    art

const Entities = {
    "Player": proc(x, y: float): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 10, 25))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.get(Image, "player"), newRegion(0, 0, 10, 25)))
        result.add(newPlayer()),

    "Walker": proc(x, y: float): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 26, 21))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.get(Image, "walker_enemy"), newRegion(0, 0, 26, 21)))
        result.add(newEnemy(EnemyType.Walker)),

    "Sword": proc(x, y: float): Entity=
        result = EntityWorld.createEntity()
        result.add(newBody(x, y, 22, 5))
        result.add(newPhysicsBody())
        result.add(newSprite(assets.get(Image, "items"), newRegion(0, 0, 22, 5)))
        result.add(Item()),

}.toTable

proc makeEntity* (which: string, x, y: float): auto {.discardable.}=
    if not Entities.hasKey which:
        echo "Entity: " & which & " does not exist!"
        return

    return Entities[which](x, y)