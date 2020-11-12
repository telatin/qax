import yaml

let
  data = """QIIME 2
archive: 5
framework: 2019.10.0"""

  metadata = """uuid: 313a0cf3-e2ec-48cf-95af-befad4ebf2f3
type: FeatureTable[Frequency]
format: BIOMV210DirFmt"""
 
let doc = loadDOM(metadata)

if "uuid" in doc.root:
  echo "UUID: ", doc.root["uuid"].content

echo "ITERATION:\n";
for c in doc.root.pairs:
 
  echo "<", c.key.content, "> \t**", c.value.content, "**"
 
 