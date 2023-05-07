# feature-engineer - 2023-05-05

## tldr;

`feature-engineer` is a tool for transforming categorical fields in a csv file
into numerical fields. This practice is known as "encoding" and is commonly used
in circumstances where the candidate model doesn't work well with non-numerical
data. There seems to be some inconsistency in the naming of these methods in the
wild, but `feature-engineer` can perform three different types of encoding as
explained:

- **label encoding** - map a categorical field to an incrementally assigned
  integer id field
- **frequency encoding** - map a categorical field to a float field that
  represents the frequency of occurance of this value in the overall dataset
- **one-hot encoding** - map a categorical field to a collection of integer
  fields with a 0 representing absence of the value and 1 representing presence
  of the value

## Examples

**label encoding** just maps the categorical values to an incrementing integer.
This is ok if downstream models and analysts understand that this is an id field
and the order of the integers is not meaningful. If this communication does not
take place, the analyst might interpret e.g. A=1 B=2 C=3 to mean that C is three
times as much as A...

```sh
# cut is probably not appropriate for label, but this dataset lacks good examples...
< diamonds.csv ./feature-engineer label cut > cut_label.csv
qsv cat columns diamonds.csv cut_label.csv | qsv table | head

# carat  cut        color  clarity  depth  table  price  x     y     z     cut_label
# 0.23   Ideal      E      SI2      61.5   55.0   326    3.95  3.98  2.43  1
# 0.21   Premium    E      SI1      59.8   61.0   326    3.89  3.84  2.31  2
# 0.23   Good       E      VS1      56.9   65.0   327    4.05  4.07  2.31  3
# 0.29   Premium    I      VS2      62.4   58.0   334    4.2   4.23  2.63  2
# 0.31   Good       J      SI2      63.3   58.0   335    4.34  4.35  2.75  3
# 0.24   Very Good  J      VVS2     62.8   57.0   336    3.94  3.96  2.48  4
# 0.24   Very Good  I      VVS1     62.3   57.0   336    3.95  3.98  2.47  4
# 0.26   Very Good  H      SI1      61.9   55.0   337    4.07  4.11  2.53  4
# 0.22   Fair       E      VS2      65.1   61.0   337    3.87  3.78  2.49  5
```

**frequency encoding** maps the categorical values to a float between 0 and 1,
which represents the frequency this value occurs in the dataset. It avoids the
problem of label encoding, but introduces a field which is highly correlated to
the output, which could confuse some machine learning models like linear
regression or classifiers that are trying to determine which fields are good
predictors of an output field. Additionally, this method could cause some loss
of context when two categorical values have the same frequency in the data.

```sh
< diamonds.csv ./feature-engineer frequency cut > cut_frequency.csv
qsv cat columns diamonds.csv cut_label.csv | qsv table | head

# carat  cut        color  clarity  depth  table  price  x      y      z     cut_freq
# 0.23   Ideal      E      SI2      61.5   55.0   326    3.95   3.98   2.43  0.39
# 0.21   Premium    E      SI1      59.8   61.0   326    3.89   3.84   2.31  0.25
# 0.23   Good       E      VS1      56.9   65.0   327    4.05   4.07   2.31  0.09
# 0.29   Premium    I      VS2      62.4   58.0   334    4.2    4.23   2.63  0.25
# 0.31   Good       J      SI2      63.3   58.0   335    4.34   4.35   2.75  0.09
# 0.24   Very Good  J      VVS2     62.8   57.0   336    3.94   3.96   2.48  0.22
# 0.24   Very Good  I      VVS1     62.3   57.0   336    3.95   3.98   2.47  0.22
# 0.26   Very Good  H      SI1      61.9   55.0   337    4.07   4.11   2.53  0.22
# 0.22   Fair       E      VS2      65.1   61.0   337    3.87   3.78   2.49  0.02
```

**one-hot encoding** maps the categorical values to a collection of new fields
which are either 0 or 1, representing the absence or presence of the value,
respectively. one-hot is similar to dummy variables, frequently used in linear
regression models, with a subtle difference - with dummy variables, you end up
with _n-1_ fields for _n_ variables, where as with one-hot, you end up with _n_,
avoiding the need to determine which value is the missing one (and why). A
downside of one-hot encoding is that it can introduce many new fields to the
model, which may explode computation time and make the model harder to
understand by adding so many new dimensions. Variations on this include grouping
values to avoid this problem, possibly after doing some screening with a
sensitivity analysis.

```sh
< diamonds.csv ./feature-engineer one-hot cut > cut_frequency.csv
qsv cat columns diamonds.csv cut_one-hot.csv | qsv table | head

# carat  cut        color  clarity  depth  table  price  x      y      z     is_Premium  is_Ideal  is_Fair  is_Good  is_Very_Good
# 0.23   Ideal      E      SI2      61.5   55.0   326    3.95   3.98   2.43  0           1         0        0        0
# 0.21   Premium    E      SI1      59.8   61.0   326    3.89   3.84   2.31  1           0         0        0        0
# 0.23   Good       E      VS1      56.9   65.0   327    4.05   4.07   2.31  0           0         0        1        0
# 0.29   Premium    I      VS2      62.4   58.0   334    4.2    4.23   2.63  1           0         0        0        0
# 0.31   Good       J      SI2      63.3   58.0   335    4.34   4.35   2.75  0           0         0        1        0
# 0.24   Very Good  J      VVS2     62.8   57.0   336    3.94   3.96   2.48  0           0         0        0        1
# 0.24   Very Good  I      VVS1     62.3   57.0   336    3.95   3.98   2.47  0           0         0        0        1
# 0.26   Very Good  H      SI1      61.9   55.0   337    4.07   4.11   2.53  0           0         0        0        1
# 0.22   Fair       E      VS2      65.1   61.0   337    3.87   3.78   2.49  0           0         1        0        0
```

## Links

- [qsv](https://github.com/jqnatividad/qsv)
- [blog post on feature engineering](https://medium.com/analytics-vidhya/different-type-of-feature-engineering-encoding-techniques-for-categorical-variable-encoding-214363a016fb)
- [statology blog post](https://www.statology.org/label-encoding-vs-one-hot-encoding/)
- [towards data science blog post](https://towardsdatascience.com/all-about-categorical-variable-encoding-305f3361fd02)
