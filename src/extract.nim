import strformat
import zip/zipfiles
import tables, strutils, algorithm, terminaltables
import os
import docopt
import ./qax_utils
 


 
proc extract(argv: var seq[string]): int =
    let args = docopt("""
Usage: extract [options] [<inputfile> ...]

Extract the artifact data

Options:
  -o, --outdir DIR       Output directory [default: .]
  -f, --force            Overwrite existing output files [default: false]  
  -k, --keepname         Keep original file names instead of using artifact's basename [default: false]
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]

    let
      outputTable = newUnicodeTable()
      keepOriginalName = args["--keepname"]
      force = args["--force"]
    var
      columns = newSeq[string]()
      artifacts = newSeq[QiimeArtifact]()
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
      stderr.writeLine("No files were found.")
      quit(1)
    
    # Check output directory

    if not dirExists($args["--outdir"]):
      stderr.writeLine("FATAL ERROR: Output directory not found: ", $args["--outdir"])
      quit(1)

    # Scan files and populate "artifacts"
    for file in files:
      var z: ZipArchive
      if not z.open(file):
        stderr.writeLine("Unable to re-open: ", file, ". Unexpected error, terminating.")
        quit(2)
      
      try:
        let
          art = readArtifact(file)
        
        if len(art.data) > 1:
          stderr.writeLine("Not implemented")

        elif len(art.data) == 1:
          let
            (dir, name, ext) = splitFile(art.data[0])
            (adir, aname, aext) = splitFile(file)
          var destFile = if keepOriginalName == true: art.data[0]
            else: aname & ext
          let
            data = joinPath(art.uuid, joinPath("data", art.data[0]))
            dest = joinPath($args["--outdir"], destFile)
          if verbose:
            stderr.writeLine("Extracting ", data, " -> ", dest)
          z.extractFile(data, dest)
        else:
          stderr.writeLine("Skipping ", art.basename, ": no data found.")
      except Exception as e:
        stderr.writeLine("ERROR: Unable to read artifact ", file, " (skipping):\n", e.msg)
    
 