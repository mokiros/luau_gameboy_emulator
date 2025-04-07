local GlobalCommon = require("../common")
local Common = require("./common")
local read_n8 = Common.read_n8

type GBState = GlobalCommon.GBState

local MMU = require("../mmu")
local mmu_read8 = MMU.read8

local Z80 = {
	Common = Common,
}

local Instructions = Common.INSTRUCTIONS

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
	state[REG_STOP] = read_n8(state)
	coroutine.yield(0)
end

Instructions[0x3F] = function(state)
	state[REG_F] = bit32.bor(bit32.band(state[REG_F], 0b1000_0000), bit32.bxor(bit32.band(state[REG_F], 0b0001_0000), 0b0001_0000))
end

Instructions[0x37] = function(state)
	state[REG_F] = bit32.bor(bit32.band(state[REG_F], 0b1000_0000), 0b0001_0000)
end

Instructions[0x76] = function(state)
	error("FIXME: Implement HALT instruction")
end

Instructions[0xF3] = function(state)
	state[REG_INTERRUPTS] = 0
end

Instructions[0xFB] = function(state)
	state[REG_INTERRUPTS] = 1
	coroutine.yield(1)
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

	state[REG_STOP] = -1
	state[REG_INTERRUPTS] = 0
end

function Z80.run(state: GBState, instruction_count: number)
	local opcode: number = 0

	for _ = 1, instruction_count do
		opcode = mmu_read8(state, state[REG_PC])

		state[REG_PC] += 1

		Instructions[opcode](state)
	end
end

return Z80
