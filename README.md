# :package: Qiime2 Artifact eXtractor

[![Build Status](https://travis-ci.org/telatin/qax.svg?branch=main)](https://travis-ci.org/telatin/qax)
![Repository Size](https://img.shields.io/github/languages/code-size/telatin/qax)
[![Latest release](https://img.shields.io/github/v/release/telatin/qax)](https://github.com/telatin/qax/releases)

## :book: Introduction

Qiime2 is one of the most popular software used to analyze the output of metabarcoding experiment, and it introduced a unique data format in the bioinformatics scenario: the “_Qiime2 artifact_”.

Qiime2 artifacts are structured compressed archives containing a dataset (_e.g._, FASTQ reads, representative sequences in FASTA format, a phylogenetic tree in Newick format, etc.) and an exhaustive set of metadata (including the command that generated it, information on the execution environment, citations on the used software, and all the metadata of the artifacts used to produce it). 

While artifacts can improve the shareability and reproducibility of Qiime workflows, they are less easily integrated with general bioinformatics pipelines, and even accessing metadata in the artifacts requires the full Qiime2 installation (not to mention that every release of Qiime2 will produce incompatible artifacts). Qiime Artifact Extractor (qxa) allows to easily interface with Qiime2 artifacts from the command line, without needing the full Qiime2 environment installed. 

## :book: Usage

`qax` has four subprograms:

```text
qax [program] [arguments]
```

```
QAX - Qiime2 Artifact eXtractor

	• citations, c        : extract citations
	• extract, x          : extract artifact files
	• list (default)      : list artifact(s) properties
	• provenance, p       : get artifacts provenance

```

### `qax list`

This is the default module, and can be used to list the properties of one or more artifacts.

```
qax [list] [options] artifact1 [artifact2...]


Options:
  -a, --abspath          Show absolute paths [default: false]
  -b, --basename         Use basename instead of path [default: false]
  -d, --datetime         Show artifact's date time [default: false]
  -u, --uuid             Show uuid [default: false]
  -r, --rawtable         Don't print a Unicode table   
  -s, --sortby SORT      Column to sort (uuid, type, format, date) [default: ]
  -s, --separator SEP    Separator when using --rawtable [default: tab]
  -f, --force            Accept non standard extensions
  -v, --verbose          Verbose output
  -h, --help             Show this help
```

Example:
```
qax_mac  -b -u input/*.*
┌───────────────────────────┬────────────────┬─────────────────────────┬─────────────────────────────┐
│ ID                        │ Basename       │ Type                    │ Format                      │
├───────────────────────────┼────────────────┼─────────────────────────┼─────────────────────────────┤
│ bb1b2e93-...-2afa2110b5fb │ rep-seqs.qza   │ FeatureData[Sequence]   │ DNASequencesDirectoryFormat │
│ 313a0cf3-...-befad4ebf2f3 │ table.qza      │ FeatureTable[Frequency] │ BIOMV210DirFmt              │
│ 35c32fe7-...-85ef27545f00 │ taxonomy.qzv   │ Visualization           │ HTML                        │
└───────────────────────────┴────────────────┴─────────────────────────┴─────────────────────────────┘
```

### `qax extract`

This program extract the content of an artifact. By default, if a single file is present it will be extracted in the specified path. If multiple files are present, a directory containing them will be created instead.

### `qax citations`

Each Qiime module provides the citations for the software and resources that it uses, storing the citations in BibTeX format inside the artifacts. The cite module allows to extract all the citations from a list of artifacts, removing the duplicates, thus effectively allowing to prepare the bibliography for a complete Qiime2 analysis.

### `qax provenance`

This program allows to print the provenance of an artifact.
