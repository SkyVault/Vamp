import
  maths,
  body,

  sdl2/sdl, sdl2/sdl_image as img,
  sdl2/sdl_gfx_primitives as gfx,
  sdl2/sdl_gfx_primitives_font as font

type
  Region* = ref object of RootObj
    pos*, size*: V2

  Camera* = ref object of Body
    zoom*, rotation*: float

  Image* = ref ImageObj
  ImageObj = object of RootObj
    texture: sdl.Texture # Image texture
    w, h: int # Image dimensions

var current_color = (1.0, 1.0, 1.0, 1.0)

proc newRegion* (x, y, w, h: float): Region=
  result = Region(
    pos: Vec2(x, y),
    size: Vec2(w, h)
  )

var
  camera = Camera(
    position: Vec2(), size: Vec2(),
    zoom: 1, rotation: 0
  )

template MainCamera* (): Camera= camera

proc sdlRect(r: Region): sdl.Rect=
  return sdl.Rect(
    x: (int)r.pos.x,
    y: (int)r.pos.y,
    w: (int)r.size.x,
    h: (int)r.size.y,
  )

# Image
proc newImage* (): Image = Image(texture: nil, w: 0, h: 0)
proc free* (obj: Image) = sdl.destroyTexture(obj.texture)
proc w* (obj: Image): int {.inline.} = return obj.w
proc h* (obj: Image): int {.inline.} = return obj.h

# Load image from file
# Return true on success or false, if image can't be loaded
proc load* (obj: Image, renderer: sdl.Renderer, file: string): bool {.discardable.} =
  result = true
  # Load image to texture
  obj.texture = renderer.loadTexture(file)
  if obj.texture == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load image %s: %s",
                    file, img.getError())
    return false
  # Get image dimensions
  var w, h: cint
  if obj.texture.queryTexture(nil, nil, addr(w), addr(h)) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't get texture attributes: %s",
                    sdl.getError())
    sdl.destroyTexture(obj.texture)
    return false
  obj.w = w
  obj.h = h

proc loadImage* (renderer: Renderer, path: string): Image=
  result = newImage()
  result.load(renderer, path)

# blend
proc blend(obj: Image): sdl.BlendMode =
  var blend: sdl.BlendMode
  if obj.texture.getTextureBlendMode(addr(blend)) == 0:
    return blend
  else:
    return sdl.BlendModeBlend

proc `blend=`(obj: Image, mode: sdl.BlendMode) {.inline.} =
  discard obj.texture.setTextureBlendMode(mode)

# alpha
proc alpha(obj: Image): int =
  var alpha: uint8
  if obj.texture.getTextureAlphaMod(addr(alpha)) == 0:
    return alpha
  else:
    return 255

proc `alpha=`(obj: Image, alpha: int) =
  discard obj.texture.setTextureAlphaMod(alpha.uint8)

proc setColor* (renderer: sdl.Renderer, c: (float, float,float,float))=
  current_color = c

proc draw* (renderer: sdl.Renderer, obj: Image, x, y: float, rot = 0.0, flip = false, ox = -1, oy = -1): bool {.discardable.}=
  var dx = (x - camera.position.x) * camera.zoom
  var dy = (y - camera.position.y) * camera.zoom
  var dw = obj.w.float * camera.zoom
  var dh = obj.h.float * camera.zoom
  var rect = sdl.Rect(x: (int)dx, y: (int)dy, w: dw.int, h: dh.int)
  var pnt = sdl.Point(x: (int)ox, y: (int)oy)
  if renderer.renderCopyEx(
    obj.texture,
    nil,
    addr(rect),
    rot,
    if ox < 0 or oy < 0: nil else: addr(pnt),
    sdl.FLIP_NONE) == 0:
    return true
  else:
    return false

proc draw* (renderer: sdl.Renderer, obj: Image, reg: Region, x, y: float, rot = 0.0, flip = false, ox = -1, oy = -1): bool {.discardable.}=
  var dx = (x - camera.position.x) * camera.zoom
  var dy = (y - camera.position.y) * camera.zoom
  var dw = reg.size.x * camera.zoom
  var dh = reg.size.y * camera.zoom
  var rect = sdl.Rect(x: (int)dx, y: (int)dy, w: dw.int, h: dh.int)
  var sreg = reg.sdlRect
  var pnt = sdl.Point(x: (int)ox, y: (int)oy)

  if renderer.renderCopyEx(
    obj.texture,
    addr(sreg),
    addr(rect),
    rot,
    if ox < 0 or oy < 0: nil else: addr(pnt),
    (if flip: sdl.FLIP_HORIZONTAL else: sdl.FLIP_NONE)) == 0:
    return true
  else:
    return false

proc rect*(renderer: sdl.Renderer, x, y, w, h: float, rot=0.0)=
  var xx = (x - camera.position.x) * camera.zoom
  var yy = (y - camera.position.y) * camera.zoom
  discard renderer.boxRGBA(
    xx.int16, yy.int16,
    (xx + (w * camera.zoom)).int16,
    (yy + (h * camera.zoom)).int16,
    (current_color[0] * 255).uint8,
    (current_color[1] * 255).uint8,
    (current_color[2] * 255).uint8,
    (current_color[3] * 255).uint8,
  )
  
proc lineRect*(renderer: sdl.Renderer, x, y, w, h: float, rot=0.0)=
  var xx = (x - camera.position.x) * camera.zoom
  var yy = (y - camera.position.y) * camera.zoom
  discard renderer.rectangleRGBA(
    xx.int16, yy.int16,
    (xx + (w * camera.zoom)).int16,
    (yy + (h * camera.zoom)).int16,
    (current_color[0] * 255).uint8,
    (current_color[1] * 255).uint8,
    (current_color[2] * 255).uint8,
    (current_color[3] * 255).uint8,
  )
