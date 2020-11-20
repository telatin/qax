| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./bin/qax_mac input/*` | 15.4 ± 6.6 | 8.4 | 29.3 | 1.00 |
| `for i in input/*; do qiime tools peek $i; done` | 4849.7 ± 306.8 | 4479.2 | 5297.2 | 315.62 ± 136.68 |
