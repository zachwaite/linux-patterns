# qsv select | qsv search | - 2023-03-10

## tldr;

`qsv` is a swiss army knife for working with delimited data. The `qsv select`
command allows you to select which csv fields to work on. Like it's sql
counterpart, `qsv select` can use field names as selectors, but can also use
indexes, index ranges and handle duplicate column names. `qsv search` provides
basic row filtering by using regexes.

## Example

Peek at the first 10 rows of specific columns in the diamonds dataset

```bash
head diamonds.csv | qsv select 'carat,cut,price' | qsv table

# Output
carat  cut        price
0.23   Ideal      326
0.21   Premium    326
0.23   Good       327
0.29   Premium    334
0.31   Good       335
0.24   Very Good  336
0.24   Very Good  336
0.26   Very Good  337
0.22   Fair       337
```

Select cut and price from diamonds.csv and filter for only cut='Ideal'. The
`--select` flag is a bit deceiving - it does not perform a select, but rather
limits the search to the fields specified by the select criteria.

```bash
qsv select 'cut,price' diamonds.csv | qsv search 'Ideal' --select 'cut' > somediamonds.csv
head somediamonds.csv | qsv table

# Output
cut    price
Ideal  326
Ideal  340
Ideal  344
Ideal  348
Ideal  403
Ideal  403
Ideal  403
Ideal  404
Ideal  404
```

Check the stats

```bash
qsv stats somediamonds.csv | qsv table

# Output
field  type     sum       min    max    range  min_length  max_length  mean      stddev     variance       nullcount  sparsity
cut    String             Ideal  Ideal         5           5                                               0          0
price  Integer  74513487  326    18806  18480  3           5           3457.542  3808.3128  14503246.4851  0          0
```

## Links

- [qsv](https://github.com/jqnatividad/qsv)
