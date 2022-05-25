---
sort: 3
---

# Provenance

## Synopsis

```text
```

## Example

To show the provenance of an artifact:
```bash
qax provenance input/taxonomy.qzv 
```

Output:
```text
environment:plugins:metadata
6e46b89a-0fcb-4a5f-860c-ec8ce26e7140    top     2020-01-24 09:01        reference_reads         [inputs: <none>]
ffdfda2e-be68-47f6-9bf5-07ccdd869689    top     2020-01-24 09:01        reference_taxonomy              [inputs: <none>]
71429e7c-6489-42d6-bbca-f4a6d9b85b48    |       2020-01-24 09:01        classifier              [inputs: 6e46b89a-0fcb-4a5f-860c-ec8ce26e7140;ffdfda2e-be68-47f6-9bf5-07ccdd869689;null]
a1ad1da7-8cc8-439b-bec5-c66a1125786f    top     2020-02-28 11:02        per_sample_sequences            [inputs: <none>]
3c984d76-82a7-4ff6-b64b-561834df9327    |       2020-02-28 11:02        demultiplexed_seqs              [inputs: a1ad1da7-8cc8-439b-bec5-c66a1125786f]
bb1b2e93-0c45-4c8e-a140-2afa2110b5fb    |       2020-02-28 13:02        reads           [inputs: 3c984d76-82a7-4ff6-b64b-561834df9327]
9df28153-4e38-44aa-bbc4-58a37d699580    |       2020-02-28 13:02        input           [inputs: bb1b2e93-0c45-4c8e-a140-2afa2110b5fb;71429e7c-6489-42d6-bbca-f4a6d9b85b48]
35c32fe7-3eb5-4b31-aa34-85ef27545f00    child   2020-02-28 13:02        visualization           [inputs: 9df28153-4e38-44aa-bbc4-58a37d699580:input.tsv]
```