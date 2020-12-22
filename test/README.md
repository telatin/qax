# Tests

- [QAX Documentation](https://telatin.github.io/qax)


## Test script

The `all.sh` script tests the all the basic functionalities of **qax**.

```
[0] Synopsis
     OK Help for 'list': found
     OK Help for 'citations': found
     OK Help for 'provenance': found
     OK Help for 'extract': found
     OK Help for 'make': found
[1] List
     OK list (no params)
     OK list (-b)
     OK list (-b -u)
     OK list (-r)
[2] Extract
     OK Extract single artifact
     OK Extract multiple files artifact
     OK Extract multiple files artifact (subdirectory)
[3] Citations
     OK 1 citation found in taxonomy.qzv
     OK 8 _total_ citations found in taxonomy.qzv
[4] Provenance
     OK 3 parents for taxonomy.qzv
     OK 1 child for taxonomy.qzv
     OK output graph found
     OK output graph has 7 nodes
[5] View
     OK 769 seqs for rep-seqs.qza
[6] Make
     OK created visualization artifact
     OK correct UUID used and found 6 times
```
