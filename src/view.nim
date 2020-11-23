import zip/zipfiles
import tables, strutils, algorithm
import os
import docopt
import ./qax_utils
 


proc view(argv: var seq[string]): int =
    let args = docopt("""
Usage: view [options] <inputfile> [<datafile>...]

View (a la `cat`) the content of data files in one artifact.

Options:
  -f, --force            Accept artifact with non caninical extension
  -v, --verbose          Verbose output
  -h, --help             Show this help

  """, version=version(), argv=argv)

    verbose = args["--verbose"]
    let
      force = args["--force"]
      datafiles = args["<datafile>"]
 
   
      
    
    # check existence
    if not fileExists($args["<inputfile>"]) and not symlinkExists($args["<inputfile>"]):
      if verbose:
        stderr.writeLine("Skipping ", $args["<inputfile>"], ": not found, or not a file")
        quit(1)
      if force == false:
        let (dir, name, ext) = splitFile($args["<inputfile>"])
        if ext != ".qza" and ext != ".qzv":
          if verbose:
            stderr.writeLine("Skipping ", $dir, "/", $name, ": extension (", $ext, ") not valid (use --force)")
          quit(1)
      

 


    # At the moment supports a single file
    for file in @[ $args["<inputfile>"] ]:
      var z: ZipArchive
      if not z.open(file):
        stderr.writeLine("Unable to re-open: ", file, ". Unexpected error, terminating.")
        quit(2)
      
      var
        art: QiimeArtifact
      try:
        art = readArtifact(file)
      except Exception as e:
        stderr.writeLine("ERROR: Unable to extract artifact ", file, " (skipping):\n  ", e.msg)
        quit(1)



      if len(art.data) > 1:
        # Multiple files are present in data (eg: fastq reads or visualization)
        if len(datafiles) > 0:
          for datafile in datafiles:
            if datafile notin art.data:
              stderr.writeLine("# WARNING: Skipping ", datafile, ": not found")
              continue
            stderr.writeLine("# Processing: ", datafile)
            try:
              echo readFileFromZip(file, joinPath(art.uuid, joinPath("data", datafile)))
            except Exception as e:
              stderr.writeLine(datafile, " not found or not readable: ", e.msg)
              quit(1)
        else:
          stderr.writeLine("Multiple files in this artifact:")
          for f in art.data:
            stderr.writeLine("- ", f)
      elif len(art.data) == 1:
        # A single file (eg: dna-sequences.fasta) is stored in /data
        echo readFileFromZip(file, joinPath(art.uuid, joinPath("data", art.data[0])))
      else:
        stderr.writeLine("Skipping ", art.basename, ": no data found.")
 