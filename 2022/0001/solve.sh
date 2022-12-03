#!/usr/bin/env bash
set -e
declare -i acc=0
topn=$(cat input | while read a; do
    if [ -z "$a" ];
    then
        echo $acc
        acc=0
    else
        acc=$(( $acc + $a ))
    fi
done | sort -nr | head -n $1)
echo $(( ${topn//$'\n'/+} ))
