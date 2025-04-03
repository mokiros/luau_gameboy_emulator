#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

CONFIGURATIONS=(
	"bit32_branched"
	"bit32_nobranched"
	"nobit32_branched"
	"nobit32_nobranched"
)

for CONFIG in "${CONFIGURATIONS[@]}"; do
	echo "//// Running with configuration $CONFIG"
	$DIR/run_all_roms.sh "$CONFIG"
done

echo ""
echo "//// All tests passed!"
