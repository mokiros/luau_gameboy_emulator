--- *Note: REG_HLA is a placeholder register that is used for instructions that use [HL]*
export type GBState = {
	REG_B: number,
	REG_C: number,
	REG_D: number,
	REG_E: number,
	REG_H: number,
	REG_L: number,
	REG_HLA: number,
	REG_A: number,
	REG_F: number,
	REG_PC: number,
	REG_SP: number,

	REG_HALT: boolean,
	REG_STOP: boolean,

	REG_IME: boolean,
	REG_IE: number,
	REG_IF: number,

	MEMORY_ROM: buffer,
	MEMORY_WRAM: buffer,
	MEMORY_ERAM: buffer,

	CLOCK_M: number,
	TARGET_CLOCK_M: number,
}

--- Register lookup table
local REG = {
	B = 1,
	C = 2,
	D = 3,
	E = 4,
	H = 5,
	L = 6,
	HLA = 7,
	A = 8,
	F = 9,
	PC = 10,
	SP = 11,

	STOP = 20,
	HALT = 21,

	IME = 26,
	IE = 26,
	IF = 27,

	MEMORY_ROM = 30,
	MEMORY_WRAM = 31,
	MEMORY_ERAM = 32,
	MEMORY_VRAM = 33,
	MEMORY_HRAM = 34,
	MBC_MODE = 35,
	MBC_BANK = 36,
	MBC_MASK = 37,

	CLOCK_M = 50,
	TARGET_CLOCK_M = 51,

	SERIAL_VALUE = 60,
	SERIAL_DATA = 61,

	MBC_NONE = 0,
	MBC1 = 1,
	MBC2 = 2,
	MBC3 = 3,
	MBC4 = 4,
	MBC5 = 5,
	MBC6 = 6,
	MBC7 = 7,

	INT_VBLANK = 1,
	INT_LCD_STAT = 2,
	INT_TIMER = 4,
	INT_SERIAL = 8,
	INT_JOYPAD = 16,
}

return {
	REG = REG,
}
