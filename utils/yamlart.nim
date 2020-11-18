import yaml

let
  metadata = """execution:
    uuid: b211bf3c-cb0d-4707-9c34-baff33d2819b
    runtime:
        start: 2020-02-28T13:44:23.928563+00:00
        end: 2020-02-28T13:44:24.850389+00:00
        duration: 921826 microseconds

action:
    type: visualizer
    plugin: !ref 'environment:plugins:metadata'
    action: tabulate
    inputs: []
    parameters:
    -   input: !metadata '9df28153-4e38-44aa-bbc4-58a37d699580:input.tsv'
    -   page_size: 100
    output-name: visualization

"""
 
let doc = loadDOM(metadata)

let inputs = doc.root["action"]["parameters"]

for node in inputs.items:
  for i in node.pairs:
    if i.key.content == "input":
        echo i.value.content
 
  #[
echo "ITERATION:\n";
for c in :
  echo "OK"
  echo "<", c.key.content, "> \t**", c.value.content, "**"
 
]# 
#if "execution" in doc.root:
  #echo "OK"
  #echo "UUID: ", doc.root["execution"].content
