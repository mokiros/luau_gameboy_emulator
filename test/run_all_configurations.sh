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

PIDS=()
for CONFIG_ENTRY in "${CONFIGURATIONS[@]}"; do
	[[ "$CONFIG_ENTRY" == \#* ]] && continue

	IFS='|' read -r CONFIG USE_BIT32 NO_BRANCHED_EXPRESSIONS <<< "$CONFIG_ENTRY"

	echo "//// Creating configuration $CONFIG"
	CONFIG_FILE="$CONFIG_DIR/darklua_$CONFIG.json"
	lune run "$DIR/src/gen_conf.luau" -- -r "$REGISTERS_FILE" -p "$CONFIG_FILE" -bit32 "$USE_BIT32" -branched "$NO_BRANCHED_EXPRESSIONS" -debug

	OUT_FOLDER="$DIR/out/$CONFIG"

	mkdir -p "$OUT_FOLDER"

	echo "//// Running darklua with configuration $CONFIG"
	darklua process -c "$CONFIG_FILE" src "$OUT_FOLDER"

	echo "//// Running with configuration $CONFIG"
	(
		"$DIR/run_all_roms.sh" "$REGISTERS_FILE" "$CONFIG"
		echo "//// All ROMs passed with configuration $CONFIG"
	) &
	PIDS+=($!)
done

FAIL=0
for PID in "${PIDS[@]}"; do
	wait $PID || FAIL=1
done

if [[ $FAIL -ne 0 ]]; then
	echo "Some configurations failed."
	exit 1
fi

echo ""
echo "//// All tests passed!"
