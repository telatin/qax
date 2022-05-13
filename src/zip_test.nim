# Execute an external command
import os
var
  zipCode : int

try:
 zipCode = execShellCmd("zip -r artifactor.zip *.* > /dev/null 2&>1")
except Exception as e:
  echo "ERROR: ", e.msg
  quit(1)

if zipCode == 0:
  echo "OK"
else:
  echo "FAIL"
