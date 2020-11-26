---
sort: 1
permalink: /installation
---

# Installation

## Pre-compiled binaries

Pre-compiled binaries are the fastest and easiest way to get _qax_. To get the latest version,
use the following command, otherwise check the [stable releases](https://github.com/telatin/qax/releases).  


```
# From linux
wget "https://github.com/telatin/qax/raw/main/bin/qax"
chmod +x qax

# From macOS
wget -O qax "https://github.com/telatin/qax/raw/main/bin/qax_mac"
chmod +x qax
```

## Install via Miniconda

```note
Miniconda installation has been tested on MacOS and Linux, but being _qax_ a single binary, if the precompiled works for you we recommend it.
```

Alternatively, you can install _qax_ from BioConda, if you have _conda_ installed:

```
conda install -c conda-forge -c bioconda qax
```


