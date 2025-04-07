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
export type REG_STOP = "REG_STOP"
declare REG_STOP: REG_STOP --# 12
export type REG_INTERRUPTS = "REG_INTERRUPTS"
declare REG_INTERRUPTS: REG_INTERRUPTS --# 13
export type MEMORY_ROM = "MEMORY_ROM"
declare MEMORY_ROM: MEMORY_ROM --# 14
export type MEMORY_WRAM = "MEMORY_WRAM"
declare MEMORY_WRAM: MEMORY_WRAM --# 15
export type MEMORY_ERAM = "MEMORY_ERAM"
declare MEMORY_ERAM: MEMORY_ERAM --# 16
export type MEMORY_VRAM = "MEMORY_VRAM"
declare MEMORY_VRAM: MEMORY_VRAM --# 17
export type MEMORY_HRAM = "MEMORY_HRAM"
declare MEMORY_HRAM: MEMORY_HRAM --# 18
export type MBC_MODE = "MBC_MODE"
declare MBC_MODE: MBC_MODE --# 19
export type MBC_BANK = "MBC_BANK"
declare MBC_BANK: MBC_BANK --# 20
export type MBC_MASK = "MBC_MASK"
declare MBC_MASK: MBC_MASK --# 21

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
