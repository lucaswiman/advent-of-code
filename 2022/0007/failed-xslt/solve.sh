#! /usr/bin/env bash

# Write to stdout and add a newline. Can also write to a file with -o:filename
xslt3 -s:process.xml -xsl:./solve.xsl; echo
