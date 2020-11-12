
import strformat
import tables, strutils
from os import fileExists
import docopt
import ./qax_utils


proc list(argv: var seq[string]): int =
    let args = docopt("""
Usage: list [options] [<inputfile> ...]

Options:
  -s, --separator SEP    Separator [default: tab]
  -f, --force            Accept non standard extensions
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    var
      files = newSeq[string]()
      force = args["--force"]
      separator = if $args["--separator"] == "tab": "\t"
                  else: $args["--separator"]

    for file in args["<inputfile>"]:
      # check existance
      if not fileExists(file) and not symlinkExists(file):
        if verbose:
          stderr.writeLine("Skipping ", file, ": not found, or not a file")
        continue
      if not force:
        let (dir, name, ext) = splitFile(file)
        if ext != ".qza" and ext != ".qzv":
          if verbose:
            stderr.writeLine("Skipping ", file, ": extension (", ext, ") not valid (use --force)")
          continue

      files.add(file)

    for file in files:
      let
        dataFiles = getDataFiles(file)
        art = readArtifact(file)

      let dataString = if len(dataFiles) > 1: $len(dataFiles) & " files"
                      else: dataFiles[0]

      echo getID(file), separator, file , separator, dataString
      echo $art
