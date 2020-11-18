#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -d "/project/src" ];
then
  DIR="/project/src/"
fi
PLATFORM=""
if [[ $(uname) == "Darwin" ]]; then
 PLATFORM="_mac"
fi
BIN=$DIR/../bin/qax${PLATFORM}

FILES=$DIR/../input/

set -euxo pipefail

echo "[1] List"
$BIN list $FILES/*.qz?
$BIN list -b $FILES/*.qz?
$BIN list -b  -u $FILES/*.qz?
$BIN list -b  -r $FILES/*.qz?

echo "[2] extract"
#$BIN extract $FILES/rep-seqs.qzv -o /tmp/
