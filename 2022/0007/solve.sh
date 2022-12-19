#!/bin/bash -eo pipefail
if [[ "$1" == "" ]]; then
    echo 'Usage: ./solve.sh inputfile'
    exit 1
fi
javac ./solve.java
java Solve < $1