#!/bin/bash
set -euxo pipefail
LAST=$(gh release list -L 1 | cut -f1)
TAG=$(grep version qax.nimble | cut -f 2 -d '"' )
COMMIT=$(git status -s| wc -l  | sed 's/ //g')
NOTES=docs/releases/${TAG}.md
OS=$(uname)
if [[ $LAST == $TAG ]]; then
  echo "Last release online $LAST is equal to the current version"
  exit
fi

if [[ $COMMIT -gt 0 ]]; then
  echo "There are $COMMIT uncommitted files"
  exit
fi

if [[ ! -e $NOTES ]]; then
  echo " ERROR: Release notes not found: $NOTES"
  exit 1
fi


nimble build
bash test/all.sh
BIN=bin/qax
if [[ $(uname) == 'Darwin' ]];
  BIN=bin/qax_mac
  mv bin/qax $BIN
fi
gh release create $TAG -F $NOTES -t ${TAG} $BIN
