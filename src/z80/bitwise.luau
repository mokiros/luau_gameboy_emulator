local Common = require("./common")
local read_n8 = Common.read_n8
local read_at_hl = Common.read_at_hl

local BW = Common.INSTRUCTIONS

local function reg_a_and(state, value)
	state[REG_A] = bit32.band(state[REG_A], value)
	state[REG_F] = if state[REG_A] == 0 then 0b1010_0000 else 0b0010_0000
end

BW[0xA0] = function(state)
	reg_a_and(state, state[REG_B])
end

BW[0xA1] = function(state)
	reg_a_and(state, state[REG_C])
end

BW[0xA2] = function(state)
	reg_a_and(state, state[REG_D])
end

BW[0xA3] = function(state)
	reg_a_and(state, state[REG_E])
end

BW[0xA4] = function(state)
	reg_a_and(state, state[REG_H])
end

BW[0xA5] = function(state)
	reg_a_and(state, state[REG_L])
end

BW[0xA6] = function(state)
	reg_a_and(state, read_at_hl(state))
end

BW[0xA7] = function(state)
	reg_a_and(state, state[REG_A])
end

BW[0xE6] = function(state)
	reg_a_and(state, read_n8(state))
end

local function reg_a_xor(state, value)
	state[REG_A] = bit32.bxor(state[REG_A], value)
	state[REG_F] = if state[REG_A] == 0 then 0b1000_0000 else 0b0000_0000
end

BW[0xA8] = function(state)
	reg_a_xor(state, state[REG_B])
end

BW[0xA9] = function(state)
	reg_a_xor(state, state[REG_C])
end

BW[0xAA] = function(state)
	reg_a_xor(state, state[REG_D])
end

BW[0xAB] = function(state)
	reg_a_xor(state, state[REG_E])
end

BW[0xAC] = function(state)
	reg_a_xor(state, state[REG_H])
end

BW[0xAD] = function(state)
	reg_a_xor(state, state[REG_L])
end

BW[0xAE] = function(state)
	reg_a_xor(state, read_at_hl(state))
end

BW[0xAF] = function(state)
	reg_a_xor(state, state[REG_A])
end

BW[0xEE] = function(state)
	reg_a_xor(state, read_n8(state))
end

local function reg_a_or(state, value)
	state[REG_A] = bit32.bor(state[REG_A], value)
	state[REG_F] = if state[REG_A] == 0 then 0b1000_0000 else 0b0000_0000
end

BW[0xB0] = function(state)
	reg_a_or(state, state[REG_B])
end

BW[0xB1] = function(state)
	reg_a_or(state, state[REG_C])
end

BW[0xB2] = function(state)
	reg_a_or(state, state[REG_D])
end

BW[0xB3] = function(state)
	reg_a_or(state, state[REG_E])
end

BW[0xB4] = function(state)
	reg_a_or(state, state[REG_H])
end

BW[0xB5] = function(state)
	reg_a_or(state, state[REG_L])
end

BW[0xB6] = function(state)
	reg_a_or(state, read_at_hl(state))
end

BW[0xB7] = function(state)
	reg_a_or(state, state[REG_A])
end

BW[0xF6] = function(state)
	reg_a_or(state, read_n8(state))
end

BW[0x2F] = function(state)
	state[REG_A] = bit32.bxor(state[REG_A], 0xFF)
	state[REG_F] = bit32.bor(state[REG_F], 0b0110_0000)
end

return true
