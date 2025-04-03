local Common = require("./common")
local r16 = Common.r16
local hli = Common.hli
local hld = Common.hld
local read_n8 = Common.read_n8
local read_n16 = Common.read_n16
local read_at_hl = Common.read_at_hl
local write_at_hl = Common.write_at_hl

local MMU = require("../mmu")
local mmu_read8 = MMU.read8
local mmu_write8 = MMU.write8
local mmu_write16 = MMU.write16

local ARITH = require("./arithmetic")

local LD: Common.InstructionSet = {}

LD[0x40] = function(state)
	state[REG_B] = state[REG_B]
end

LD[0x41] = function(state)
	state[REG_B] = state[REG_C]
end

LD[0x42] = function(state)
	state[REG_B] = state[REG_D]
end

LD[0x43] = function(state)
	state[REG_B] = state[REG_E]
end

LD[0x44] = function(state)
	state[REG_B] = state[REG_H]
end

LD[0x45] = function(state)
	state[REG_B] = state[REG_L]
end

LD[0x46] = function(state)
	state[REG_B] = read_at_hl(state)
end

LD[0x47] = function(state)
	state[REG_B] = state[REG_A]
end

LD[0x48] = function(state)
	state[REG_C] = state[REG_B]
end

LD[0x49] = function(state)
	state[REG_C] = state[REG_C]
end

LD[0x4A] = function(state)
	state[REG_C] = state[REG_D]
end

LD[0x4B] = function(state)
	state[REG_C] = state[REG_E]
end

LD[0x4C] = function(state)
	state[REG_C] = state[REG_H]
end

LD[0x4D] = function(state)
	state[REG_C] = state[REG_L]
end

LD[0x4E] = function(state)
	state[REG_C] = read_at_hl(state)
end

LD[0x4F] = function(state)
	state[REG_C] = state[REG_A]
end

LD[0x50] = function(state)
	state[REG_D] = state[REG_B]
end

LD[0x51] = function(state)
	state[REG_D] = state[REG_C]
end

LD[0x52] = function(state)
	state[REG_D] = state[REG_D]
end

LD[0x53] = function(state)
	state[REG_D] = state[REG_E]
end

LD[0x54] = function(state)
	state[REG_D] = state[REG_H]
end

LD[0x55] = function(state)
	state[REG_D] = state[REG_L]
end

LD[0x56] = function(state)
	state[REG_D] = read_at_hl(state)
end

LD[0x57] = function(state)
	state[REG_D] = state[REG_A]
end

LD[0x58] = function(state)
	state[REG_E] = state[REG_B]
end

LD[0x59] = function(state)
	state[REG_E] = state[REG_C]
end

LD[0x5A] = function(state)
	state[REG_E] = state[REG_D]
end

LD[0x5B] = function(state)
	state[REG_E] = state[REG_E]
end

LD[0x5C] = function(state)
	state[REG_E] = state[REG_H]
end

LD[0x5D] = function(state)
	state[REG_E] = state[REG_L]
end

LD[0x5E] = function(state)
	state[REG_E] = read_at_hl(state)
end

LD[0x5F] = function(state)
	state[REG_E] = state[REG_A]
end

LD[0x60] = function(state)
	state[REG_H] = state[REG_B]
end

LD[0x61] = function(state)
	state[REG_H] = state[REG_C]
end

LD[0x62] = function(state)
	state[REG_H] = state[REG_D]
end

LD[0x63] = function(state)
	state[REG_H] = state[REG_E]
end

LD[0x64] = function(state)
	state[REG_H] = state[REG_H]
end

LD[0x65] = function(state)
	state[REG_H] = state[REG_L]
end

LD[0x66] = function(state)
	state[REG_H] = read_at_hl(state)
end

LD[0x67] = function(state)
	state[REG_H] = state[REG_A]
end

LD[0x68] = function(state)
	state[REG_L] = state[REG_B]
end

LD[0x69] = function(state)
	state[REG_L] = state[REG_C]
end

LD[0x6A] = function(state)
	state[REG_L] = state[REG_D]
end

LD[0x6B] = function(state)
	state[REG_L] = state[REG_E]
end

LD[0x6C] = function(state)
	state[REG_L] = state[REG_H]
end

LD[0x6D] = function(state)
	state[REG_L] = state[REG_L]
end

LD[0x6E] = function(state)
	state[REG_L] = read_at_hl(state)
end

LD[0x6F] = function(state)
	state[REG_L] = state[REG_A]
end

LD[0x70] = function(state)
	write_at_hl(state, state[REG_B])
end

LD[0x71] = function(state)
	write_at_hl(state, state[REG_C])
end

LD[0x72] = function(state)
	write_at_hl(state, state[REG_D])
end

