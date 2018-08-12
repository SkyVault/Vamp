# import
#     glfw

import 
    sdl2/sdl,
    tables

type
    ControlerNumber* {.pure.} = enum
        One = 1,
        Two,
        Three,
        Four

    ControllerButtons* {.pure.} = enum
        A                   = sdl.CONTROLLER_BUTTON_A,
        B                   = sdl.CONTROLLER_BUTTON_B,
        X                   = sdl.CONTROLLER_BUTTON_X,
        Y                   = sdl.CONTROLLER_BUTTON_Y,
        Back                = sdl.CONTROLLER_BUTTON_BACK,
        Guide               = sdl.CONTROLLER_BUTTON_GUIDE,
        Start               = sdl.CONTROLLER_BUTTON_START,
        LeftStick           = sdl.CONTROLLER_BUTTON_LEFTSTICK,
        RightStick          = sdl.CONTROLLER_BUTTON_RIGHTSTICK,
        LeftShoulder        = sdl.CONTROLLER_BUTTON_LEFTSHOULDER,
        RightShoulder       = sdl.CONTROLLER_BUTTON_RIGHTSHOULDER,
        DpadUp              = sdl.CONTROLLER_BUTTON_DPAD_UP,
        DpadDown            = sdl.CONTROLLER_BUTTON_DPAD_DOWN,
        DpadLeft            = sdl.CONTROLLER_BUTTON_DPAD_LEFT,
        DpadRight           = sdl.CONTROLLER_BUTTON_DPAD_RIGHT,
        Max                 = sdl.CONTROLLER_BUTTON_MAX,
        Invalid             = sdl.CONTROLLER_BUTTON_INVALID

    Key* {.pure.}= enum
        UNKNOWN = K_UNKNOWN
        BACKSPACE = K_BACKSPACE
        TAB = K_TAB
        RETURN = K_RETURN
        ESCAPE = K_ESCAPE
        SPACE = K_SPACE
        EXCLAIM = K_EXCLAIM
        QUOTEDBL = K_QUOTEDBL
        HASH = K_HASH
        DOLLAR = K_DOLLAR
        PERCENT = K_PERCENT
        AMPERSAND = K_AMPERSAND
        QUOTE = K_QUOTE
        LEFTPAREN = K_LEFTPAREN
        RIGHTPAREN = K_RIGHTPAREN
        ASTERISK = K_ASTERISK
        PLUS = K_PLUS
        COMMA = K_COMMA
        MINUS = K_MINUS
        PERIOD = K_PERIOD
        SLASH = K_SLASH
        N0 = K_0
        N1 = K_1
        N2 = K_2
        N3 = K_3
        N4 = K_4
        N5 = K_5
        N6 = K_6
        N7 = K_7
        N8 = K_8
        N9 = K_9
        COLON = K_COLON
        SEMICOLON = K_SEMICOLON
        LESS = K_LESS
        EQUALS = K_EQUALS
        GREATER = K_GREATER
        QUESTION = K_QUESTION
        AT = K_AT
