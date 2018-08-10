import
  Coral/[ecs, gameMath, renderer, graphics, game],
  body

type
  Sprite* = ref object of Component
    image*: Image
    region*: Region

proc newSprite* (image: Image, region: Region): auto=
  result = Sprite(image: image, region: region)

Coral.world.newSystem(
  @["Body", "Sprite"],

  load = proc(self: System, e: Entity)=
    echo "here"
)
