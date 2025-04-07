#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

CONFIG_DIR="$DIR/configs"

CONFIGURATIONS=(
	"bit32_branched|true|true"
	"bit32_nobranched|true|false"
	"nobit32_branched|false|true"
	"nobit32_nobranched|false|false"
)

mkdir -p "$CONFIG_DIR"

for CONFIG_ENTRY in "${CONFIGURATIONS[@]}"; do
	[[ "$CONFIG_ENTRY" == \#* ]] && continue

	IFS='|' read -r CONFIG USE_BIT32 NO_BRANCHED_EXPRESSIONS <<< "$CONFIG_ENTRY"

	echo "//// Creating configuration $CONFIG"
	CONFIG_FILE="$CONFIG_DIR/darklua_$CONFIG.json"
	lune run "$DIR/src/gen_conf.luau" -- -r "$DIR/../registers.d.luau" -p "$CONFIG_FILE" -bit32 "$USE_BIT32" -branched $NO_BRANCHED_EXPRESSIONS

	echo "//// Running darklua with configuration $CONFIG"
	darklua process -c "$CONFIG_FILE" src out

	echo "//// Running with configuration $CONFIG"
	$DIR/run_all_roms.sh
	echo "//// All ROMs passed with configuration $CONFIG"
	echo ""
done

echo ""
echo "//// All tests passed!"
