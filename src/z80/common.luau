local GlobalCommon = require("../common")
type GBState = GlobalCommon.GBState

local MMU = require("../mmu/common")
local mmu_read8 = MMU.read8
local mmu_read16 = MMU.read16
local mmu_write8 = MMU.write8
local mmu_write16 = MMU.write16

--- Represents the CPU instruction byte
export type Opcode = number
export type OpcodeHandler = (state: GBState) -> ()

export type InstructionSet = { [Opcode]: OpcodeHandler }

local INSTRUCTIONS = table.create(256)

type Common = {
	r16: (number, number) -> number,
	hli: (number, number) -> (number, number, number),
	hld: (number, number) -> (number, number, number),
	read_n8: (state: GBState) -> number,
	read_e8: (state: GBState) -> number,
	read_n16: (state: GBState) -> number,
	read_at_hl: (state: GBState) -> number,
	write_at_hl: (state: GBState, value: number) -> (),
	read_hla: (state: GBState) -> (),
	write_hla: (state: GBState) -> (),
	stack_push8: (state: GBState, value: number) -> (),
	stack_push16: (state: GBState, value: number) -> (),
	stack_pop8: (state: GBState) -> number,
	stack_pop16: (state: GBState) -> number,

	INSTRUCTIONS: InstructionSet,
}

local r16: typeof(({} :: Common).r16) = if _G.USE_BIT32
	then function(high, low)
		return bit32.lshift(high, 8) + low
	end
	else function(high, low)
		return high * 0x100 + low
	end

--- Combines into HL and returns incremented registers
local hli: typeof(({} :: Common).hli) = if _G.USE_BIT32
	then function(H, L)
		return bit32.lshift(H, 8) + L, bit32.band(H + bit32.rshift(L + 1, 8), 0xFF), bit32.band(L + 1, 0xFF)
	end
	elseif _G.NO_BRANCHED_EXPRESSIONS then function(H, L)
		return H * 0x100 + L, (H + (L + 1) // 256) % 256, (L + 1) % 256
	end
	else function(H, L)
		return H * 0x100 + L, L == 255 and (H + 1) % 256 or H, (L + 1) % 256
	end

--- Combines into HL and returns decremented registers
local hld: typeof(({} :: Common).hld) = if _G.USE_BIT32
	then function(H, L)
		return bit32.lshift(H, 8) + L,
			bit32.band(bit32.rshift(bit32.bor(bit32.lshift(H, 8), L) - 1, 8), 0xFF),
			bit32.band(bit32.bor(bit32.lshift(H, 8), L) - 1, 0xFF)
	end
	elseif _G.NO_BRANCHED_EXPRESSIONS then function(H, L)
		return H * 0x100 + L, (H - 1 + ((L + 255) // 256)) % 256, (L - 1) % 256
	end
	else function(H, L)
		return H * 0x100 + L, L == 0 and (H - 1) % 256 or H, (L - 1) % 256
	end

local read_n8: typeof(({} :: Common).read_n8) = function(state)
	local PC = state[REG_PC]
	state[REG_PC] = PC + 1
	return mmu_read8(state, PC)
end

local read_e8: typeof(({} :: Common).read_e8) = function(state)
	local PC = state[REG_PC]
	state[REG_PC] = PC + 1
	-- TODO: figure out a way to do it without conditional logic
	local n = mmu_read8(state, PC)
	return if n > 127 then n - 256 else n
end

local read_n16: typeof(({} :: Common).read_n16) = function(state)
	local PC = state[REG_PC]
	state[REG_PC] = PC + 2
	return mmu_read16(state, PC)
end

local read_at_hl: typeof(({} :: Common).read_at_hl) = function(state)
	return mmu_read8(state, r16(state[REG_H], state[REG_L]))
end

local write_at_hl: typeof(({} :: Common).write_at_hl) = function(state, value)
	mmu_write8(state, r16(state[REG_H], state[REG_L]), value)
end

local read_hla: typeof(({} :: Common).read_hla) = function(state)
	state[REG_HLA] = mmu_read8(state, r16(state[REG_H], state[REG_L]))
end

local write_hla: typeof(({} :: Common).write_hla) = function(state)
	mmu_write8(state, r16(state[REG_H], state[REG_L]), state[REG_HLA])
end

local stack_push8: typeof(({} :: Common).stack_push8) = function(state, value)
	state[REG_SP] -= 1
	mmu_write8(state, state[REG_SP], value)
end

local stack_push16: typeof(({} :: Common).stack_push16) = function(state, value)
	state[REG_SP] -= 2
	mmu_write16(state, state[REG_SP], value)
end

local stack_pop8: typeof(({} :: Common).stack_pop8) = function(state)
	state[REG_SP] += 1
	return mmu_read8(state, state[REG_SP] - 1)
end

local stack_pop16: typeof(({} :: Common).stack_pop16) = function(state)
	state[REG_SP] += 2
	return mmu_read16(state, state[REG_SP] - 2)
end

return {
	INSTRUCTIONS = INSTRUCTIONS,

	r16 = r16,
	hli = hli,
	hld = hld,
	read_n8 = read_n8,
	read_e8 = read_e8,
	read_n16 = read_n16,
	read_at_hl = read_at_hl,
	write_at_hl = write_at_hl,
	read_hla = read_hla,
	write_hla = write_hla,
	stack_push8 = stack_push8,
	stack_push16 = stack_push16,
	stack_pop8 = stack_pop8,
	stack_pop16 = stack_pop16,
} :: Common
