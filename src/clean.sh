#!/bin/bash
set -euo pipefail
OLDWD=$PWD
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

for FILE in $DIR/../utils/*.nim;
do
  if [ -e ${FILE%.nim} ]; then
   rm ${FILE%.nim}
   echo Removing ${FILE%.nim}
  fi
done
