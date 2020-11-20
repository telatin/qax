
 
import tables, strutils, times, algorithm, terminaltables
from os import fileExists
import docopt
import ./qax_utils
 



proc generateHeader(columns: seq[string]): seq[string] =
  if "uuid" in columns:
    result.add("ID")
  if "abspath" in columns:
    result.add("Path")
  elif "basename" in columns:
    result.add("Basename")
  else:
    result.add("Path")
  
  result.add("Type")
  result.add("Format")
  if "version" in columns:
    result.add("Version")

  if "date" in columns:
    result.add("Date")

  if "files" in columns:
    result.add("Files")


proc generateFields(artifact: QiimeArtifact, columns: seq[string]): seq[string] =
  if "uuid" in columns:
    result.add(artifact.uuid)

  if "abspath" in columns:
    result.add(artifact.path)
  elif "basename" in columns:
    result.add(artifact.basename)
  else:
    result.add(artifact.inputpath)
  
  result.add($artifact.artifacttype)
  result.add($artifact.format)

  if "version" in columns:
    result.add($artifact.version)

  if "date" in columns:
    result.add($artifact.date & ";" & $artifact.time)

    if "files" in columns:
      result.add($len(artifact.data))

proc printLine(artifact: QiimeArtifact, columns: seq[string], sep: string) =
  echo $artifact.uuid & sep &
    $artifact.path & sep  &
    $artifact.artifacttype & sep  &
    $artifact.format & sep &
    $artifact.version & sep &
    $artifact.date & sep &
    $len(artifact.data)
    
proc list(argv: var seq[string]): int =
    let args = docopt("""
Usage: list [options] [<inputfile> ...]

Options:
  --abs                  Show absolute paths [default: false]
  -a, --all              Show all fields [default: false]
  -b, --basename         Use basename instead of path [default: false]
  -s, --sortby SORT      Column to sort (uuid, type, format, date) [default: type]
  -f, --force            Accept non standard extensions
  --verbose              Verbose output
  --help                 Show this help

Nice output (default):
  -d, --datetime         Show artifact's date time [default: false]
  -u, --uuid             Show uuid [default: false]

Raw table output:
  -r, --rawtable         Print a CSV table (-s) with all fields [default: false]   
  -h, --header           Print header [default: false]
  -z, --separator SEP    Separator when using --rawtable [default: tab]

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    let
      outputTable = newUnicodeTable()
      validsort   = @["type", "format", "date", "uuid", "name", "path"]
    var
      columns = newSeq[string]()
      artifacts = newSeq[QiimeArtifact]()
      files = newSeq[string]()
      force = args["--force"]
      rawtable = args["--rawtable"]
      separator = if $args["--separator"] == "tab": "\t"
                  else: $args["--separator"]

      sortby = if $args["--sortby"] in validsort: $args["--sortby"]
               else: "type"
    # Configure output columns
    if args["--uuid"] or args["--all"] or args["--rawtable"]:
      columns.add("uuid")

    if args["--abs"]:
      columns.add("abspath")
    elif args["--basename"]:
      columns.add("basename")
    else:
      columns.add("path")

    if args["--datetime"] or args["--all"] or args["--rawtable"]:
      columns.add("date")

    columns.add("format")
    columns.add("type")

    if args["--all"] or args["--rawtable"]:
      columns.add("version")

    if args["--all"] or args["--rawtable"]:
      columns.add("files")

    # Scan input files passed via CLI arguments: create a "files" list
    for file in args["<inputfile>"]:
      # check existence
      if not fileExists(file) and not symlinkExists(file):
        if verbose:
          stderr.writeLine("Skipping \"", file, "\": not found, or not a file")
        continue
      if force == false:
        let (dir, name, ext) = splitFile(file)
        if ext != ".qza" and ext != ".qzv":
          if verbose:
            stderr.writeLine("Skipping \"", $dir, "/", $name, "\": extension (", $ext, ") not valid (use --force)")
          continue
      files.add(file)

    # Check at least one file was added
    if len(files) == 0:
      stderr.writeLine("No file was found (check with --verbose)")
      quit(0)

    # Scan files and populate "artifacts"
    for file in files:
      try:
        let
          dataFiles = getDataFiles(file)
          art = readArtifact(file)

        let dataString = if len(dataFiles) > 1: $len(dataFiles) & " files"
                        else: dataFiles[0]


        if verbose:
          stderr.writeLine(getID(file), separator, file , separator, dataString)
          stderr.writeLine($art)
        
        artifacts.add(art)
      except Exception as e:
        stderr.writeLine("ERROR: Unable to read artifact ", file, " (skipping):\n", e.msg)
    
    # Sort artifacts
    if sortby == "type":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.artifacttype, y.artifacttype)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )
    elif sortby == "date":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.date, y.date)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )
    elif sortby == "format":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.format, y.format)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )
    elif sortby == "uuid":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.uuid, y.uuid)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )
    elif sortby == "name":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.basename, y.basename)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )
    elif sortby == "path":
      artifacts.sort(
        proc (x,y: QiimeArtifact): int =
        result = cmp(x.path, y.path)
        if result == 0:
            result = cmp(x.uuid, y.uuid)
        )

    # Prepare output
    if rawtable:
      if args["--header"]:
        let c = @["ID", "Path", "Type", "Format", "Version", "Date", "File"]
        echo "#", c.join(separator)
      for artifact in artifacts:
        printLine(artifact, columns, separator)
    else:
      outputTable.separateRows = false
      outputTable.setHeaders(generateHeader(columns))   
      for artifact in artifacts:
        outputTable.addRow(generateFields(artifact, columns))

      printTable(outputTable)

