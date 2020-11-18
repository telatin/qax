import zip/zipfiles
import os, strutils

var
  art = paramStr(1)

var
    z: ZipArchive

if not z.open(art):
  echo "Error opening"
  quit(1)
else:
  for file in z.walkFiles:
    var parts = file.split('/')
    delete(parts, 0)
    delete(parts, 0)
    var dest = parts.join("/")
    echo file, "\n -> ", parentDir(dest)