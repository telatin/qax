# QAX: the Qiime2 Artifacts eXtractor


[![Build Status](https://travis-ci.com/telatin/qax.svg?branch=main)](https://travis-ci.com/telatin/qax)
[![Repository Size](https://img.shields.io/github/languages/code-size/telatin/qax)](https://github.com/telatin/qax)
[![Latest release](https://img.shields.io/github/v/release/telatin/qax)](https://github.com/telatin/qax/releases)
[![Available via BioConda](https://img.shields.io/conda/vn/bioconda/qax)](https://bioconda.github.io/recipes/qax/README.html)
[![BioConda Downloads](https://img.shields.io/conda/dn/bioconda/qax)](https://bioconda.github.io/recipes/qax/README.html)

- Website: <https://telatin.github.io/qax/>
- Github: <https://github.com/telatin/qax>
- Paper: <https://doi.org/10.3390/biotech10010005>

## Introduction

<img alt="qax logo" align="right" width="333" height="153" src="https://raw.githubusercontent.com/telatin/qax/main/pages/qax.png">

Qiime2 is one of the most popular software used to analyze the output of metabarcoding experiment, and it introduced a unique data format in the bioinformatics scenario: the “_Qiime2 artifact_”.

Qiime2 artifacts are structured compressed archives containing a dataset (_e.g._, FASTQ reads, representative sequences in FASTA format, a phylogenetic tree in Newick format, etc.) and an exhaustive set of metadata (including the command that generated it, information on the execution environment, citations on the used software, and all the metadata of the artifacts used to produce it).

While artifacts can improve the shareability and reproducibility of Qiime workflows, they are less easily integrated with general bioinformatics pipelines, and even accessing metadata in the artifacts requires the full Qiime2 installation (not to mention that every release of Qiime2 will produce incompatible artifacts). Qiime Artifact Extractor (qxa) allows to easily interface with Qiime2 artifacts from the command line, without needing the full Qiime2 environment installed.

## Functions


`qax` has different subprograms (and the general syntax is `qax [program] [program-arguments]`):

- **list** (default): list artifact(s) properties
- **citations**: extract citations in BibTeX format
- **extract**: extract artifact _data_ files
- **provenance**: describe artifact provenance, or generate its graph
- **view**: print the content of an artifact (eg. dna-sequences.fasta) to the terminal
- **make**: create a visualization artifact from HTML

## Citation

Telatin, A. **Qiime Artifact eXtractor (qax): A Fast and Versatile Tool to Interact with Qiime2 Archives.** BioTech [doi.org/10.3390/biotech10010005](https://doi.org/10.3390/biotech10010005)
