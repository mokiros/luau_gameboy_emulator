#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

LOGFILE="$4"

echo "// Running lune"

rm -f "$LOGFILE"
lune run $DIR/src/main.luau -- -f "$1" -c $3 >> "$LOGFILE"

echo "// Running gameboy doctor"

$DIR/gameboy-doctor/gameboy-doctor "$LOGFILE" cpu_instrs $2
