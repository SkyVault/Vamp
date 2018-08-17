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
  showing: false)

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
  discard