#
#Skipuppercaseletters
#
        LEFTBRACKET = K_LEFTBRACKET
        BACKSLASH = K_BACKSLASH
        RIGHTBRACKET = K_RIGHTBRACKET
        CARET = K_CARET
        UNDERSCORE = K_UNDERSCORE
        BACKQUOTE = K_BACKQUOTE
        a = K_a
        b = K_b
        c = K_c
        d = K_d
        e = K_e
        f = K_f
        g = K_g
        h = K_h
        i = K_i
        j = K_j
        k = K_k
        l = K_l
        m = K_m
        n = K_n
        o = K_o
        p = K_p
        q = K_q
        r = K_r
        s = K_s
        t = K_t
        u = K_u
        v = K_v
        w = K_w
        x = K_x
        y = K_y
        z = K_z
        CAPSLOCK = K_CAPSLOCK
        F1 = K_F1
        F2 = K_F2
        F3 = K_F3
        F4 = K_F4
        F5 = K_F5
        F6 = K_F6
        F7 = K_F7
        F8 = K_F8
        F9 = K_F9
        F10 = K_F10
        F11 = K_F11
        F12 = K_F12
        PRINTSCREEN = K_PRINTSCREEN
        SCROLLLOCK = K_SCROLLLOCK
        PAUSE = K_PAUSE
        INSERT = K_INSERT
        HOME = K_HOME
        PAGEUP = K_PAGEUP
        END = K_END
        PAGEDOWN = K_PAGEDOWN
        RIGHT = K_RIGHT
        LEFT = K_LEFT
        DOWN = K_DOWN
        UP = K_UP
        NUMLOCKCLEAR = K_NUMLOCKCLEAR
        KP_DIVIDE = K_KP_DIVIDE
        KP_MULTIPLY = K_KP_MULTIPLY
        KP_MINUS = K_KP_MINUS
        KP_PLUS = K_KP_PLUS
        KP_ENTER = K_KP_ENTER
        KP_1 = K_KP_1
        KP_2 = K_KP_2
        KP_3 = K_KP_3
        KP_4 = K_KP_4
        KP_5 = K_KP_5
        KP_6 = K_KP_6
        KP_7 = K_KP_7
        KP_8 = K_KP_8
        KP_9 = K_KP_9
        KP_0 = K_KP_0
        KP_PERIOD = K_KP_PERIOD
        APPLICATION = K_APPLICATION
        POWER = K_POWER
        KP_EQUALS = K_KP_EQUALS
        F13 = K_F13
        F14 = K_F14
        F15 = K_F15
        F16 = K_F16
        F17 = K_F17
        F18 = K_F18
        F19 = K_F19
        F20 = K_F20
        F21 = K_F21
        F22 = K_F22
        F23 = K_F23
        F24 = K_F24
        EXECUTE = K_EXECUTE
        HELP = K_HELP
        MENU = K_MENU
        SELECT = K_SELECT
        STOP = K_STOP
        AGAIN = K_AGAIN
        UNDO = K_UNDO
        CUT = K_CUT
        COPY = K_COPY
        PASTE = K_PASTE
        FIND = K_FIND
        MUTE = K_MUTE
        VOLUMEUP = K_VOLUMEUP
        VOLUMEDOWN = K_VOLUMEDOWN
        KP_COMMA = K_KP_COMMA
        KP_EQUALSAS400 = K_KP_EQUALSAS400
        ALTERASE = K_ALTERASE
        SYSREQ = K_SYSREQ
        CANCEL = K_CANCEL
        CLEAR = K_CLEAR
        PRIOR = K_PRIOR
        RETURN2 = K_RETURN2
        SEPARATOR = K_SEPARATOR
        OUT = K_OUT
        OPER = K_OPER
        CLEARAGAIN = K_CLEARAGAIN
        CRSEL = K_CRSEL
        EXSEL = K_EXSEL
        KP_00 = K_KP_00
        KP_000 = K_KP_000
        THOUSANDSSEPARATOR = K_THOUSANDSSEPARATOR
        DECIMALSEPARATOR = K_DECIMALSEPARATOR
        CURRENCYUNIT = K_CURRENCYUNIT
        CURRENCYSUBUNIT = K_CURRENCYSUBUNIT
        KP_LEFTPAREN = K_KP_LEFTPAREN
        KP_RIGHTPAREN = K_KP_RIGHTPAREN
        KP_LEFTBRACE = K_KP_LEFTBRACE
        KP_RIGHTBRACE = K_KP_RIGHTBRACE
        KP_TAB = K_KP_TAB
        KP_BACKSPACE = K_KP_BACKSPACE
        KP_A = K_KP_A
        KP_B = K_KP_B
        KP_C = K_KP_C
        KP_D = K_KP_D
        KP_E = K_KP_E
        KP_F = K_KP_F
        KP_XOR = K_KP_XOR
        KP_POWER = K_KP_POWER
        KP_PERCENT = K_KP_PERCENT
        KP_LESS = K_KP_LESS
        KP_GREATER = K_KP_GREATER
        KP_AMPERSAND = K_KP_AMPERSAND
        KP_DBLAMPERSAND = K_KP_DBLAMPERSAND
        KP_VERTICALBAR = K_KP_VERTICALBAR
        KP_DBLVERTICALBAR = K_KP_DBLVERTICALBAR
        KP_COLON = K_KP_COLON
        KP_HASH = K_KP_HASH
        KP_SPACE = K_KP_SPACE
        KP_AT = K_KP_AT
        KP_EXCLAM = K_KP_EXCLAM
        KP_MEMSTORE = K_KP_MEMSTORE
        KP_MEMRECALL = K_KP_MEMRECALL
        KP_MEMCLEAR = K_KP_MEMCLEAR
        KP_MEMADD = K_KP_MEMADD
        KP_MEMSUBTRACT = K_KP_MEMSUBTRACT
        KP_MEMMULTIPLY = K_KP_MEMMULTIPLY
        KP_MEMDIVIDE = K_KP_MEMDIVIDE
        KP_PLUSMINUS = K_KP_PLUSMINUS
        KP_CLEAR = K_KP_CLEAR
        KP_CLEARENTRY = K_KP_CLEARENTRY
        KP_BINARY = K_KP_BINARY
        KP_OCTAL = K_KP_OCTAL
        KP_DECIMAL = K_KP_DECIMAL
        KP_HEXADECIMAL = K_KP_HEXADECIMAL
        LCTRL = K_LCTRL
        LSHIFT = K_LSHIFT
        LALT = K_LALT
        LGUI = K_LGUI
        RCTRL = K_RCTRL
        RSHIFT = K_RSHIFT
        RALT = K_RALT
        RGUI = K_RGUI
        MODE = K_MODE
        AUDIONEXT = K_AUDIONEXT
        AUDIOPREV = K_AUDIOPREV
        AUDIOSTOP = K_AUDIOSTOP
        AUDIOPLAY = K_AUDIOPLAY
        AUDIOMUTE = K_AUDIOMUTE
        MEDIASELECT = K_MEDIASELECT
        WWW = K_WWW
        MAIL = K_MAIL
        CALCULATOR = K_CALCULATOR
        COMPUTER = K_COMPUTER
        AC_SEARCH = K_AC_SEARCH
        AC_HOME = K_AC_HOME
        AC_BACK = K_AC_BACK
        AC_FORWARD = K_AC_FORWARD
        AC_STOP = K_AC_STOP
        AC_REFRESH = K_AC_REFRESH
        AC_BOOKMARKS = K_AC_BOOKMARKS
        BRIGHTNESSDOWN = K_BRIGHTNESSDOWN
        BRIGHTNESSUP = K_BRIGHTNESSUP
        DISPLAYSWITCH = K_DISPLAYSWITCH
        KBDILLUMTOGGLE = K_KBDILLUMTOGGLE
        KBDILLUMDOWN = K_KBDILLUMDOWN
        KBDILLUMUP = K_KBDILLUMUP
        EJECT = K_EJECT
        SLEEP = K_SLEEP
        APP1 = K_APP1
        APP2 = K_APP2
        AUDIOREWIND = K_AUDIOREWIND
        AUDIOFASTFORWARD = K_AUDIOFASTFORWARD

    KeyState* = ref object of RootObj
        state*, last*: int

    # Mouse handler
    MouseState*  = ref object of KeyState
    ButtonState* = ref object of KeyState

    ControllerState* = ref object
        A, B, X, Y: ButtonState
        Start, Select: ButtonState
        LTrigger, RTrigger, LShoulder, RShoulder: ButtonState

    InputManager* = ref object
        mouse_x, mouse_y: float64
        last_mouse_x, last_mouse_y: float
        last_number_of_controllers: int
        mouse_left, mouse_right: MouseState
        keyMap: Table[int, KeyState]
        controllers: seq[sdl.GameController]

