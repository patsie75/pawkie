#!/bin/bash

SELF=$(basename "$0")
CFG="${SELF/.sh/.ini}"
LOG="${SELF/.sh/.log}"
LIBS=$(for i in lib/*.awk commands/*.awk; do echo -n "-f $i "; done)

#/usr/bin/gawk -v cfg="$CFG" $LIBS -f main.awk >"$LOG" 2>&1 &
/usr/bin/gawk41 --profile -v cfg="$CFG" $LIBS -f main.awk
#/usr/bin/gawk41 -v cfg="$CFG" $LIBS -f main.awk

