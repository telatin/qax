
 
import tables, strutils, algorithm, yaml
import os, osproc
import docopt
import ./qax_utils
 

type
    artifactInfo = tuple[
      uuid, rank, actionName: string, 
      timestamp: DateTime, inputs: 
      seq[string]]
 
proc stripUUID(s: string): string =
  return '"' & s.split(":")[0].replace("-", "") & '"' 

proc makeNode(uuid, artifactType, rank: string, timestamp: DateTime): string =
  let
    color = if rank == "top": "gold1"
            elif rank == "child": "lightsteelblue1"
            else: "white"

  result = stripUUID(uuid)
  result &=  "   [fillcolor=" & color  & ", label=\"{" & uuid & "|{ " & artifactType & " }|{ " & timestamp.format("YYYY-mm-dd") & " |  "  & timestamp.format("HH:MM") & "}}\"]; \n"

proc makeEdge(a, b, name: string): string =
  #LR_2 -> LR_4 [ label = "S(A)" ];
  if a == "null" or b == "null":
    return ""
  result &=  stripUUID(b) & " -> " & stripUUID(a) & " [ label = \"" & name & "\"];\n " 

proc makeGraph(nodes, edges: string ): string = 
  return """digraph G {
concentrate=True;
rankdir=TD;
node [shape=record, style=filled];
""" & nodes & "\n\n" & edges & "\n}"

proc getChildType(inputFile, childId, parentId, parentType: string): string =
  # {uuid} / provenance / artifacts / {child} / metadata.yaml
  let metadataPath = joinPath( parentId, joinPath("provenance", joinPath("artifacts", joinPath(childId, "metadata.yaml"))))

  if childID == parentId:
    return parentType

  try:
    let child = readFileFromZip(inputFile, metadataPath)
    let meta = loadDom(child)
    return meta.root["format"].content
  except Exception as e:
    stderr.writeLine("Warning: unable to find metadata for: ", childId)
    return ""

proc provenance(argv: var seq[string]): int =
    let args = docopt("""
Usage: provenance [options] <inputfile>

Print ancestry of an artifact

Options:
  -o, --dotfile DOTFILE  Save graphviz graph (dot format)
  -p, --pdf              Generate PDF of the graph (requires -o and "dot" installed)
  -f, --font FONT        Font name for the PDF [default: Arial]
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    let
      #outputTable = newUnicodeTable()
      force = false
    var
      dotNodes, dotEdges = ""      # Textual output in GraphViz format
      Family = newSeq[artifactInfo]()       # Array of artifactInfos (all ancestors)

    # Check input file exists
    if not fileExists($args["<inputfile>"]) and not symlinkExists($args["<inputfile>"]):
      stderr.writeLine("[provenance] Error: ", $args["<inputfile>"], ": not found, or not a file")
      quit(1)

    
    # Load input file artifact info
    var
      art: QiimeArtifact
      actionType = initTable[string, string]()
      artifactType = initTable[string, string]()
    try:
      art = readArtifact($args["<inputfile>"])
      artifactType[art.uuid] = art.artifacttype
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
          dotEdges &= makeEdge(art.uuid, i.value.content, "?")

      let parents = childMeta.root["action"]["parameters"]
      for node in parents.items:
        for i in node.pairs:
          if i.key.content == "input":
            inputSeq.add(i.value.content)
            dotEdges &= makeEdge(art.uuid, i.value.content, "input")
    except:
      stderr.writeLine("Unable to find parents for the artifact.")
      quit(1)

    try:
      actionType[art.uuid] = childMeta.root["action"]["output-name"].content
    except:
      actionType[art.uuid] = "<not-found>"

    Family.add((uuid: art.uuid, rank: "child", actionName: "", timestamp: parseStamp(childMeta.root["execution"]["runtime"]["start"].content), inputs: inputSeq))
    
    # Parse actions for all parents
    for parent in art.parents:
      var
        rank = "|"
        pluginActionName = ""
        inputSeq = newSeq[string]()

      let proveYaml = joinPath(art.uuid, joinPath("provenance/artifacts", joinPath(parent, joinPath("action", "action.yaml"))))
      let yaml = readFileFromZip($args["<inputfile>"], proveYaml)
      let metaYaml    = loadDOM(yaml)
      
      try:
        pluginActionName = metaYaml.root["action"]["plugin"].content
      except Exception as e:
        rank = "top"
        inputSeq.add("<none>")

      try:
        let inputs = metaYaml.root["action"]["inputs"]
        for node in inputs.items:
          for i in node.pairs:
            dotNodes &= makeEdge(parent, i.value.content, i.key.content)
            actionType[i.value.content] = i.key.content
            inputSeq.add(i.value.content)
      except Exception as e:
        rank = "top"

      Family.add((uuid: parent, rank: rank, actionName: pluginActionName, timestamp: parseStamp(metaYaml.root["execution"]["runtime"]["start"].content), inputs: inputSeq))


    Family =  Family.sortedByIt(it.timestamp)

    # Print all artifacts in chronological order
    for i in Family:
      var
        dateString = i.timestamp.format("yyyy-MM-dd HH:MM")
        typeString = if i.uuid in actionType: actionType[i.uuid]
                       else: "input"

      let artifactType = getChildType($args["<inputfile>"] ,i.uuid, art.uuid, art.artifacttype)                  
      dotNodes &= makeNode(i.uuid, artifactType, i.rank, i.timestamp)
      echo i.uuid, "\t", i.rank,  "\t", dateString, "\t", typeString, "\t\t[inputs: ", i.inputs.join(";") ,"]"

    # If --pdf is requested without -o FILE, warn the user (exit gracefully)
    if args["--pdf"] and not args["--dotfile"]:
      stderr.writeLine("[provenance] Warning: --pdf requires --dotfile FILENAME to be specified. Ignored.")
      quit(0)
    
    # Generate Dot file
    if args["--dotfile"]:
      let graphviz = makeGraph(dotNodes, dotEdges)
      try:
        writeFile($args["--dotfile"], graphviz)
      except Exception as e:
        stderr.writeLine("[provenance] ERROR: Unable to write output plot to:" , $args["--dotfile"], "\nFind the plot in the STDOUT instead:\n")
        echo graphviz
        quit(1)
      stderr.writeLine("[provenance] Dot file saved to: ", args["--dotfile"], "")
      if args["--pdf"]:
        let font = $args["--font"]
        let command = "dot -O -Tpdf -Nfontname=\"" & font & "\" -Efontname=\"" & font & "\" " & $args["--dotfile"]
        let dotRun = execCmdEx(command, options = {})
        if dotRun.exitCode != 0:
          stderr.writeLine("[provenance] Unable to generate PDF file, is dot installed?")
        else:
          stderr.writeLine("[provenance] PDF saved to: ", args["--dotfile"], ".pdf")
        #dot -O -Tpdf -Nfontname=Helvetica -Efontname=Helvetica ciao
 
