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
  ,
  draw = proc(self: System, e: Entity)=
    let sprite = e.get Sprite
    let body = e.get Body

    Coral.r2d.drawSprite(
      sprite.image,
      sprite.region,
      body.position,
      body.size * 10.0,
      0.0,
      newColor()
    )

)
