
import strformat
import tables, strutils, times, algorithm, terminaltables
from os import fileExists
import docopt
import ./qax_utils
 


proc cite(argv: var seq[string]): int =
    let args = docopt("""
Usage: list [options] [<inputfile> ...]

Options:
  -a, --abspath          Show absolute paths [default: false]
  --all                  Show all fields [default: false]
  -b, --basename         Use basename instead of path [default: false]
  -d, --datetime         Show artifact's date time [default: false]
  -u, --uuid             Show uuid [default: false]
  -r, --rawtable         Don't print a Unicode table   
  -s, --sortby SORT      Column to sort (uuid, type, format, date) [default: ]
  -s, --separator SEP    Separator when using --rawtable [default: tab]
  -f, --force            Accept non standard extensions
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    let
      outputTable = newUnicodeTable()
    var
      columns = newSeq[string]()
      artifacts = newSeq[QiimeArtifact]()
      files = newSeq[string]()
      force = args["--force"]
      rawtable = args["--rawtable"]
      separator = if $args["--separator"] == "tab": "\t"
                  else: $args["--separator"]

    # Configure output columns
    if args["--uuid"] or args["--all"]:
      columns.add("uuid")

    if args["--abspath"]:
      columns.add("abspath")
    elif args["--basename"]:
      columns.add("basename")
    else:
      columns.add("path")

    if args["--datetime"] or args["--all"]:
      columns.add("date")

    columns.add("format")
    columns.add("type")

    # Scan input files passed via CLI arguments: create a "files" list
    for file in args["<inputfile>"]:
      # check existence
      if not fileExists(file) and not symlinkExists(file):
        if verbose:
          stderr.writeLine("Skipping ", file, ": not found, or not a file")
        continue
      if force == false:
        let (dir, name, ext) = splitFile(file)
        if ext != ".qza" and ext != ".qzv":
          if verbose:
            stderr.writeLine("Skipping ", $dir, "/", $name, ": extension (", $ext, ") not valid (use --force)")
          continue
      files.add(file)

    # Check at least one file was added
    if len(files) == 0:
      stderr.writeLine("No files specified / found.")
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
    
 