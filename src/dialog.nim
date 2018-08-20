import 
  art,
  platform,
  sdl2/sdl,
  maths,
  json,
  assets

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
    # Calucalate the size of the box
    # Move it up
    var size = Vec2(128, 64)
    R2D.setColor((0.0, 0.2, 0.4, 0.8))
    R2D.rect(d.point.x, d.point.y - size.y - 8.0, size.x, size.y)

    R2D.setColor((1, 1, 1, 1))
    R2D.drawString(assets.getFont "arial", "Hello World :)", 10, 10)
