-- GBState indexes
export type REG_B = "REG_B"
declare REG_B: REG_B
export type REG_C = "REG_C"
declare REG_C: REG_C
export type REG_D = "REG_D"
declare REG_D: REG_D
export type REG_E = "REG_E"
declare REG_E: REG_E
export type REG_H = "REG_H"
declare REG_H: REG_H
export type REG_L = "REG_L"
declare REG_L: REG_L
export type REG_HLA = "REG_HLA"
declare REG_HLA: REG_HLA
export type REG_A = "REG_A"
declare REG_A: REG_A
export type REG_F = "REG_F"
declare REG_F: REG_F
export type REG_PC = "REG_PC"
declare REG_PC: REG_PC
export type REG_SP = "REG_SP"
declare REG_SP: REG_SP
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
declare REG_STOP: REG_STOP
export type REG_HALT = "REG_HALT"
declare REG_HALT: REG_HALT

export type REG_IME_PENDING = "REG_IME_PENDING"
declare REG_IME_PENDING: REG_IME_PENDING
export type REG_IME = "REG_IME"
declare REG_IME: REG_IME
export type REG_IE = "REG_IE"
declare REG_IE: REG_IE
export type REG_IF = "REG_IF"
declare REG_IF: REG_IF

export type MEMORY_ROM = "MEMORY_ROM"
declare MEMORY_ROM: MEMORY_ROM
export type MEMORY_WRAM = "MEMORY_WRAM"
declare MEMORY_WRAM: MEMORY_WRAM
export type MEMORY_ERAM = "MEMORY_ERAM"
declare MEMORY_ERAM: MEMORY_ERAM
export type MEMORY_VRAM = "MEMORY_VRAM"
declare MEMORY_VRAM: MEMORY_VRAM
export type MEMORY_HRAM = "MEMORY_HRAM"
declare MEMORY_HRAM: MEMORY_HRAM
export type MEMORY_OAM = "MEMORY_OAM"
declare MEMORY_OAM: MEMORY_OAM
export type MBC_MODE = "MBC_MODE"
declare MBC_MODE: MBC_MODE
export type MBC_BANK = "MBC_BANK"
declare MBC_BANK: MBC_BANK
export type MBC_MASK = "MBC_MASK"
declare MBC_MASK: MBC_MASK
export type BIOS_BANK = "BIOS_BANK"
declare BIOS_BANK: BIOS_BANK

export type CLOCK_M = "CLOCK_M"
declare CLOCK_M: CLOCK_M
export type TARGET_CLOCK_M = "TARGET_CLOCK_M"
declare TARGET_CLOCK_M: TARGET_CLOCK_M
export type REG_DIV = "REG_DIV"
declare REG_DIV: REG_DIV
export type REG_TIMA = "REG_TIMA"
declare REG_TIMA: REG_TIMA
export type REG_TMA = "REG_TMA"
declare REG_TMA: REG_TMA
export type REG_TAC = "REG_TAC"
declare REG_TAC: REG_TAC
export type TIMA_COUNTER = "TIMA_COUNTER"
declare TIMA_COUNTER: TIMA_COUNTER

export type SERIAL_VALUE = "SERIAL_VALUE"
declare SERIAL_VALUE: SERIAL_VALUE
export type SERIAL_DATA = "SERIAL_DATA"
declare SERIAL_DATA: SERIAL_DATA

-- PPU related indexes
export type SCREEN_BUFFER = "SCREEN_BUFFER"
declare SCREEN_BUFFER: SCREEN_BUFFER
export type PPU_MODECLOCK = "PPU_MODECLOCK"
declare PPU_MODECLOCK: PPU_MODECLOCK
export type PPU_MODE = "PPU_MODE"
declare PPU_MODE: PPU_MODE
export type PPU_LY = "PPU_LY"
declare PPU_LY: PPU_LY
export type PPU_LYC = "PPU_LYC"
declare PPU_LYC: PPU_LYC
export type PPU_LCDC = "PPU_LCDC"
declare PPU_LCDC: PPU_LCDC
export type PPU_SCY = "PPU_SCY"
declare PPU_SCY: PPU_SCY
export type PPU_SCX = "PPU_SCX"
declare PPU_SCX: PPU_SCX
export type PPU_STAT = "PPU_STAT"
declare PPU_STAT: PPU_STAT
export type PPU_WY = "PPU_WY"
declare PPU_WY: PPU_WY
export type PPU_WX = "PPU_WX"
declare PPU_WX: PPU_WX
export type PPU_BGP = "PPU_BGP"
declare PPU_BGP: PPU_BGP
export type PPU_OBP0 = "PPU_OBP0"
declare PPU_OBP0: PPU_OBP0
export type PPU_OBP1 = "PPU_OBP1"
declare PPU_OBP1: PPU_OBP1

declare PPU_MODE_HBLANK: number --# 0
declare PPU_MODE_VBLANK: number --# 1
declare PPU_MODE_OAM_SCAN: number --# 2
declare PPU_MODE_DRAWING: number --# 3

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
