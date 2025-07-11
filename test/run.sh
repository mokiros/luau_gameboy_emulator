#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

LOGFILE="$5"

echo "// Running lune"

rm -f "$LOGFILE"
lune run $DIR/src/main.luau -- -r "$1" -f "$2" -c $4 -config "$6" >> "$LOGFILE"

echo "// Running gameboy doctor"

$DIR/gameboy-doctor/gameboy-doctor "$LOGFILE" cpu_instrs $3
