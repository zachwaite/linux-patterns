#! /usr/bin/env bash

set -o errexit
set -o nounset


qsv dedup ./diamonds1.csv > diamonds_deduped.csv

wc -l diamonds1.csv
wc -l diamonds_deduped.csv



