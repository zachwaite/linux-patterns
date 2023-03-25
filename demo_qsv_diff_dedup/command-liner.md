# qsv diff & qsv dedup - 2023-03-24

## tldr;

`qsv diff` and `qsv dedup` are utilities for performing set operations on csv
files. `diff` will allow you to find rows that differ between two csvs, where
equality is determined by a set of fields you supply. `dedup` will deduplicate
rows of a csv file, but does not let you specify keys. Nonetheless, this can be
useful for performing a set union on csv files.

## Example

# diff two csv files

```bash
qsv diff ./small1.csv ./small2.csv --primary-key-idx 0,1,2

# One line is available in small2 but not in small1
# diffresult,city,state,country
# +,hartford,ny,us

qsv diff ./ordered1.csv ./ordered2.csv --primary-key-idx 0,1,2

# Order is not considered, only presence/absence
# diffresult,city,state,country
```

# dedup a single csv file

```bash
qsv dedup ./diamonds1.csv > ./diamonds_deduped.csv

# removed 146 duplicates
# 53795 lines remain
```

# union two csv files

Stack the csvs using `qsv cat rows`, then dedup to achieve a set union.

```bash
qsv cat rows diamonds1.csv diamonds2.csv | qsv dedup > diamonds_set_union.csv
wc -l diamonds_set_union.csv

# 53796 lines remain
```

## Links

- [qsv](https://github.com/jqnatividad/qsv)
