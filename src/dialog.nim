import 
  art,
  platform,
  sdl2/sdl,
  maths,
  json,
  assets,
  input

type
  DialogBoxHandlerO* = ref object
    optionIndex: int
    dialogs: seq[DialogBox]
    showing: bool
  
  DialogBox* = ref object
    data: JsonNode
    currentIndex: string
    point: V2

var dialogBox = DialogBoxHandlerO(
  showing: false,
  dialogs: @[],
  optionIndex: 0)

template DialogBoxHandler* = dialogBox

proc showDialog* (node: JsonNode, point: V2)=
  platform.Pause()

  var index = "-1"
  for k, v in node.pairs:
    index = k
    break

  dialogBox.dialogs.add(DialogBox(
    data: node,
    point: point,
    currentIndex: index
  ))

proc update* =
  if len(dialogBox.dialogs) == 0:
    return

  let dialog = dialogBox.dialogs[0]
  let data = dialog.data[dialog.currentIndex]
  if data.hasKey "options":
    let options = data["options"]
    let numOptions = options.len

    if isKeyPressed(Key.Left):
      dec dialogBox.optionIndex

    if isKeyPressed(Key.Right):
      inc dialogBox.optionIndex

    dialogBox.optionIndex = dialogBox.optionIndex mod numOptions
    if dialogBox.optionIndex < 0:
      dialogBox.optionIndex = numOptions - 1

proc draw* =
  if len(dialogBox.dialogs) == 0:
    return

  for d in dialogBox.dialogs:
    # Calucalate the size of the box
    # Move it up
    var size = Vec2(128, 64)
    R2D.setColor((0.0, 0.2, 0.4, 0.8))
    R2D.rect(d.point.x, d.point.y - size.y - 8.0, size.x, size.y)

    let dialog = dialogBox.dialogs[0]
    let data = dialog.data[dialog.currentIndex]
    var text = data["text"]
    let font = assets.getFont "minecraft"

    R2D.setColor((1, 1, 1, 1))
    R2D.drawStringInBox(font, text.getStr(), d.point.x, d.point.y - size.y - 8.0, size.x, size.y)

    if data.hasKey "options":
      let options = data["options"]

      let numOptions = options.len
      var index = 0
      for option in options:
        var optionText = option[0]
        var optionWidth = size.x / numOptions.float
        R2D.drawStringScaledToBox(
          font,
          optionText.getStr(),
          d.point.x + optionWidth * index.float,
          d.point.y - 16.0,
          optionWidth,
          float(32))
        
        if index == dialogBox.optionIndex:
          R2D.lineRect(d.point.x + optionWidth * index.float, d.point.y - 16, optionWidth.float, 8)

        index += 1
