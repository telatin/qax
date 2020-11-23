#!/bin/bash
OK="$(tput setaf 2)OK$(tput setaf 0)"
KO="$(tput setaf 5)FAIL$(tput setaf 0)"
B=$(tput bold)
N=$(tput sgr0)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -d "/project/src" ];
then
  DIR="/project/src/"
fi
PLATFORM=""
if [[ $(uname) == "Darwin" ]]; then
 PLATFORM="_mac"
fi
BIN="$DIR/../bin/qax${PLATFORM}"
OUT="$DIR/../output/"
FILES="$DIR/../input/"

mkdir -p "$OUT"
set -euo pipefail
echo "$(tput setaf 4)    ----- Testing   ${B}QAX $N $(tput setaf 4) ----- $(tput setaf 0)"
echo "          $(tput setaf 5)$($BIN | grep version)$(tput setaf 0)"
echo
echo -e "$B[0] Synopsis$N"
for i in list citations provenance extract; 
do 
  ./bin/qax_mac $i --help | grep -w $i | grep Usage >/dev/null && echo -e "     $OK Help for '$i': found"; 
done


echo -e "$B[1] List$N"
$BIN list $FILES/*.qz?        | grep DNASequencesDirectoryFormat >/dev/null && echo -e "     $OK list (no params)"
$BIN list -b $FILES/*.qz?     | grep DNASequencesDirectoryFormat  >/dev/null&& echo -e "     $OK list (-b)"
$BIN list -b  -u $FILES/*.qz? | grep bb1b2e93-0c45-4c8e-a140-2afa2110b5fb  >/dev/null&& echo -e "     $OK list (-b -u)"
LINES=$($BIN list -b  -r $FILES/*.qz? | wc -l)

if [ $LINES -eq 3 ]; then
  echo -e "     $OK list (-r)"
else
  echo -e "     $KO Expecting 3 lines from list input/*.qz?"
  exit 1
fi

echo -e "$B[2] Extract$N"
#$BIN extract $FILES/rep-seqs.qzv -o /tmp/

$BIN extract $FILES/rep-seqs.qza -o $OUT/
if [ ! -e "$OUT"/rep-seqs.fasta ]; then
  echo -e "     $KO Unable to find extracted file $OUT/rep-seqs.fasta"
  exit 1
else
  echo -e "     $OK Extract single artifact"
fi

$BIN extract $FILES/taxonomy.qzv -o $OUT/
if [ ! -e "$OUT"/taxonomy/index.html ]; then
  echo -e "     $KO Unable to find extracted file $OUT/rtaxonomy/index.html "
  exit 1
else
  echo -e "     $OK Extract multiple files artifact"
fi

if [ ! -e "$OUT"/taxonomy/q2templateassets/fonts/glyphicons-halflings-regular.ttf ]; then
  echo -e "     $KO Unable to find extracted file $OUT/taxonomy/q2templateassets/fonts/glyphicons-halflings-regular.ttf "
  exit 1
else
  echo -e "     $OK Extract multiple files artifact (subdirectory)"
fi
echo -e "$B[3] Citations$N"
DIRECT=$($BIN citations $FILES/taxonomy.qzv  | grep -c '@')
RECURSIVE=$($BIN citations -r $FILES/taxonomy.qzv  | grep -c '@')
if [ $DIRECT -eq 1 ]; then
  echo -e "     $OK 1 citation found in taxonomy.qzv"
else
  echo -e "     $KO expecting 1 citation in taxonomy.qzv: $DIRECT found"
  exit 1
fi

if [ $RECURSIVE -eq 8 ]; then
  echo -e "     $OK 8 _total_ citations found in taxonomy.qzv"
else
  echo -e "     $KO expecting 8 _total_ citation in taxonomy.qzv: $RECURSIVE found"
  exit 1
fi

echo -e "$B[4] Provenance$N"
PARENTS=$($BIN provenance $FILES/taxonomy.qzv  | grep -c -w -i 'top')
CHILDREN=$($BIN provenance $FILES/taxonomy.qzv  | grep -c -w -i 'child')
if [ $PARENTS -eq 3 ]; then
  echo -e "     $OK 3 parents for taxonomy.qzv"
else
  echo -e "     $KO expecting 3 parents for taxonomy.qzv: $PARENTS found"
  exit 1
fi

if [ $CHILDREN -eq 1 ]; then
  echo -e "     $OK 1 child for taxonomy.qzv"
else
  echo -e "     $KO expecting 1 child for taxonomy.qzv: $CHILDREN found"
  exit 1
fi

$BIN p -o "$OUT"/graph.dot "$FILES"/taxonomy.qzv >/dev/null 2>/dev/null
if [ -e "$OUT"/graph.dot ]; then
  echo -e "     $OK output graph found"
else
  echo -e "     $KO output graph NOT found"
  exit 1
fi

EDGES=$(grep -c '\->' "$OUT"/graph.dot)
if [ $EDGES -eq 7 ]; then
  echo -e "     $OK output graph has 7 nodes"
else
  echo -e "     $KO expecting 7 nodes in graph: $EDGES found"
  exit 1
fi



echo -e "$B[5] View$N"
COUNT=$($BIN view $FILES/rep-seqs.qza  | grep -c  '>')
if [ $COUNT -eq 769 ]; then
  echo -e "     $OK 769 seqs for rep-seqs.qza"
else
  echo -e "     $KO expecting 769 seqs for rep-seqs.qza: $COUNT found"
  exit 1
fi

tput init