LD[0x73] = function(state)
	write_at_hl(state, state[REG_E])
end

LD[0x74] = function(state)
	write_at_hl(state, state[REG_H])
end

LD[0x75] = function(state)
	write_at_hl(state, state[REG_L])
end

-- LD[0x76] - HALT instruction, handled elsewhere

LD[0x77] = function(state)
	write_at_hl(state, state[REG_A])
end

LD[0x78] = function(state)
	state[REG_A] = state[REG_B]
end

LD[0x79] = function(state)
	state[REG_A] = state[REG_C]
end

LD[0x7A] = function(state)
	state[REG_A] = state[REG_D]
end

LD[0x7B] = function(state)
	state[REG_A] = state[REG_E]
end

LD[0x7C] = function(state)
	state[REG_A] = state[REG_H]
end

LD[0x7D] = function(state)
	state[REG_A] = state[REG_L]
end

LD[0x7E] = function(state)
	state[REG_A] = read_at_hl(state)
end

LD[0x7F] = function(state)
	state[REG_A] = state[REG_A]
end

LD[0x02] = function(state)
	mmu_write8(state, r16(state[REG_B], state[REG_C]), state[REG_A])
end

LD[0x12] = function(state)
	mmu_write8(state, r16(state[REG_D], state[REG_E]), state[REG_A])
end

LD[0x22] = function(state)
	local HL: number
	HL, state[REG_H], state[REG_L] = hli(state[REG_H], state[REG_L])
	mmu_write8(state, HL, state[REG_A])
end

LD[0x32] = function(state)
	local HL: number
	HL, state[REG_H], state[REG_L] = hld(state[REG_H], state[REG_L])
	mmu_write8(state, HL, state[REG_A])
end

LD[0x06] = function(state)
	state[REG_B] = read_n8(state)
end

LD[0x16] = function(state)
	state[REG_D] = read_n8(state)
end

LD[0x26] = function(state)
	state[REG_H] = read_n8(state)
end

LD[0x36] = function(state)
	write_at_hl(state, read_n8(state))
end

LD[0x0A] = function(state)
	state[REG_A] = mmu_read8(state, r16(state[REG_B], state[REG_C]))
end

LD[0x1A] = function(state)
	state[REG_A] = mmu_read8(state, r16(state[REG_D], state[REG_E]))
end

LD[0x2A] = function(state)
	local HL: number
	HL, state[REG_H], state[REG_L] = hli(state[REG_H], state[REG_L])
	state[REG_A] = mmu_read8(state, HL)
end

LD[0x3A] = function(state)
	local HL: number
	HL, state[REG_H], state[REG_L] = hld(state[REG_H], state[REG_L])
	state[REG_A] = mmu_read8(state, HL)
end

LD[0x0E] = function(state)
	state[REG_C] = read_n8(state)
end

LD[0x1E] = function(state)
	state[REG_E] = read_n8(state)
end

LD[0x2E] = function(state)
	state[REG_L] = read_n8(state)
end

LD[0x3E] = function(state)
	state[REG_A] = read_n8(state)
end

LD[0xE0] = function(state)
	mmu_write8(state, 0xFF00 + read_n8(state), state[REG_A])
end

LD[0xF0] = function(state)
	state[REG_A] = mmu_read8(state, 0xFF00 + read_n8(state))
end

LD[0xE2] = function(state)
	mmu_write8(state, 0xFF00 + state[REG_C], state[REG_A])
end

LD[0xF2] = function(state)
	state[REG_A] = mmu_read8(state, 0xFF00 + state[REG_C])
end

LD[0xEA] = function(state)
	mmu_write8(state, read_n16(state), state[REG_A])
end

LD[0xFA] = function(state)
	state[REG_A] = mmu_read8(state, read_n16(state))
end

-- 16-bit LD instructions
LD[0x01] = function(state)
	state[REG_C] = read_n8(state)
	state[REG_B] = read_n8(state)
end

LD[0x11] = function(state)
	state[REG_E] = read_n8(state)
	state[REG_D] = read_n8(state)
end

LD[0x21] = function(state)
	state[REG_L] = read_n8(state)
	state[REG_H] = read_n8(state)
end

LD[0x31] = function(state)
	state[REG_SP] = read_n16(state)
end

LD[0xF8] = function(state)
	local sp = state[REG_SP]
	ARITH[0xE8](state)
	state[REG_H] = bit32.rshift(state[REG_SP], 8)
	state[REG_L] = bit32.band(state[REG_SP], 0xFF)
	state[REG_SP] = sp
end

LD[0xF9] = function(state)
	state[REG_SP] = r16(state[REG_H], state[REG_L])
end

LD[0x08] = function(state)
	mmu_write16(state, read_n16(state), state[REG_SP])
end

return LD
