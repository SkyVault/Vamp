import 
  art,
  sequtils,
  tables,
  typetraits,
  typeinfo

var images = newTable[string, Image]()

proc add* [T](i: T, id: string): T {.discardable.}=
  if T.name == "Image":
    images.add(id, i)
  return i

proc get* (T: typedesc, id: string): auto=
  if T.name == "Image":
    return images[id]

proc readJsonAnimation* (path: string)=
  discard
