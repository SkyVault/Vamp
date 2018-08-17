import 
  art,
  sequtils,
  tables,
  typetraits,
  typeinfo,
  json

var images = newTable[string, Image]()
var jsons = newTable[string, JsonNode]()

proc addJson* (j: JsonNode, id: string)=
  jsons.add(id, j)

proc addImage* (i: Image, id: string)=
  images.add(id, i)

proc getImage* (id: string): auto= images[id]
proc getJson* (id: string): auto= jsons[id]

proc readJsonAnimation* (path: string)=
  discard
