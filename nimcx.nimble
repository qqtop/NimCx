[Package]

name          = "nimcx"
version       = "0.9.9"
author        = "qqTop"
description   = "Color and utilities library for a happy linux terminal."
license       = "MIT"

[Deps]

Requires : "nim >= 0.19.0"


[Checks]
import distros
task setup, "Setup started":
  if detectOs(Windows):
    echo "Linux only. Windows is not supported"
quit()
