#!/bin/bash
set -exuo pipefail
OLDWD=$PWD

PLATFORM=""
if [[ $(uname) == 'Darwin' ]];
then
 PLATFORM="_mac"
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


nim --version >/dev/null 2>&1       || { echo "nim compiler not found."; exit 1; }
RELEASE=""
if [ "${NIM_RELEASE+x}" ]; then
 RELEASE=" -d:release ";
fi

nim c -w:on --opt:speed $RELEASE  -o:$DIR/../bin/qax${PLATFORM} $DIR/qax.nim || { echo "Compilation failed."; exit 1; }
#bash $DIR/../test/mini.sh
