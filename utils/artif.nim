import zip/zipfiles
import os

var
  art = paramStr(1)

var
    z: ZipArchive

if not z.open(art):
  echo "Error opening"
else:
  z.extractFile(paramStr(2),  "./fi/fo")