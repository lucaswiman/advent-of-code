#!/usr/bin/env bash -e -o pipefail
topn=$(cat input | while read a; do
  if [ -z "$a" ]; then
    echo
  else
    echo -n "$a+"
  fi
done | xargs -L1 -Ixx bash -c 'echo $(( xx 0))' | sort -nr | head -n $1)
echo $(( ${topn//$'\n'/+} ))
