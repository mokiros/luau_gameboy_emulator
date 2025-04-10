#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

CONFIG_DIR="$DIR/configs"

REGISTERS_FILE="$DIR/../registers.d.luau"

CONFIGURATIONS=(
	"bit32_branched|true|false"
	"bit32_nobranched|true|true"
	"nobit32_branched|false|false"
	"nobit32_nobranched|false|true"
)

mkdir -p "$CONFIG_DIR"

for CONFIG_ENTRY in "${CONFIGURATIONS[@]}"; do
	[[ "$CONFIG_ENTRY" == \#* ]] && continue

	IFS='|' read -r CONFIG USE_BIT32 NO_BRANCHED_EXPRESSIONS <<< "$CONFIG_ENTRY"

	echo "//// Creating configuration $CONFIG"
	CONFIG_FILE="$CONFIG_DIR/darklua_$CONFIG.json"
	lune run "$DIR/src/gen_conf.luau" -- -r "$REGISTERS_FILE" -p "$CONFIG_FILE" -bit32 "$USE_BIT32" -branched "$NO_BRANCHED_EXPRESSIONS" -debug

	echo "//// Running darklua with configuration $CONFIG"
	darklua process -c "$CONFIG_FILE" src out

	echo "//// Running with configuration $CONFIG"
	$DIR/run_all_roms.sh "$REGISTERS_FILE"
	echo "//// All ROMs passed with configuration $CONFIG"
	echo ""
done

echo ""
echo "//// All tests passed!"
