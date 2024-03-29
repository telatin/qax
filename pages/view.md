# qax view

This subprogram will print the BibTeX citations (deduplicated) from a list of files.
Can be abbreviated with **c** (_e. g._, `qax c ...`).

### Synopsis:

```
Usage: view [options] <inputfile> [<datafile>...]

View (a la `cat`) the content of data files in one artifact.

Options:
  -f, --force            Accept artifact with non caninical extension
  -v, --verbose          Verbose output
  -h, --help             Show this help
```

### Single file artifacts
Example:
```
qax view rep-seq.qza | grep -c '>'
```

### Artifact with multiple files

The file (or files) to extract have to be specified:

```
qax view taxonomy.qzv index.html | grep -c "body"
```