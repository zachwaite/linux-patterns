#! /usr/bin/env bash

set -o errexit
set -o nounset


qsv diff ./diamonds1.csv ./diamonds2.csv --primary-key-idx 0,1,2,3,4,5,6,7,8,9


# there are duplicates in this dataset
# diffresult,carat,cut,color,clarity,depth,table,price,x,y,z
# -,0.31,Ideal,H,VVS2,62.4,57.0,625,4.32,4.36,2.71
# -,0.33,Ideal,E,SI1,62.5,55.0,579,4.42,4.45,2.77
# -,1.0,Premium,H,SI2,61.0,57.0,4032,6.51,6.4,3.94
# -,0.3,Very Good,G,VS2,63.0,55.0,526,4.29,4.31,2.71
# -,0.33,Ideal,G,VS1,62.1,56.0,666,4.4,4.42,2.74
# -,0.3,Good,J,VS1,63.4,57.0,394,4.23,4.26,2.69
# -,0.31,Good,D,SI1,63.5,56.0,571,4.29,4.31,2.73
# -,1.0,Premium,G,SI1,60.1,61.0,3634,6.44,6.4,3.86
# -,0.33,Ideal,G,VS1,62.1,55.0,666,4.43,4.46,2.76
# -,0.36,Ideal,D,SI1,62.7,57.0,663,4.54,4.59,2.86
# -,0.32,Ideal,H,VVS2,61.8,55.0,645,4.38,4.42,2.72


qsv diff ./small1.csv ./small2.csv --primary-key-idx 0,1,2

# One line is available in small2 but not in small1
# diffresult,city,state,country
# +,hartford,ny,us

qsv diff ./ordered1.csv ./ordered2.csv --primary-key-idx 0,1,2

# Order is not considered, only presence/absence
# diffresult,city,state,country
