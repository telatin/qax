# Package
version       = "0.9.5"
author        = "Andrea Telatin"
description   = "Qiime Artifact eXtractor"
license       = "Apache"

# Dependencies
requires "nim >= 1.0", "docopt", "terminaltables", "zip", "uuids"

srcDir = "src"

namedBin = {"qax": "bin/qax"}.toTable()
task qax, "compile qax":
  mkdir  "bin"
  exec "nimble c -p:lib/yaml/ -d:release  --opt:speed --out:bin/qax src/qax"

