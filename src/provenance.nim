import strformat
import zip/zipfiles
import tables, strutils, algorithm, terminaltables, yaml
import os
import docopt
import ./qax_utils
 

type
    artifactInfo = tuple[uuid, rank, s: string, timestamp: DateTime, inputs: seq[string]]
 
proc provenance(argv: var seq[string]): int =
    let args = docopt("""
Usage: provenance [options] <inputfile>

Print ancestry of an artifact

Options:
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    let
      outputTable = newUnicodeTable()
      force = false
    var
      columns = newSeq[string]()
      artifacts = newSeq[QiimeArtifact]()
      files = newSeq[string]()
      Family = newSeq[artifactInfo]()

      
    if not fileExists($args["<inputfile>"]) and not symlinkExists($args["<inputfile>"]):
      stderr.writeLine("[provenance] Error: ", $args["<inputfile>"], ": not found, or not a file")
      quit(1)

      
    var
      art: QiimeArtifact
      arttype = initTable[string, string]()
    try:
      art = readArtifact($args["<inputfile>"])
    except Exception as e:
      stderr.writeLine("ERROR: Unable to parse artifact ", $args["<inputfile>"], ":\n  ", e.msg)
      quit(1)

    # Parse child metadata / action
     
    let childYaml = joinPath(art.uuid, joinPath("provenance", joinPath(joinPath("action", "action.yaml"))))
    let child = readFileFromZip($args["<inputfile>"], childYaml)
    let childMeta = loadDom(child)
    var inputSeq = newSeq[string]()
    echo childMeta.root["action"]["plugin"].content
    
    
    try:
      let inputs = childMeta.root["action"]["inputs"]
      for node in inputs.items:
        for i in node.pairs:
          inputSeq.add(i.value.content)
      let parents = childMeta.root["action"]["parameters"]
      for node in parents.items:
        for i in node.pairs:
          if i.key.content == "input":
            inputSeq.add(i.value.content)
    except:
      stderr.writeLine("Unable to find parents for the artifact.")
      quit(1)


    Family.add((uuid: art.uuid, rank: "child", s: "", timestamp: parseStamp(childMeta.root["execution"]["runtime"]["start"].content), inputs: inputSeq))
    
    # Parse actions for all parents
    for parent in art.parents:
      var
        rank = "|"
        s = ""
        inputSeq = newSeq[string]()

      let proveYaml = joinPath(art.uuid, joinPath("provenance/artifacts", joinPath(parent, joinPath("action", "action.yaml"))))
      let yaml = readFileFromZip($args["<inputfile>"], proveYaml)
      let metaYaml    = loadDOM(yaml)
      
      try:
        s = metaYaml.root["action"]["plugin"].content
      except Exception as e:
        rank = "top"

      try:
        let inputs = metaYaml.root["action"]["inputs"]
        for node in inputs.items:
          for i in node.pairs:
            
            arttype[i.value.content] = i.key.content
            inputSeq.add(i.value.content)
      except Exception as e:
        rank = "top"

      Family.add((uuid: parent, rank: rank, s: s, timestamp: parseStamp(metaYaml.root["execution"]["runtime"]["start"].content), inputs: inputSeq))


    Family =  Family.sortedByIt(it.timestamp)


    for i in Family:
      var typeString = if i.uuid in arttype: arttype[i.uuid]
                       else: "?"
      echo i.uuid, "\t", i.rank,  "\t", i.timestamp, "\t", i.inputs.join(";"), "\t", typeString

