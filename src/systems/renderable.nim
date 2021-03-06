import
  ../ecs,
  ../art,
  ../platform,
  ../body,
  ../maths

type
  Drawable* = ref object of Component
    color*: (float, float, float, float)
    offset*: V2
    rotation*: float

  Custom* = ref object of Drawable
    draw*: proc(self: Entity)

  RectangleComponent* = ref object of Drawable

  Frame* = ref object of Region
    time*: float 
    offset*: V2

  Sprite* = ref object of Drawable
    image* : Image
    flip* : bool

    case animated: bool
    of true:
      frames: seq[Frame]
      currentFrame: int
      timer: float
    of false:
      region* : Region

proc newCustom* (draw: proc(self: Entity)): auto=
  result = Custom(draw: draw)

proc newFrame* (x, y, w, h: int, time=0.16, offset=Vec2(0,0)): auto=
  result = Frame(
    pos: Vec2(x.float, y.float),
    size: Vec2(w.float, h.float),
    time: time,
    offset: offset)

proc newRectangleComponent* (): RectangleComponent=
  result = RectangleComponent(
    color: (1.0, 0.0, 0.0, 1.0),
    rotation: 0.0
  )

proc newSprite* (img: Image, reg: Region): Sprite=
  result = Sprite(
    image: img,
    region: reg,
    flip: false,
    offset: Vec2(),
    rotation: 0.0,
    animated: false
  )

proc newAnimatedSprite* (img: Image, frames: seq[Frame], offset=Vec2()): Sprite=
  result = Sprite(
    image: img,

    frames: frames,
    currentFrame: 0,
    timer: 0.0,

    flip: false,
    offset: offset,
    rotation: 0.0,
    animated: true
  )

proc frame(s: Sprite): Frame{.inline.}=
  if s.animated:
    result = s.frames[s.currentFrame]
  else:
    result = nil

EntityWorld.createSystem(
  @["Body", "Custom"],
  load = proc(sys: System, self: Entity)=
    discard
  ,
  draw = proc(s: System, e: Entity)=
    e.get(Custom).draw(e)
  )

#(renderer: sdl.Renderer, x, y, w, h: float, rot=0.0)=
EntityWorld.createSystem(
  @["Body", "RectangleComponent"],
  load = proc(sys: System, self: Entity)=
    discard
  ,
  draw = proc(s: System, e: Entity)=
    let body = e.get(Body)
    let rect = e.get(RectangleComponent)

    R2D.setColor rect.color
    R2D.rect(body.x, body.y, body.width, body.height)
  )

EntityWorld.createSystem(
  @["Body", "Sprite"],
  load = proc(sys: System, self: Entity)=
    discard

  ,update = proc(s: System, e: Entity)=
#    let body    = e.get Body
    let sprite  = e.get Sprite

    if not sprite.animated: return
    
    let frame = sprite.frame
    if sprite.timer >= frame.time:
      inc sprite.currentFrame
      sprite.timer = 0.0

    sprite.timer += GameClock.dt

    sprite.currentFrame = (sprite.currentFrame mod sprite.frames.len)

  ,draw = proc(s: System, e: Entity)=
    let body    = e.get Body
    let sprite  = e.get Sprite

    if sprite.animated == false:
      let img = sprite.image
      let reg = sprite.region
    
      R2D.setColor sprite.color
      R2D.draw(
        img,
        reg,
        sprite.offset.x + body.x,
        sprite.offset.y +  body.y,
        sprite.rotation,
        sprite.flip)

    else:
      let img = sprite.image
      let reg = Region(pos: sprite.frame.pos, size: sprite.frame.size)
    
      R2D.setColor sprite.color
      R2D.draw(
        img,
        reg,
        sprite.offset.x + body.x + sprite.frame.offset.x,
        sprite.offset.y +  body.y + sprite.frame.offset.y,
        sprite.rotation,
        sprite.flip)
  )
