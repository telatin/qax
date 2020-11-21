# :package: Qiime2 Artifact eXtractor

[![Build Status](https://travis-ci.org/telatin/qax.svg?branch=main)](https://travis-ci.org/telatin/qax)
[![Repository Size](https://img.shields.io/github/languages/code-size/telatin/qax)](https://github.com/telatin/qax)
[![Latest release](https://img.shields.io/github/v/release/telatin/qax)](https://github.com/telatin/qax/releases)
[![Available via BioConda](https://img.shields.io/conda/vn/bioconda/qax)](https://bioconda.github.io/recipes/qax/README.html)
[![BioConda Downloads](https://img.shields.io/conda/dn/bioconda/qax)](https://bioconda.github.io/recipes/qax/README.html)

## :book: Introduction

<img alt="qax logo" align="right" width="333" height="153" src="https://raw.githubusercontent.com/telatin/qax/main/docs/qax.png">

Qiime2 is one of the most popular software used to analyze the output of metabarcoding experiment, and it introduced a unique data format in the bioinformatics scenario: the “_Qiime2 artifact_”.

Qiime2 artifacts are structured compressed archives containing a dataset (_e.g._, FASTQ reads, representative sequences in FASTA format, a phylogenetic tree in Newick format, etc.) and an exhaustive set of metadata (including the command that generated it, information on the execution environment, citations on the used software, and all the metadata of the artifacts used to produce it). 

While artifacts can improve the shareability and reproducibility of Qiime workflows, they are less easily integrated with general bioinformatics pipelines, and even accessing metadata in the artifacts requires the full Qiime2 installation (not to mention that every release of Qiime2 will produce incompatible artifacts). Qiime Artifact Extractor (qxa) allows to easily interface with Qiime2 artifacts from the command line, without needing the full Qiime2 environment installed. 


## :floppy_disk: Download and installation

Pre-compiled binaries are the fastest and easiest way to get _qax_. To get the latest version, 
use the following command, otherwise check the [stable releases](https://github.com/telatin/qax/releases).  ![https://img.shields.io/github/downloads/telatin/qax/total?color=teal&label=GitHub%20downloads&logoColor=silver]


```
# From linux
wget "https://github.com/telatin/qax/raw/main/bin/qax"
chmod +x qax

# From macOS
wget -O qax "https://github.com/telatin/qax/raw/main/bin/qax_mac"
chmod +x qax
```

Alternatively, you can install _qax_ from BioConda, if you have _conda_ installed:
```
conda install -c bioconda qax
```

## :book: Usage

`qax` has four subprograms (general syntax is `qax [program] [program-arguments]`):

- **list** (default): list artifact(s) properties
- **citations**: extract citations in BibTeX format
- **extract**: extract artifact _data_ files
- **provenance**: describe artifact provenance, or generate its graph
- **view**: print the content of an artifact (eg. dna-sequences.fasta) to the terminal


### :page_facing_up: list


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

### :page_facing_up: extract


* See [**qax extract** full documentation](docs/extract.md)

This program extract the content of an artifact. By default, if a single file is present it will be extracted in the specified path. If multiple files are present, a directory containing them will be created instead.

### :page_facing_up: citations

* See [**qax citeations** full documentation](docs/cite.md)

Each Qiime module provides the citations for the software and resources that it uses, storing the citations in BibTeX format inside the artifacts. The cite module allows to extract all the citations from a list of artifacts, removing the duplicates, thus effectively allowing to prepare the bibliography for a complete Qiime2 analysis.

### :page_facing_up: provenance

* See [**qax provenance** full documentation](docs/provenance.md)

This program allows to print the provenance of an artifact, or to produce a [publication grade graph](docs/qax-provenance.png) of the provenance.


### :page_facing_up: view

* See [**qax view** full documentation](docs/view.md)

This program allows to print the content of an artifact data file to the terminal.
If the artifact contains a single file, it will be printed. Otherwise the user can specify one or multiple files to be printed, and if none
is specified, a list of files will be printed.

```
# Example: count the number of representative sequences
qax view rep-seqs.qza | grep -c '>'
```
