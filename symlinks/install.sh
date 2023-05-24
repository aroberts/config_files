#!/bin/bash

# make sure we're installing from the right directory
cd `dirname $0`

for p in `find . -mindepth 2 -type f`; do
  tgt="${p:1}" # strips leading . from find cmd
  dir=$(dirname "$tgt")
  [ -d "$dir" ] || mkdir -p "$dir"
  [ -e "$tgt" ] || { \
    ln -s "`pwd -P`$tgt" "$tgt" && \
    echo "Created $tgt" \
    ; }
done


