# Package
version       = "1.0.0"
author        = "Andrea Telatin"
description   = "Qiime Artifact eXtractor"
license       = "Apache"

# Dependencies
requires "nim >= 2.0.0", "docopt", "terminaltables", "zip", "uuids", "yaml >= 2.0.0"

srcDir = "src"

namedBin = {"qax": "bin/qax"}.toTable()

#task qax, "compile qax":
#  mkdir  "bin"
#  exec "nimble c -p:lib/yaml/ -d:release  --opt:speed --out:bin/qax src/qax"

