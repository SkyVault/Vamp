import 
  art,
  platform,
  sdl2/sdl,
  maths,
  json

type
  DialogBoxHandlerO* = ref object
    dialogs: seq[DialogBox]
    showing: bool
  
  DialogBox* = ref object
    data: JsonNode
    point: V2

var dialogBox = DialogBoxHandlerO(
  showing: false,
  dialogs: @[])

template DialogBoxHandler* = dialogBox

proc showDialog* (node: JsonNode, point: V2)=
  platform.Pause()

  dialogBox.dialogs.add(DialogBox(
    data: node,
    point: point
  ))

proc update* =
  discard

proc draw* =
  if len(dialogBox.dialogs) == 0:
    return

  for d in dialogBox.dialogs:
    echo d.point.x, " ", d.point.y
    # Calucalate the size of the box
    # Move it up
    var size = Vec2(128, 64)
    R2D.setColor((1.0, 1.0, 1.0, 1.0))
    R2D.rect(d.point.x, d.point.y - size.y - 8.0, size.x, size.y)
