-- GBState indexes
export type REG_B = "REG_B"
declare REG_B: REG_B --# 1
export type REG_C = "REG_C"
declare REG_C: REG_C --# 2
export type REG_D = "REG_D"
declare REG_D: REG_D --# 3
export type REG_E = "REG_E"
declare REG_E: REG_E --# 4
export type REG_H = "REG_H"
declare REG_H: REG_H --# 5
export type REG_L = "REG_L"
declare REG_L: REG_L --# 6
export type REG_HLA = "REG_HLA"
declare REG_HLA: REG_HLA --# 7
export type REG_A = "REG_A"
declare REG_A: REG_A --# 8
export type REG_F = "REG_F"
declare REG_F: REG_F --# 9
export type REG_PC = "REG_PC"
declare REG_PC: REG_PC --# 10
export type REG_SP = "REG_SP"
declare REG_SP: REG_SP --# 11
export type REG_IDX =
	  REG_B
	| REG_C
	| REG_D
	| REG_E
	| REG_H
	| REG_L
	| REG_HLA
	| REG_A
	| REG_F
	| REG_PC
	| REG_SP

export type REG_STOP = "REG_STOP"
declare REG_STOP: REG_STOP --# 20
export type REG_HALT = "REG_HALT"
declare REG_HALT: REG_HALT --# 21

export type REG_IME_PENDING = "REG_IME_PENDING"
declare REG_IME_PENDING: REG_IME_PENDING --# 25
export type REG_IME = "REG_IME"
declare REG_IME: REG_IME --# 26
export type REG_IE = "REG_IE"
declare REG_IE: REG_IE --# 27
export type REG_IF = "REG_IF"
declare REG_IF: REG_IF --# 28

export type MEMORY_ROM = "MEMORY_ROM"
declare MEMORY_ROM: MEMORY_ROM --# 30
export type MEMORY_WRAM = "MEMORY_WRAM"
declare MEMORY_WRAM: MEMORY_WRAM --# 31
export type MEMORY_ERAM = "MEMORY_ERAM"
declare MEMORY_ERAM: MEMORY_ERAM --# 32
export type MEMORY_VRAM = "MEMORY_VRAM"
declare MEMORY_VRAM: MEMORY_VRAM --# 33
export type MEMORY_HRAM = "MEMORY_HRAM"
declare MEMORY_HRAM: MEMORY_HRAM --# 34
export type MBC_MODE = "MBC_MODE"
declare MBC_MODE: MBC_MODE --# 35
export type MBC_BANK = "MBC_BANK"
declare MBC_BANK: MBC_BANK --# 36
export type MBC_MASK = "MBC_MASK"
declare MBC_MASK: MBC_MASK --# 37
export type BIOS_BANK = "BIOS_BANK"
declare BIOS_BANK: BIOS_BANK --# 39

export type CLOCK_M = "CLOCK_M"
declare CLOCK_M: CLOCK_M --# 50
export type TARGET_CLOCK_M = "TARGET_CLOCK_M"
declare TARGET_CLOCK_M: TARGET_CLOCK_M --# 51
export type REG_DIV = "REG_DIV"
declare REG_DIV: REG_DIV --# 52
export type REG_TIMA = "REG_TIMA"
declare REG_TIMA: REG_TIMA --# 53
export type REG_TMA = "REG_TMA"
declare REG_TMA: REG_TMA --# 54
export type REG_TAC = "REG_TAC"
declare REG_TAC: REG_TAC --# 55
export type TIMA_COUNTER = "TIMA_COUNTER"
declare TIMA_COUNTER: TIMA_COUNTER --# 56

export type SERIAL_VALUE = "SERIAL_VALUE"
declare SERIAL_VALUE: SERIAL_VALUE --# 60
export type SERIAL_DATA = "SERIAL_DATA"
declare SERIAL_DATA: SERIAL_DATA --# 61

-- MBC (Memory Bank Controller) indexes
declare MBC_NONE: number --# 0
declare MBC1: number --# 1
declare MBC2: number --# 2
declare MBC3: number --# 3
declare MBC4: number --# 4
declare MBC5: number --# 5
declare MBC6: number --# 6
declare MBC7: number --# 7

export type MBC_IDX = number

-- Bit masks for interrupts
declare INT_VBLANK: number --# 1
declare INT_LCD_STAT: number --# 2
declare INT_TIMER: number --# 4
declare INT_SERIAL: number --# 8
declare INT_JOYPAD: number --# 16

export type INT_IDX = number
