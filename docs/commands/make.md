---
sort: 4
---

# Make

## Synopsis

```
Usage: make [options] [-a attr]... -o <artifact.qzv> <inputdirectory>

Create a Qiime Visualization Artifact from a directory with files.
By default, will create a "Visualization", thus requiring an "index.html"
file in the root of the input directory.

Options:
  -o, --output <FILE>    Output artifact (required)
  -u, --uuid <UUID>      Specify a UUID (otherwise autogenerated)
  -f, --force            Overwrite output artifact [default: true]
  -t, --tempdir <DIR>    Temporary directory [default: /var/folders/qf/64kyljyn0njdfbz8nyrgjv8h000cb1/T/]
  -v, --verbose          Verbose output
  -h, --help             Show this help

Attributes:
  --format FORMAT        Artifact format [default: HTML[Report]]
  --type TYPE            Artifact type [default: Visualization]
  --version VERSION      Artifact framework version [default: 2019.10.0]
  --archive ARCHIVE      Artifact archive version [default: 5]
  -a, --attr ATTR...     Artifact metadata attribute (key=value)
```