var input: InputManager

proc initInput* ()=
  input = InputManager(
    mouse_x: 0, mouse_y: 0,
    last_mouse_x: 0, last_mouse_y: 0,

    last_number_of_controllers: 0,

    mouse_left: MouseState(state : 0, last : 0),
    mouse_right: MouseState(state : 0, last : 0),
    keyMap: initTable[int, KeyState](),
    controllers: newSeq[sdl.GameController]()
  )

proc newKeyState(state = 0, last = 0): KeyState=
    return KeyState(state: state, last: last)

## Input manager functions

## Game pad
# proc IsGamepadConnected* (, which = 0): bool=
#     return 
#         joystickPresent(which.cint) == 1

proc pullControllerInfo(input: InputManager)=
    discard

# proc IsButtonDown( )

proc mouseX* (): float= return input.mouse_x
proc mouseY* (): float= return input.mouse_y

proc mousePos* (): (float, float)=
    return (mouseX(), mouseY())

proc mouseDeltaX* (): float=return input.mouse_x - input.last_mouse_x
proc mouseDeltaY* (): float=return input.mouse_y - input.last_mouse_y
proc mouseDeltaPos* (): (float, float)=
    return (
        mouseDeltaX(),
        mouseDeltaY()
    )

proc getKeyInRange(key: cint): int=
    if key > (1 shl 30):
        return ((sdl.K_Delete.int) + (key - (1 shl 30))).int
    else:
        return key.int 

