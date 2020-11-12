import os
import sequtils
import strutils
import tables
import algorithm
import docopt
 

# Suite Version
import /qax_utils

# Subprograms

include /list

var progs = {
       "ls"  : list, "list" : list,

}.toTable

proc main() =

  var
    helps = {  "list (default)": "list artifact(s) properties",
               "extract (x)": "extract artifact files",
               "provenance": "get artifacts provenance",
               "citations (cit)": "extract citations",
               }.toTable


  var args = commandLineParams()
  if len(args) < 1: # or not progs.contains(args[0]):
    # no first argument: print help
    var
      hkeys1 = toSeq(keys(helps))


    sort(hkeys1, proc(a, b: string): int =
      if a < b: return -1
      else: return 1
      )

    echo format("QAX - Qiime2 Artifact eXtractor\nversion: $#\n", version())

    for k in hkeys1:
      echo format("	• $1: $2", k & repeat(" ", 20 - len(k)), helps[k])
    echo ""

    echo "\nAdd --help after each command to print usage"
  else:
    if not progs.contains(args[0]):
      quit(progs["ls"](args))
    else:
      var p = args[0]; args.delete(0)
      quit(progs[p](args))

when isMainModule:
  main()
