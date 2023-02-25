# qsv stats | qsv table | less -S -

## tldr;

`qsv` takes over where `csvkit` left off as the top tool for working with csv.
The `qsv stats` command is a fast way to summarize a large dataset. Pipe to
`qsv table` to get an aligned table you visually review. Pipe to `less -S` to
prevent wrapping wide datasets. This is a great starting point when you receive
a new dataset.

## Example

Standard stats. This is very fast and efficient becuase it operates on streaming
data.

```sh
qsv stats diamonds.csv | qsv table

# output
field    type     sum        min   max        range  min_length  max_length  mean       stddev     variance       nullcount  sparsity
carat    Float    43040.87   0.2   5.01       4.81   3           4           0.7979     0.474      0.2247         0          0
cut      String              Fair  Very Good         4           9                                                0          0
color    String              D     J                 1           1                                                0          0
clarity  String              I1    VVS2              2           4                                                0          0
depth    Float    3330762.9  43.0  79.0       36     4           4           61.7494    1.4326     2.0524         0          0
table    Float    3099240.5  43.0  95.0       52     4           4           57.4572    2.2345     4.9929         0          0
price    Integer  212135217  326   18823      18497  3           5           3932.7997  3989.4028  15915334.3626  0          0
x        Float    309138.62  0.0   10.74      10.74  3           5           5.7312     1.1218     1.2583         0          0
y        Float    309320.33  0.0   58.9       58.9   3           5           5.7345     1.1421     1.3044         0          0
z        Float    190879.3   0.0   31.8       31.8   3           4           3.5387     0.7057     0.498          0          0

```

Everything stats. This requires reading the whole dataset into memory, but is
useful things like determining the shape of the distributions.

```sh
qsv stats diamonds.csv --everything | qsv table

# output
field    type     sum        min   max        range  min_length  max_length  mean       stddev     variance       nullcount  sparsity  mad   lower_outer_fence  lower_inner_fence  q1    q2_median  q3      iqr     upper_inner_fence  upper_outer_fence  skewness  cardinality  mode   mode_count  mode_occurrences  antimode                                                               antimode_count  antimode_occurrences
carat    Float    43040.87   0.2   5.01       4.81   3           4           0.7979     0.474      0.2247         0          0         0.32  -1.52              -0.56              0.4   0.7        1.04    0.64    2                  2.96               0.0625    273          0.3    1           2604              *PREVIEW: 2.59,2.64,2.65,2.67,2.7,2.71,2.77,3.02,3.05,3.11             21              1
cut      String              Fair  Very Good         4           9                                                0          0                                                                                                                                      5            Ideal  1           21551             Fair                                                                   1               1610
color    String              D     J                 1           1                                                0          0                                                                                                                                      7            G      1           11292             J                                                                      1               2808
clarity  String              I1    VVS2              2           4                                                0          0                                                                                                                                      8            SI1    1           13065             I1                                                                     1               741
depth    Float    3330762.9  43.0  79.0       36     4           4           61.7494    1.4326     2.0524         0          0         0.7   56.5               58.75              61    61.8       62.5    1.5     64.75              67                 -0.0667   184          62.0   1           2239              *PREVIEW: 44.0,50.8,51.0,52.2,52.3,52.7,53.0,53.1,53.3,53.4            30              1
table    Float    3099240.5  43.0  95.0       52     4           4           57.4572    2.2345     4.9929         0          0         1     47                 51.5               56    57         59      3       63.5               68                 0.3333    127          56.0   1           9881              *PREVIEW: 43.0,44.0,50.1,51.6,52.4,61.3,61.6,61.8,62.1,62.4            20              1
price    Integer  212135217  326   18823      18497  3           5           3932.7997  3989.4028  15915334.3626  0          0         1670  -12173.5           -5611.75           950   2401       5324.5  4374.5  11886.25           18448              0.3366    11602        605    1           132               *PREVIEW: 10000,10002,10003,10004,10006,10010,10013,10016,10018,10023  4137            1
x        Float    309138.62  0.0   10.74      10.74  3           5           5.7312     1.1218     1.2583         0          0         0.93  -0.78              1.965              4.71  5.7        6.54    1.83    9.285              12.03              -0.082    554          4.37   1           448               *PREVIEW: 10.0,10.01,10.02,10.14,10.23,10.74,3.74,3.76,3.77,8.74       38              1
y        Float    309320.33  0.0   58.9       58.9   3           5           5.7345     1.1421     1.3044         0          0         0.92  -0.74              1.99               4.72  5.71       6.54    1.82    9.27               12                 -0.0879   552          4.34   1           437               *PREVIEW: 10.1,10.16,10.54,3.68,3.72,3.73,3.75,3.8,3.81,3.82           39              1
z        Float    190879.3   0.0   31.8       31.8   3           4           3.5387     0.7057     0.498          0          0         0.57  -0.48              1.215              2.91  3.53       4.04    1.13    5.735              7.43               -0.0973   375          2.7    1           767               *PREVIEW: 1.07,1.41,1.53,2.06,2.24,2.25,2.26,2.27,2.28,2.29            43              1
```

## Links

- [qsv](https://github.com/jqnatividad/qsv)
