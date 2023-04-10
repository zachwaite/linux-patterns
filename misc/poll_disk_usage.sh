#! /usr/bin/env bash

set -o errexit
set -o nounset

MYHOME="/home/zach";
OUTFILE="$MYHOME/tmpdu.txt";

poll() {
  iterations=$1;
  cmd=$2;
  local c=0;

  while [[ $c -lt "$iterations" ]]; do
    eval $cmd;
    c=$((c+1));
    sleep 1;
  done;
}

dir_disk_usage() {
  sudo du -h -d 1 | tail -n 1 | tee -a "$OUTFILE";
}

# ========= Main ===============
rm "$OUTFILE";
touch "$OUTFILE";
cd /tmp
poll "5" "dir_disk_usage";
