import zip/zipfiles
import streams
import  strutils, os, strformat
import yaml
import times
#[ Versions


> VERSION
QIIME 2
archive: 5
framework: 2019.10.0

> metadata.yaml
uuid: 313a0cf3-e2ec-48cf-95af-befad4ebf2f3
type: FeatureTable[Frequency]
format: BIOMV210DirFmt
]#

# Common variables for switches
var
   verbose*:        bool    # verbose mode
   check*:          bool    # enable basic checks


proc version*(): string =
  return "0.1.0"

type
  QiimeArtifact* = object
    uuid*:  string
    path*:string  
    filedate*: Time
    date*, time*: string
    artifacttype*,format*, version*, archive*: string
    data: seq[string]



proc echoVerbose*(msg: string, print: bool) =
  if print:
    stderr.writeLine(" * ", msg)




proc readFileFromZip(zipFileName, FileName: string): string =
  var
    z: ZipArchive
    stream: PZipFileStream
    line: string
  try:
    discard z.open(zipFileName)
    stream = z.getStream(FileName)
    while stream.readLine(line):
      result &= line & "\n"
  except Exception as e:
    stderr.writeLine("ERROR: Unable to open ", zipFileName, "\n", e.msg)
    discard

proc getDataFiles*(zipFileName: string): seq[string] =
  var z: ZipArchive
  if not z.open(zipFileName):
    return 
  else:
    for file in z.walkFiles:
      let parts = file.split('/')
      if parts[1] == "data":
        result.add(parts[2])


proc getID*(zipFileName: string): string =
  var z: ZipArchive
  if not z.open(zipFileName):
    return ""
  else:
    for file in z.walkFiles:
      let parts = file.split('/')
      let verFile = readFileFromZip(zipFileName, parts[0] & "/VERSION")
      if verFile[0 .. 4] == "QIIME":
        return parts[0]
      else:
        return ""

proc `$`*(f: QiimeArtifact): string = 
  return fmt"""
  File:     {f.path}
  Artifact: {f.uuid}
  Type:     {f.artifacttype}
  Format:   {f.format}
  files:    {f.data}"""

#[> VERSION
QIIME 2
archive: 5
framework: 2019.10.0

> metadata.yaml
uuid: 313a0cf3-e2ec-48cf-95af-befad4ebf2f3
type: FeatureTable[Frequency]
format: BIOMV210DirFmt

]#
proc readArtifact*(path: string): QiimeArtifact =
  var
    z: ZipArchive
    uuid = getID(path)
    abspath = absolutePath(path)

  result.uuid = uuid
  result.path = abspath
  result.data = getDataFiles(path)
  result.filedate = getLastAccessTime(path)
  result.date = format(result.filedate, "yyyy-MM-dd", utc())
  result.time = format(result.filedate, "HH:mm", utc())
  if not z.open(path):
    return 
  else:
    let
      version = readFileFromZip(path, uuid & "/VERSION")
      metadata = readFileFromZip(path, uuid & "/metadata.yaml")
    var
      versionLines = version.split("\n")
    versionLines.delete(0)
    
    let
      metaYaml = loadDOM(metadata)
      versionYaml = loadDOM(versionLines.join("\n"))

    try:
      result.version = versionYaml.root["framework"].content
      result.archive = versionYaml.root["archive"].content
    except Exception as e:
      stderr.writeLine("Unable to parse Artifact version: ", e.msg)

    try:
      result.artifacttype = metaYaml.root["type"].content
      result.format = if result.artifacttype == "Visualization" : "HTML"
                      else: metaYaml.root["format"].content
    except Exception as e:
      stderr.writeLine("Unable to parse Artifact metadata.yaml: ", e.msg)


      
    
proc getBasename*(filename: string): string =
  let  fileParse = splitFile(filename)

  if fileParse[2] == ".gz":
    let  gunzippedParse = splitFile(fileParse[1])
    return gunzippedParse[1]
  else:
    return fileParse[1]
  #( dir, filenameNoExt, extension) = splitFile(filename)
  #(sampleId, direction) = extractTag(filenameNoExt, pattern1, pattern2)

proc extractTag*(filename: string, patternFor: string, patternRev: string): (string, string) =
    if patternFor == "auto":
      # automatic guess
      var basename = split(filename, "_R1.")
      if len(basename) > 1:
        return (basename[0], "R1")
      basename = split(filename, "_R1_")
      if len(basename) > 1:
        return (basename[0], "R1")
      basename = split(filename, "_1.")
      if len(basename) > 1:
        return (basename[0], "R1")
    else:
      var basename = split(filename, patternFor)
      if len(basename) > 1:
        return (basename[0], "R1")

    if patternFor == "auto":
      # automatic guess
      var basename = split(filename, "_R2.")
      if len(basename) > 1:
        return (basename[0], "R2")
      basename = split(filename, "_R2_")
      if len(basename) > 1:
        return (basename[0], "R2")
      basename = split(filename, "_2.")
      if len(basename) > 1:
        return (basename[0], "R2")
    else:
      var basename = split(filename, patternFor)
      if len(basename) > 1:
        return (basename[0], "R2")

    return (filename, "SE")