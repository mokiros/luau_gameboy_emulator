#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

LOGFILE="$3"

echo "// Running lune"

rm -f "$LOGFILE"
lune run $DIR/src/main.luau -- -r "$1" -f "$2" -config "$4" >> "$LOGFILE"
