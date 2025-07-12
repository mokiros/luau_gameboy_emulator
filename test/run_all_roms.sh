#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

REGISTERS_FILE="$1"
CONFIG_NAME="$2"
TEST_ROMS_DIR=$DIR/gb-test-roms/cpu_instrs/individual
LOG_DIR="$DIR/logs/$CONFIG_NAME"

mkdir -p "$LOG_DIR"  # Ensure log directory exists

ROMS=(
	"01-special"
	"02-interrupts"
	"03-op sp,hl"
	"04-op r,imm"
	"05-op rp"
	"06-ld r,r"
	"07-jr,jp,call,ret,rst"
	"08-misc instrs"
	"09-op r,r"
	"10-bit ops"
	"11-op a,(hl)"
)

declare -A pid_log_map
declare -a pids=()

for ROM_PATH in "${ROMS[@]}"; do
	[[ "$ROM_PATH" == \#* ]] && continue

	LOG_FILE="$LOG_DIR/${ROM_PATH}.log"
	OUTPUT_LOG="$LOG_DIR/${ROM_PATH}.output.log"

	TEST_ID="${ROM_PATH:0:2}"
	
	"$DIR/run.sh" "$1" "$TEST_ROMS_DIR/${ROM_PATH}.gb" "$LOG_FILE" "$CONFIG_NAME" > "$OUTPUT_LOG" 2>&1 &
	echo "/// Started ROM $TEST_ID (logging to ${OUTPUT_LOG}) with PID $!"
	curr_pid=$!
	pids+=("$curr_pid")
	pid_log_map["$curr_pid"]="$OUTPUT_LOG"
done

# Wait for all parallel jobs to complete, check exit status
FAILED=0
for pid in "${pids[@]}"; do
	if ! wait "$pid"; then
		echo -e "\n/// Error: ROM test failed for PID $pid"
		echo "=== Output log content ($pid) ==="
		cat "${pid_log_map[$pid]}"
		echo "=== End of log ==="
		((FAILED++))
	fi
done

if [ "$FAILED" -ne 0 ]; then
	echo "/// Error: $FAILED ROM test(s) failed!"
	exit 1
fi
