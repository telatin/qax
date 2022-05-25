---
sort: 5
---

# List

## Synopsis

```
Usage: extract [options] [<inputfile> ...]

Extract the artifact data. If multiple files are present, a new directory
will be created (artifact name), otherwise the artifact name will be used
to rename the single file (unless -k is specified).

Options:
  -o, --outdir DIR       Output directory [default: .]
  -k, --keepname         Keep original file names instead of using artifact's basename [default: false]
  -v, --verbose          Verbose output
```
