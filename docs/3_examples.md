---
sort: 3
permalink: /examples
---
# Usage examples

## Find artifact by UUID

If you know that an artifact has a specific UUID but do not know the exact location, you can
find it out combining `qax` with `find`.  

```
UUID="bb1b2e93-0c45-4c8e-a140-2afa2110b5fb"
find /path -name "*.qz?" | qax list -u  | grep $UUID
```

## Prepare the bibliography of a whole analysis

If we have a list of artifacts (_e. g._, `*.qz?`) we can extract the full bibliography and save it to file:
```
qax citations --output bibliography.bib *.qz?
```

## Check how many representative sequences have been produced

The _view_ subprogram will extract the main file and print it to the standard output, so we can combine 
it with [grep](https://linux.die.net/man/1/grep) to count how many lines have a ">" sign.t
```
qax view input/rep-seqs.qza | grep -c '>'
```
