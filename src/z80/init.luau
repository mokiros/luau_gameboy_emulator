local GlobalCommon = require("../common")
local CONST_BUFFERS = require("../buffers")
local INSTRUCTION_TIMINGS_MCYCLE = CONST_BUFFERS.INSTRUCTION_TIMINGS_MCYCLE

local Common = require("./common")

type GBState = GlobalCommon.GBState

local MMU = require("../mmu")
local mmu_read8 = MMU.read8

local Interrupts = require("./interrupts")
local service_interrupt = Interrupts.service_interrupt

local Z80 = {
	Common = Common,
}

local Instructions = Common.INSTRUCTIONS

-- HACK: These are side effects. They probably shouldn't be.
require("./ld")
require("./jp")
require("./stack")
require("./call")
require("./arithmetic")
require("./bitwise")
require("./cp")
require("./inc_dec")
require("./rl_rr_cb")

Instructions[0x00] = function() end

Instructions[0x10] = function(state)
	state[REG_STOP] = true
	state[REG_PC] += 1
end

Instructions[0x3F] = function(state)
	state[REG_F] =
		bit32.bor(bit32.band(state[REG_F], 0b1000_0000), bit32.bxor(bit32.band(state[REG_F], 0b0001_0000), 0b0001_0000))
end

Instructions[0x37] = function(state)
	state[REG_F] = bit32.bor(bit32.band(state[REG_F], 0b1000_0000), 0b0001_0000)
end

Instructions[0x76] = function(state)
	state[REG_HALT] = true
end

Instructions[0xF3] = function(state)
	state[REG_IME] = false
end

Instructions[0xFB] = function(state)
	state[REG_IME_PENDING] = true
end

function Z80.init(state: GBState): ()
	state[REG_A] = 0x01
	state[REG_B] = 0x00
	state[REG_C] = 0x13
	state[REG_D] = 0x00
	state[REG_E] = 0xD8
	state[REG_H] = 0x01
	state[REG_L] = 0x4D
	state[REG_F] = 0b1011_0000
	state[REG_SP] = 0xFFFE
	state[REG_PC] = 0x0100

	state[REG_HALT] = false
	state[REG_STOP] = false

	state[REG_IME] = false
	state[REG_IE] = 0
	state[REG_IF] = 0

	state[CLOCK_M] = 0
	state[TARGET_CLOCK_M] = 0
end

function Z80.step(state: GBState)
	service_interrupt(state)

	if state[REG_HALT] then
		state[CLOCK_M] += 1
		return
	end

	if state[REG_IME_PENDING] then
		state[REG_IME] = true
		state[REG_IME_PENDING] = false
	end

	local opcode = mmu_read8(state, state[REG_PC])

	state[REG_PC] += 1

	if _G.DEBUG then
		local pc = state[REG_PC]
		if pc > 0xFFFF or pc < 0 then
			error(`PC register went out of bounds: {pc}`)
		end
	end

	Instructions[opcode](state)

	state[CLOCK_M] += buffer.readu8(INSTRUCTION_TIMINGS_MCYCLE, opcode)
end

return Z80
