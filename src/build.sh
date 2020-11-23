#!/bin/bash
set -exuo pipefail
OLDWD=$PWD

PLATFORM=""
STAT=""
if [[ $(uname) == 'Darwin' ]];
then
 PLATFORM="_mac"
else
 STAT=" --passl:\"-static\" "
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -d "/project/src" ];
then
  DIR="/project/src/"
fi
echo "Src:$DIR"

nim --version >/dev/null 2>&1       || { echo "nim compiler not found."; exit 1; }
RELEASE=""
if [ "${NIM_RELEASE+x}" ]; then
 RELEASE=" -d:release ";
fi


nim c -d:useLibzipSrc -w:on $STAT -p:lib/yaml --opt:speed $RELEASE --verbosity:0 --hints:off -o:$DIR/../bin/qax${PLATFORM}   $DIR/qax.nim || { echo "Compilation failed."; exit 1; }

$DIR/../bin/qax${PLATFORM} --help
$DIR/../bin/qax${PLATFORM} $DIR/../input/*

if [ -e "$DIR"/../test/all.sh ];
then
  bash "$DIR"/../test/all.sh
fi

if [ -e "$DIR"/clean.sh ]; then
 bash "$DIR"/clean.sh
fi