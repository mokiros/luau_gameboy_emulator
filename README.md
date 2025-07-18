# Luau Gameboy Emulator

A Gameboy emulator implementation in Luau.

## Overview

The purpose of this project is not to write an accurate emulator, but rather research ways to optimize Luau code to be efficient and fast. This includes processing the code using various tools like darklua, and some parts of the code will use different implementations depending on the darklua settings (using `inject_global_value` rule):
 * USE_BIT32 - if set, will use `bit32` implementations. If not, will use native arithmetic operators.
 * NO_BRANCHED_EXPRESSIONS - if set, minimize the amount of `if A then B else C` expressions, opting to use arithmetic or bit32 instead (depending on USE_BIT32 flag)
 * DEBUG - if set, will include additional checks to catch bugs

The reason for the USE_BIT32 and NO_BRANCHED_EXPRESSIONS flags is to test which implementations work best for different Luau configurations. From my own observations (but not based on any benchmarks yet), using bit32 with no branched expressions (no conditional checks) works best with codegen (the `--!native` flag), since it results in linear code with no jump instructions, but in regular Luau VM the native operators with conditional checks work better, since they result in smaller bytecode and avoid `GETIMPORT` and additional function calls.

## Testing

The emulator is tested using [Blargg's test ROMs](https://github.com/retrio/gb-test-roms) (for now, only from the `cpu_instrs` folder).

### Running Tests

Run all tests at once
```bash
./test/run_all_configurations.sh
```

Run a specific test ROM
```bash
./test/run.sh path/to/rom.gb logfile.log
```

Example - run CPU instruction test #3:
```bash
./test/run.sh test/gb-test-roms/cpu_instrs/individual/03-op-sp,hl.gb log.txt
```

## Development

This project uses Lune for running scripts and tests.

## Acknowledgements

 - [Blargg's test ROMs](https://github.com/retrio/gb-test-roms) for testing

 - [Gameboy Doctor](https://github.com/robert/gameboy-doctor) for debugging

 - [Pan Docs](https://gbdev.io/pandocs/) for Gameboy hardware documentation
