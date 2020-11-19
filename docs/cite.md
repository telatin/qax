# qax citations

This subprogram will print the BibTeX citations (deduplicated) from a list of files.

### Synopsis:

```
Usage: citations [options] [<inputfile> ...]

Options:
  -o, --output FILE      Save BibTeX citation to FILE
  -r, --recurse-parents  Retrieve BibTeX citations also from parents
  -f, --force-artifacts  Try to parse artifacts with non canonical extensions
  -v, --verbose          Verbose output
  -h, --help             Show this help
```

#### Recurse

By default only the citations for the given artifacts are printed. This means that feeding all the artifacts used for a specific
analysis will print the full bibliography:

```
qax citations  -o bibliography.bib /path/to/*.qz*
```

Since each artifact also contains the bibliography used to generate its parent artifacts, one can also use _citations_ in 
recursive mode to gather them:

```
qax citations  -r -o bibliography.bib /path/to/*.qz*
```

Since the citations are non redundant, there is no harm in using `-r` in any case.


### Performance


Using _hyperfine_ to compare the performance with Qiime2:

```
hyperfine --export-markdown docs/list_speed.md "qiime tools citations input/taxonomy.qzv" "./bin/qax citations input/taxonomy.qzv" 
```

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./bin/qax citations input/taxonomy.qzv` | 20.3 ± 8.4 | 8.5 | 31.4 | 1.00 |
| `qiime tools citations  input/taxonomy.qzv` | 2616.7 ± 115.1 | 2476.7 | 3014.3 | 128.69 ± 53.76 |
