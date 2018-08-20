import
  maths,
  body,

  sequtils,
  os,
  system,
  nim_tiled,
  tables,
  typetraits,

  sdl2/sdl, sdl2/sdl_image as img,
  sdl2/sdl_gfx_primitives as gfx,
  sdl2/sdl_gfx_primitives_font as font,
  sdl2/sdl_ttf as ttf,

  freetype/[freetype, fttypes]

type
  Region* = ref object of RootObj
    pos*, size*: V2

  Camera* = ref object of Body
    zoom*, rotation*: float

  Image* = ref ImageObj
  ImageObj = object of RootObj
    texture*: sdl.Texture # Image texture
    w*, h*: int # Image dimensions

  FontGlyph* = ref object
    texture*: sdl.Texture
    size*, bearing*: V2
    advance*: int

  Font* = ref object
    face*: FT_Face
    characters*: TableRef[char, FontGlyph]

var current_color = (1.0, 1.0, 1.0, 1.0)

template currentColorSDL* (): sdl.Color=
  sdl.Color(
    r: (current_color[0] * 255).uint8,
    g: (current_color[1] * 255).uint8,
    b: (current_color[2] * 255).uint8,
    a: (current_color[3] * 255).uint8)

proc getChar* (f: Font, c: char): FontGlyph=
  result = f.characters[c]

# Initialize font library
var ft_context: FT_Library
doAssert(FT_Init_FreeType(ft_context) == 0, "Failed to initialize freetype")

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

proc loadFont* (renderer: sdl.Renderer, path: string, size=32): ttf.Font=
  result = ttf.openFont(path, size)

# WIP
# proc loadFont* (renderer: sdl.Renderer, path: string, size=32): Font=
#   result = Font(face: nil, characters: newTable[char, FontGlyph]())
# 
#   if FT_New_Face(ft_context, path, 0, result.face) != 0:
#     echo "Failed to load font: ", path
#     return
# 
#   discard FT_Set_Pixel_Sizes(result.face, 0, size.FT_UInt)
#   const RANGE = 128 
# 
#   for i in 0..<RANGE:
#     if FT_Load_Char(result.face, i.FT_U_Long, FT_LOAD_RENDER) != 0:
#       echo "Font failed to load the char: ", i.char
#       continue
# 
#     var glyph = FontGlyph(
#       texture: sdl.createTexture(renderer, sdl.PIXELFORMAT_INDEX8, sdl.TEXTUREACCESS_STATIC, result.face.glyph.bitmap.width.int, result.face.glyph.bitmap.rows.int),
#       size: Vec2(result.face.glyph.bitmap.width.float, result.face.glyph.bitmap.rows.float),
#       bearing: Vec2(result.face.glyph.bitmap_left.float, result.face.glyph.bitmap_top.float),
#       advance: result.face.glyph.advance.x.int
#     )
# 
# #     var validTexture = newSeq[uint8](result.face.glyph.bitmap.width.int * result.face.glyph.bitmap.rows.int)
# #     var j = 0
# #     for ch in result.face.glyph.bitmap.buffer:
# #       validTexture[j] = ch.uint8
# #       inc j
# 
#     var g = result.face.glyph
#     discard glyph.texture.updateTexture(nil, g.bitmap.buffer, g.bitmap.width.int)
#     let msg = sdl.getError()
#     echo msg
# 
#     result.characters.add(i.char, glyph)

# blend
proc blend* (obj: Image): sdl.BlendMode =
  var blend: sdl.BlendMode
  if obj.texture.getTextureBlendMode(addr(blend)) == 0:
    return blend
  else:
    return sdl.BlendModeBlend

proc `blend=`* (obj: Image, mode: sdl.BlendMode) {.inline.} =
  discard obj.texture.setTextureBlendMode(mode)

# alpha
proc alpha* (obj: Image): int =
  var alpha: uint8
  if obj.texture.getTextureAlphaMod(addr(alpha)) == 0:
    return alpha
  else:
    return 255

proc `alpha=`* (obj: Image, alpha: int) =
  discard obj.texture.setTextureAlphaMod(alpha.uint8)


proc setColor* [T](renderer: sdl.Renderer, c: (T, T,T,T))=
  current_color = (c[0].float,c[1].float,c[2].float,c[3].float)

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

proc drawTiledMap* (renderer: sdl.Renderer, map: TiledMap, texture: Image, ox, oy = 0.0)=
  let tileset = map.tilesets[0]

  for layer in map.layers:
    var tiles = layer.tiles
    for y in 0..<layer.height:
      for x in 0..<layer.width:
        let index = x + y * layer.width
        let gid = tiles[index]

        if gid != 0:
          let quad = tileset.regions[gid - 1]
          var region = newRegion(quad.x.float, quad.y.float, quad.width.float, quad.height.float)
          
          draw(renderer, texture, region, x.float * map.tilewidth.float, y.float * map.tileheight.float)

proc drawString* (renderer: sdl.Renderer, font: ttf.Font, text: string, x, y: float, scale=1.0)=
  # Render surface
  proc render(renderer: sdl.Renderer,
            surface: sdl.Surface, x, y: int): bool =
    result = true
    var rect = sdl.Rect(x: x, y: y, w: (surface.w.float * scale).int, h: (surface.h.float * scale).int)
    # Convert to texture
    var texture = sdl.createTextureFromSurface(renderer, surface)
    if texture == nil:
      return false
    # Render texture
    if renderer.renderCopy(texture, nil, addr(rect)) == 0:
      result = false
    # Clean
    destroyTexture(texture)

  var s = font.renderUTF8_Solid(text, currentColorSDL())
  discard renderer.render(s, (x.int - camera.position.x.int) * camera.zoom.int, (y.int - camera.position.y.int) * camera.zoom.int)
  sdl.freeSurface(s)

proc drawStringScaledToBox* (renderer: sdl.Renderer, font: ttf.Font, text: string, x, y, width, height: float)=
  var w = 0.cint
  var h = 0.cint
  discard ttf.sizeText(font, text.cstring, addr w, addr h)

  var scaleRate = 1.0 / (h.float / height.float)
  drawString(renderer, font, text, x, y, scaleRate)

proc drawStringInBox* (renderer: sdl.Renderer, font: ttf.Font, text: string, x, y: float, width, height: float)=
  var ww = width * camera.zoom
  var hh = height * camera.zoom

  var lines: seq[(string, int)] = @[]
  var build = ""
  for c in text:
    var temp = build & $c
    
    var w = 0.cint
    var h = 0.cint
    discard ttf.sizeText(font, temp.cstring, addr w, addr h)

    if w.float >= ww:
      lines.add((build, h.int))
      build = $c
    else:
      build.add(c)

  if build.len > 0:
    var w = 0.cint
    var h = 0.cint
    discard ttf.sizeText(font, build.cstring, addr w, addr h)
    lines.add((build, h.int))

  var yy = 0
  for tup in lines:
    var (line, height) = tup
    drawString(renderer, font, line, x, y + yy.float)
    yy += (height.float / camera.zoom.float).int
