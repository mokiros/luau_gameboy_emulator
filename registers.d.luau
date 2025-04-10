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

export type REG_IME = "REG_IME"
declare REG_IME: REG_IME --# 26
export type REG_IE = "REG_IE"
declare REG_IE: REG_IE --# 26
export type REG_IF = "REG_IF"
declare REG_IF: REG_IF --# 27

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

export type SERIAL_VALUE = "SERIAL_VALUE"
declare SERIAL_VALUE: SERIAL_VALUE --# 60
export type SERIAL_DATA = "SERIAL_DATA"
declare SERIAL_DATA: SERIAL_DATA --# 61

-- MBC (Memory Bank Controller) indexes
export type MBC_NONE = "MBC_NONE"
declare MBC_NONE: MBC_NONE --# 0
export type MBC1 = "MBC1"
declare MBC1: MBC1 --# 1
export type MBC2 = "MBC2"
declare MBC2: MBC2 --# 2
export type MBC3 = "MBC3"
declare MBC3: MBC3 --# 3
export type MBC4 = "MBC4"
declare MBC4: MBC4 --# 4
export type MBC5 = "MBC5"
declare MBC5: MBC5 --# 5
export type MBC6 = "MBC6"
declare MBC6: MBC6 --# 6
export type MBC7 = "MBC7"
declare MBC7: MBC7 --# 7

export type MBC_IDX = 
	MBC_NONE
	| MBC1
	| MBC2
	| MBC3
	| MBC4
	| MBC5
	| MBC6
	| MBC7

-- Bit masks for interrupts
export type INT_VBLANK = "INT_VBLANK"
declare INT_VBLANK: INT_VBLANK --# 1
export type INT_LCD_STAT = "INT_LCD_STAT"
declare INT_LCD_STAT: INT_LCD_STAT --# 2
export type INT_TIMER = "INT_TIMER"
declare INT_TIMER: INT_TIMER --# 4
export type INT_SERIAL = "INT_SERIAL"
declare INT_SERIAL: INT_SERIAL --# 8
export type INT_JOYPAD = "INT_JOYPAD"
declare INT_JOYPAD: INT_JOYPAD --# 16

export type INT_IDX = 
	INT_VBLANK
	| INT_LCD_STAT
	| INT_TIMER
	| INT_SERIAL
	| INT_JOYPAD
