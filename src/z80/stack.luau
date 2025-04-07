local Common = require("./common")
local r16 = Common.r16
local stack_push16 = Common.stack_push16

local MMU = require("../mmu")
local mmu_read8 = MMU.read8

local STACK = Common.INSTRUCTIONS

STACK[0xC5] = function(state)
	stack_push16(state, r16(state[REG_B], state[REG_C]))
end

STACK[0xD5] = function(state)
	stack_push16(state, r16(state[REG_D], state[REG_E]))
end

STACK[0xE5] = function(state)
	stack_push16(state, r16(state[REG_H], state[REG_L]))
end

STACK[0xF5] = function(state)
	stack_push16(state, r16(state[REG_A], state[REG_F]))
end

STACK[0xC1] = function(state)
	state[REG_C] = mmu_read8(state, state[REG_SP])
	state[REG_B] = mmu_read8(state, state[REG_SP] + 1)
	state[REG_SP] += 2
end

STACK[0xD1] = function(state)
	state[REG_E] = mmu_read8(state, state[REG_SP])
	state[REG_D] = mmu_read8(state, state[REG_SP] + 1)
	state[REG_SP] += 2
end

STACK[0xE1] = function(state)
	state[REG_L] = mmu_read8(state, state[REG_SP])
	state[REG_H] = mmu_read8(state, state[REG_SP] + 1)
	state[REG_SP] += 2
end

STACK[0xF1] = function(state)
	state[REG_F] = if _G.USE_BIT32
		then bit32.band(mmu_read8(state, state[REG_SP]), 0b1111_0000)
		else mmu_read8(state, state[REG_SP]) // 16 * 16
	state[REG_A] = mmu_read8(state, state[REG_SP] + 1)
	state[REG_SP] += 2
end

return true
