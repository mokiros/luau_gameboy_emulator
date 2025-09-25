local GlobalCommon = require("./common")
type GBState = GlobalCommon.GBState

local CONST_BUFFERS = require("./buffers")
local INSTRUCTION_TIMINGS_MCYCLE = CONST_BUFFERS.INSTRUCTION_TIMINGS_MCYCLE
local CB_PREFIXED_INSTRUCTION_TIMINGS_MCYCLE = CONST_BUFFERS.CB_PREFIXED_INSTRUCTION_TIMINGS_MCYCLE

local Common = require("@self/common")
local INSTRUCTIONS = Common.INSTRUCTIONS

local MMU = require("./mmu/common")
local mmu_read8 = MMU.read8

local Interrupts = require("@self/interrupts")
local service_interrupt = Interrupts.service_interrupt


-- HACK: These are side effects. They probably shouldn't be.
require("@self/ld")
require("@self/jp")
require("@self/stack")
require("@self/call")
require("@self/arithmetic")
require("@self/bitwise")
require("@self/cp")
require("@self/inc_dec")
require("@self/rl_rr_cb")

INSTRUCTIONS[0x00] = function() end

INSTRUCTIONS[0x10] = function(state)
	state[REG_STOP] = true
	state[REG_PC] += 1
end

INSTRUCTIONS[0x3F] = function(state)
	state[REG_F] =
		bit32.bor(bit32.band(state[REG_F], 0b1000_0000), bit32.bxor(bit32.band(state[REG_F], 0b0001_0000), 0b0001_0000))
end

INSTRUCTIONS[0x37] = function(state)
	state[REG_F] = bit32.bor(bit32.band(state[REG_F], 0b1000_0000), 0b0001_0000)
end

INSTRUCTIONS[0x76] = function(state)
	state[REG_HALT] = true
end

INSTRUCTIONS[0xF3] = function(state)
	state[REG_IME] = false
end

INSTRUCTIONS[0xFB] = function(state)
	state[REG_IME_PENDING] = true
end

function z80_init(state: GBState): ()
	state[REG_A] = 0x00
	state[REG_B] = 0x00
	state[REG_C] = 0x00
	state[REG_D] = 0x00
	state[REG_E] = 0x00
	state[REG_H] = 0x00
	state[REG_L] = 0x00
	state[REG_F] = 0x00
	state[REG_SP] = 0xFFFE
	state[REG_PC] = 0x0000

	state[REG_HALT] = false
	state[REG_STOP] = false

	state[REG_IME] = false
	state[REG_IE] = 0
	state[REG_IF] = 0
end

function z80_step(state: GBState): number
	service_interrupt(state)

	if state[REG_HALT] then
		return 1
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

	local cb_opcode: number | nil = INSTRUCTIONS[opcode](state)

	local cb_timing = if cb_opcode then buffer.readu8(CB_PREFIXED_INSTRUCTION_TIMINGS_MCYCLE, cb_opcode) else 0

	return buffer.readu8(INSTRUCTION_TIMINGS_MCYCLE, opcode) + cb_timing
end

return {
	Common = Common,
	init = z80_init,
	step = z80_step,
}
