--- *Note: REG_HLA is a placeholder register that is used for instructions that use [HL]*
export type GBState = any

--[[
	Useless for now because Luau's type solver
	cannot properly infer the type from a string
	indexer like state[REG_A], but using strings
	directly like state["REG_A"] works fine, but
	that's not what I need
]]
-- export type GBState = {
-- 	REG_B: number,
-- 	REG_C: number,
-- 	REG_D: number,
-- 	REG_E: number,
-- 	REG_H: number,
-- 	REG_L: number,
-- 	REG_HLA: number,
-- 	REG_A: number,
-- 	REG_F: number,
-- 	REG_PC: number,
-- 	REG_SP: number,

-- 	REG_HALT: boolean,
-- 	REG_STOP: boolean,

-- 	REG_IME: boolean,
-- 	REG_IE: number,
-- 	REG_IF: number,

-- 	MEMORY_ROM: buffer,
-- 	MEMORY_WRAM: buffer,
-- 	MEMORY_ERAM: buffer,

-- 	CLOCK_M: number,
-- 	TARGET_CLOCK_M: number,
-- }

local function raise_interrupt(state: GBState, bitmask: INT_IDX): ()
	state[REG_IF] = bit32.bor(state[REG_IF], bitmask)
end

return {
	raise_interrupt = raise_interrupt,
}