proc isMouseLeftDown* (): bool=
    return input.mouse_left.state == 1

proc isMouseLeftUp* (): bool=
    return not isMouseLeftDown()

proc isMouseRightDown* (): bool=
    return input.mouse_right.state == 1

proc isMouseRightUp* (): bool=
    return not isMouseRightDown()

proc isMouseLeftPressed* (): bool =
    result =
        input.mouse_left.state == 1 and
        input.mouse_left.last == 0

proc isMouseLeftReleased* (): bool =
    result =
        input.mouse_left.state == 0 and
        input.mouse_left.last == 1

proc isMouseRightPressed* (): bool =
    result =
        input.mouse_right.state == 1 and
        input.mouse_right.last == 0

proc isMouseRightReleased* (): bool =
    result =
        input.mouse_right.state == 0 and
        input.mouse_right.last == 1

proc isKeyDown* (key: Key): bool =
    var ckey = getKeyInRange(key.cint)
    if not input.keyMap.contains ckey:
        return false
    else:
        return
            input.keyMap[ckey].state == 1

proc isKeyUp* (key: Key): bool =
    return not isKeyDown(key)

proc isKeyReleased* (key: Key): bool=
    var ckey = getKeyInRange(key.cint)
    if not input.keyMap.contains ckey:
        return false
    else:
        let state = input.keyMap[ckey]
        result =
            state.state == 0 and 
            state.last  == 1

proc isKeyPressed* (key: Key): bool=
    var ckey = getKeyInRange(key.cint)
    if not input.keyMap.contains ckey:
        return false
    else:
        let state = input.keyMap[ckey]
        result =
            state.state == 1 and 
            state.last == 0

proc inputUpdate* ()=
  for key, state in input.keyMap.mpairs:
    state.last = state.state

  input.mouse_left.last = input.mouse_left.state
  input.mouse_right.last = input.mouse_right.state

        # get the mouse position
  var x, y: cint
  discard sdl.getMouseState(addr(x), addr(y))

  input.last_mouse_x = input.mouse_x
  input.last_mouse_y = input.mouse_y
  input.mouse_x = x.float
  input.mouse_y = y.float

  if input.last_number_of_controllers < sdl.numJoysticks():
      input.last_number_of_controllers = sdl.numJoysticks()

      let index = input.controllers.len
      if not sdl.isGameController(index):
          echo "Unsupported controller interface"
      else:
          echo "Controller ", index, " connected!"
          # TODO: Attach the controller
          input.controllers.add(sdl.gameControllerOpen(index))

  elif input.last_number_of_controllers > sdl.numJoysticks():
      echo "Controller dissconnected!"
      input.last_number_of_controllers = sdl.numJoysticks()

  # GetAttached -> returns if a gamecontroller is still attached, could be useful for disconnection

  for c in input.controllers:
    echo sdl.gameControllerGetAttached(c)

proc inputHandleEvent* (ev: sdl.Event)=
  case ev.kind:
    of sdl.KeyDown :
        if ev.key.repeat > 0: return
        let key = getKeyInRange ev.key.keysym.sym.cint

        if input.keyMap.hasKey(key) == false:
            input.keyMap.add(key, newKeyState(1))
        else:
            input.keyMap[key] = newKeyState(1, 0)

    of sdl.KeyUp:
        if ev.key.repeat > 0: return
        let key = getKeyInRange ev.key.keysym.sym.cint

        if input.keyMap.hasKey(key) == false:
            input.keyMap.add(key, newKeyState(1))
        else:
            input.keyMap[key] = newKeyState(0, 1)

    of sdl.MouseButtonDown:
        case ev.button.button:
        of sdl.BUTTON_LEFT:
            input.mouse_left.state = 1

        of sdl.BUTTON_RIGHT:
            input.mouse_right.state = 1

        of sdl.BUTTON_MIDDLE:
            discard
        else:
            discard

    of sdl.MouseButtonUp:
        case ev.button.button:
        of sdl.BUTTON_LEFT: 
            input.mouse_left.state = 0
            input.mouse_left.last = 1

        of sdl.BUTTON_RIGHT:
            input.mouse_right.state = 0
            input.mouse_right.last = 1

        of sdl.BUTTON_MIDDLE:
            discard
        else:
            discard

    # of sdl.JoystickAx
        # echo "Wat"
    else:
        discard

