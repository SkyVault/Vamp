import 
  art,
  sequtils,
  tables,
  typetraits,
  typeinfo,
  json,
  sdl2/sdl_ttf as ttf

var images = newTable[string, Image]()
var jsons = newTable[string, JsonNode]()
var fonts = newTable[string, ttf.Font]()

proc addJson* (j: JsonNode, id: string)=
  jsons.add(id, j)

proc addImage* (i: Image, id: string)=
  images.add(id, i)

proc addFont* (i: ttf.Font, id: string)=
  fonts.add(id, i)

proc getImage* (id: string): auto= images[id]
proc getJson* (id: string): auto= jsons[id]
proc getFont* (id: string): auto= fonts[id]

proc readJsonAnimation* (path: string)=
  discard
