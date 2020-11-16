# Package
version       = "0.1.0"
author        = "Andrea Telatin"
description   = "Qiime Artifact eXtractor"
license       = "MIT"

# Dependencies
requires "nim >= 1.0", "docopt", "terminaltables", "zip"

srcDir = "src"
bin = @["qax"]

task qax, "compile qax":
  mkdir  "bin"
  exec "nimble c -p:lib/yaml/ -d:release  --opt:speed --out:bin/qax src/qax"

