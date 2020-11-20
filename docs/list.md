# qax list

This is the default subprogram.

### Synopsis:

```
Usage: list [options] [<inputfile> ...]

Options:
  -a, --all              Show all fields [default: false]
  --abs                  Show absolute paths [default: false]
  -b, --basename         Use basename instead of path [default: false]
  -s, --sortby SORT      Column to sort (uuid, type, format, date) [default: type]
  -f, --force            Accept non standard extensions
  --verbose              Verbose output
  --help                 Show this help

Nice output (default):
  -d, --datetime         Show artifact's date time [default: false]
  -u, --uuid             Show uuid [default: false]

Raw table output:
  -r, --rawtable         Print a CSV table (-s) with all fields [default: false]   
  -h, --header           Print header [default: false]
  -z, --separator SEP    Separator when using --rawtable [default: tab]
```

This is the default module, so its name can be omitted. This means that the following two commands are equivalent:

```
qxa list directory/*.qza
qxa directory/*.qza
```

### File path

By default the file path will be printed as received by the program. Witht `-b` (`--basename`) the basename will be printed instead,
and wiht `--abs` the absolute path.

### Output

The program will prepare a table with the artifacts metadata, supporting a nice Unicode table (default) or a raw computer-friendly tabular
output (enabled with `-r`). 

#### Nice (Unicode) table

By default, only _path_, _type_ and _format_ of the artifact are printed:
```
┌────────────────────┬───────────────────────┬─────────────────────────────┐
│ Path               │ Type                  │ Format                      │
├────────────────────┼───────────────────────┼─────────────────────────────┤
│ input/rep-seqs.qza │ FeatureData[Sequence] │ DNASequencesDirectoryFormat │
│ input/taxonomy.qzv │ Visualization         │ HTML                        │
└────────────────────┴───────────────────────┴─────────────────────────────┘
```

With `-u` the UUID is added, with `-d` the generation timestamp is added. 
With `-a` all fields are printed:

```
┌──────────────────────────────────────┬──────────────┬───────────────────────┬─────────────────────────────┬───────────┬──────────────────┬───────┐
│ ID                                   │ Basename     │ Type                  │ Format                      │ Version   │ Date             │ Files │
├──────────────────────────────────────┼──────────────┼───────────────────────┼─────────────────────────────┼───────────┼──────────────────┼───────┤
│ bb1b2e93-0c45-4c8e-a140-2afa2110b5fb │ rep-seqs.qza │ FeatureData[Sequence] │ DNASequencesDirectoryFormat │ 2019.10.0 │ 2020-11-12;17:23 │ 1     │
│ 35c32fe7-3eb5-4b31-aa34-85ef27545f00 │ taxonomy.qzv │ Visualization         │ HTML                        │ 2019.10.0 │ 2020-11-12;17:23 │ 18    │
└──────────────────────────────────────┴──────────────┴───────────────────────┴─────────────────────────────┴───────────┴──────────────────┴───────┘
```

#### Raw tabular output

With the raw tabular output all the fields are printed, to allow easier parsing. By default the fields are separated by tabs, but a different
separator can be specified (`-s SEP`).

The fields are:
1. UUID (_e.g._ b1b2e93-0c45-4c8e-a140-2afa2110b5fb)
2. File path (_e.g._ rep-seqs.qza)
3. Artifact Type (_e.g._ FeatureData[Sequence])
4. Artifact Format (_e.g._ DNASequencesDirectoryFormat)
5. Qiime2 Version (_e.g._ 2019.10.0)
6. Timestamp (_e.g._ 2020-11-12;17:23 )
7. Data files contained (_e.g._ 1)


### Usage examples

To find an artifact given the ID:

```
find ${PATH_TO_SCAN} -name "*.qz?" | xargs qxa | grep ${UUID}
```

### Performance

Using _hyperfine_ to compare the performance with Qiime2:

```
hyperfine --export-markdown docs/list_speed.md "qiime tools peek input/taxonomy.qzv" "./bin/qax input/taxonomy.qzv" 
```


| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:---|---:|---:|---:|---:|
| `qiime tools peek input/taxonomy.qzv` | 1.981 ± 0.056 | 1.925 | 2.087 | 109.58 ± 34.30 |
| `./bin/qax input/taxonomy.qzv` | 0.018 ± 0.006 | 0.011 | 0.031 | 1.00 |
