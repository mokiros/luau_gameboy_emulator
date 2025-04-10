#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

REGISTERS_FILE="$1"
TEST_ROMS_DIR=$DIR/gb-test-roms/cpu_instrs/individual
LOG_DIR="$DIR/logs"

mkdir -p "$LOG_DIR"  # Ensure log directory exists

ROMS=(
	"01-special|1|1256633"
	# "02-interrupts|2|0"  # Disabled
	"03-op sp,hl|3|1066160"
	"04-op r,imm|4|1260504"
	"05-op rp|5|1761126"
	"06-ld r,r|6|241011"
	"07-jr,jp,call,ret,rst|7|587415"
	"08-misc instrs|8|221630"
	"09-op r,r|9|4418120"
	"10-bit ops|10|6712461"
	"11-op a,(hl)|11|7427500"
)

declare -A pid_log_map
declare -a pids=()

for ROM_ENTRY in "${ROMS[@]}"; do
	[[ "$ROM_ENTRY" == \#* ]] && continue

	IFS='|' read -r ROM_PATH TEST_ID CYCLE_COUNT <<< "$ROM_ENTRY"
	LOG_FILE="$LOG_DIR/${ROM_PATH}.log"
	OUTPUT_LOG="$LOG_DIR/${ROM_PATH}.output.log"
	
	"$DIR/run.sh" "$1" "$TEST_ROMS_DIR/${ROM_PATH}.gb" "$TEST_ID" "$CYCLE_COUNT" "$LOG_FILE" > "$OUTPUT_LOG" 2>&1 &
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
