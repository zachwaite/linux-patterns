#! /usr/bin/env bash

set -o errexit
set -o nounset

< diamonds.csv  \
  qsv select carat,price \
  | sed 's/carat/# carat/' \
  | tr , ' ' \
  | feedgnuplot \
    --points \
    --terminal 'dumb 80,40' \
    --domain \
    --unset grid \
    --xlabel 'carat' \
    --ylabel 'price'
  

