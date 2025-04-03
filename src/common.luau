--- Registers and state are indexed using numbers:
---
--- | Register / State | Index |
--- | ---------------- | ----- |
--- | B                | 1     |
--- | C                | 2     |
--- | D                | 3     |
--- | E                | 4     |
--- | H                | 5     |
--- | L                | 6     |
--- | HLA*             | 7     |
--- | A                | 8     |
--- | F                | 9     |
--- | PC               | 10    |
--- | SP               | 11    |
--- | STOP             | 12    |
--- | INTERRUPTS       | 13    |
--- | MEMORY_ROM       | 14    |
--- | MEMORY_WRAM      | 15    |
--- | MEMORY_ERAM      | 16    |
---
--- *\* HLA is a placeholder register that is used for instructions that use [HL]*
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
	REG_STOP: number,
	REG_INTERRUPTS: number,
	MEMORY_ROM: buffer,
	MEMORY_WRAM: buffer,
	MEMORY_ERAM: buffer,
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

	STOP = 12,
	INTERRUPTS = 13,

	MEMORY_ROM = 14,
	MEMORY_WRAM = 15,
	MEMORY_ERAM = 16,
}

return {
	REG = REG,
}
