# Package

version       = "0.1.0"
author        = "Dustin Neumann"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["vampSnap"]

# Dependencies

requires "nim >= 0.18.0"
requires "sdl2_nim"
requires "nim_tiled"
requires "https://github.com/jangko/freetype"
