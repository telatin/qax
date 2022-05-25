---
sort: 1
---

# List

## Synopsis

```
Usage: list [options] [<inputfile> ...]

Options:
  --abs                  Show absolute paths [default: false]
  -a, --all              Show all fields [default: false]
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

## Examples

To list a set of artifacts data:
```bash
qax list input/*.qz?
```

Will produce:
```text
┌────────────────────┬─────────────────────────┬─────────────────────────────┐
│ Path               │ Type                    │ Format                      │
├────────────────────┼─────────────────────────┼─────────────────────────────┤
│ input/rep-seqs.qza │ FeatureData[Sequence]   │ DNASequencesDirectoryFormat │
│ input/table.qza    │ FeatureTable[Frequency] │ BIOMV210DirFmt              │
│ input/taxonomy.qzv │ Visualization           │ HTML                        │
└────────────────────┴─────────────────────────┴─────────────────────────────┘
```

Adding `--all`  and `--basename` to print all fields, and showing only the filename of the artifacts:
```
┌──────────────────────────────────────┬──────────────┬─────────────────────────┬─────────────────────────────┬───────────┬──────────────────┬───────┐
│ ID                                   │ Basename     │ Type                    │ Format                      │ Version   │ Date             │ Files │
├──────────────────────────────────────┼──────────────┼─────────────────────────┼─────────────────────────────┼───────────┼──────────────────┼───────┤
│ bb1b2e93-0c45-4c8e-a140-2afa2110b5fb │ rep-seqs.qza │ FeatureData[Sequence]   │ DNASequencesDirectoryFormat │ 2019.10.0 │ 2022-05-13;14:26 │ 1     │
│ 313a0cf3-e2ec-48cf-95af-befad4ebf2f3 │ table.qza    │ FeatureTable[Frequency] │ BIOMV210DirFmt              │ 2019.10.0 │ 2022-05-13;14:26 │ 1     │
│ 35c32fe7-3eb5-4b31-aa34-85ef27545f00 │ taxonomy.qzv │ Visualization           │ HTML                        │ 2019.10.0 │ 2022-05-13;14:26 │ 18    │
└──────────────────────────────────────┴──────────────┴─────────────────────────┴─────────────────────────────┴───────────┴──────────────────┴───────┘
```