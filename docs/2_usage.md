---
sort: 2
permalink: /usage
---
# Usage

**This is the development draft for the Contest API. See also [the
version that will be used at WF 2020](Contest_API_2020).**

```note
TODO: Remove/replace broken links.
```


## :page_facing_up: list


* See [**qax list** full documentation](docs/list.md)

This is the default module, and can be used to list the properties of one or more artifacts.

Some features:
* Supports multiple files at once
* 100X times faster than Qiime2
* Can be used to find an artifact given the ID

Example:
```
qax_mac -b -u input/*.*
┌───────────────────────────┬────────────────┬─────────────────────────┬─────────────────────────────┐
│ ID                        │ Basename       │ Type                    │ Format                      │
├───────────────────────────┼────────────────┼─────────────────────────┼─────────────────────────────┤
│ bb1b2e93-...-2afa2110b5fb │ rep-seqs.qza   │ FeatureData[Sequence]   │ DNASequencesDirectoryFormat │
│ 313a0cf3-...-befad4ebf2f3 │ table.qza      │ FeatureTable[Frequency] │ BIOMV210DirFmt              │
│ 35c32fe7-...-85ef27545f00 │ taxonomy.qzv   │ Visualization           │ HTML                        │
└───────────────────────────┴────────────────┴─────────────────────────┴─────────────────────────────┘
```

## :page_facing_up: extract


* See [**qax extract** full documentation](docs/extract.md)

This program extract the content of an artifact. By default, if a single file is present it will be extracted in the specified path. If multiple files are present, a directory containing them will be created instead.

_Example:_
```
# Extract representative sequences (will be called rep-seqs.fasta)
qax x -o ./ rep-seqs.qza

# Extract a visualization (a folder called "taxonomy" will be created)
qax x -o ./ taxonomy.qzv
```

## :page_facing_up: citations

* See [**qax citations** full documentation](docs/cite.md)

Each Qiime module provides the citations for the software and resources that it uses, storing the citations in BibTeX format inside the artifacts. The cite module allows to extract all the citations from a list of artifacts, removing the duplicates, thus effectively allowing to prepare the bibliography for a complete Qiime2 analysis.

_Example:_
```
qax c files/*.qza > bibliography.bib
```

## :page_facing_up: provenance

* See [**qax provenance** full documentation](docs/provenance.md)

This program allows to print the provenance of an artifact, or to produce a [publication grade graph](docs/qax-provenance.png) of the provenance.

_Example:_
```
# To view a summary
qax p taxonomy.qzv

# To save the plot
qax p -o graph.dot taxonomy.qza
```


## :page_facing_up: view

* See [**qax view** full documentation](docs/view.md)

This program allows to print the content of an artifact data file to the terminal.
If the artifact contains a single file, it will be printed. Otherwise the user can specify one or multiple files to be printed, and if none
is specified, a list of files will be printed.

```
# Example: count the number of representative sequences
qax view rep-seqs.qza | grep -c '>'
```
