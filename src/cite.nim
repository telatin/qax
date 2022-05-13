
 
import tables, strutils, times, algorithm, terminaltables
import os
import docopt
import ./qax_utils
 
proc dereplicateTeX(bib: string): string =
  if len(bib) == 0:
    return ""

  var
    lines = bib.split("\n")
    articles = initTable[string, string]()
    buffer = ""
    title = ""

  lines.add("@")
  try:
    for line in lines:
      if len(line) >= 1 and line[0] == '@':
        if len(title) > 0:
          articles[title] = buffer
        buffer = line & "\n"
        title = line
      else:
        buffer &= line & "\n"
  except Exception as e:
    stderr.writeLine "Unable to dereplicate bibtex: " & e.msg
    return bib

  try:
    for header in articles.keys:
      result &= articles[header]
  except Exception as e:
    stderr.writeLine "Unable to dereplicate bibtex: " & e.msg
    return bib

proc cite(argv: var seq[string]): int =
    let args = docopt("""
Usage: citations [options] [<inputfile> ...]

Options:
  -o, --output FILE      Save BibTeX citation to FILE
  -r, --recurse-parents  Retrieve BibTeX citations also from parents
  -f, --force-artifacts  Try to parse artifacts with non canonical extensions
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]
    let
      force = args["--force-artifacts"]
      recurse = args["--recurse-parents"]
 
    var
       files = newSeq[string]()

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

    # Prepare list
    var
      bibliographyRaw = ""
    # Scan files and populate "artifacts"
    for file in files:
      try:
        let
          art = readArtifact(file)
        if verbose:
          stderr.writeLine($art)
        
        let 
          biblioFile = joinPath(art.uuid, "provenance/citations.bib")
          bibliography = readFileFromZip(file, biblioFile)
        
        bibliographyRaw &= bibliography

        if args["--recurse-parents"]:
          for parent in art.parents:
            try:
              let
                biblioFile = joinPath(art.uuid, joinPath("provenance/artifacts", joinPath(parent, "citations.bib")))
                bibliography = readFileFromZip(file, biblioFile)
              bibliographyRaw &= bibliography
            except Exception as e:
              stderr.writeLine("ERROR: Unable to recurse artifact ", file, " at ", parent)
      except Exception as e:
        stderr.writeLine("ERROR: Unable to read artifact ", file, " (skipping):\n", e.msg)
    
    
    let text = dereplicateTeX(bibliographyRaw)
    if args["--output"]:
      try:
        writeFile($args["--output"], text)
      except Exception as e:
        stderr.writeLine("[provenance] ERROR: Unable to write output to:" , $args["--output"])
        echo text
        quit(1)
    else:
      if len(text) > 1:
        stdout.writeLine( text )