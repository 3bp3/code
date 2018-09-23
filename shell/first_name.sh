#!/bin/bash

egrep 'COMP[29]041' "$1" | cut -f3 -d'|' | cut -f2 -d',' | cut -f2 -d' '| sort | uniq -c | sort | tail -1 | sed 's/^ \+[0-9]\+ //g'
