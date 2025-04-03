local GlobalCommon = require("../common")
type GBState = GlobalCommon.GBState

local Common = require("./common")
local read_n8 = Common.read_n8
local read_hla = Common.read_hla
local write_hla = Common.write_hla

local ROTATE: Common.InstructionSet = {}

---#inline
local function flag_z(value)
	return if value ~= 0 then 0b0000_0000 else 0b1000_0000
end

ROTATE[0x07] = if _G.USE_BIT32
	then function(state)
		local c = bit32.rshift(state[REG_A], 7)
		state[REG_A] = bit32.band(bit32.bor(bit32.lshift(state[REG_A], 1), c), 0xFF)
		state[REG_F] = bit32.lshift(c, 4)
	end
	else function(state)
		local c = state[REG_A] // 0x80
		state[REG_A] = (state[REG_A] * 2 + c) % 0x100
		state[REG_F] = c * 0b0001_0000
	end

ROTATE[0x17] = if _G.USE_BIT32
	then function(state)
		state[REG_F], state[REG_A] =
			bit32.lshift(bit32.rshift(state[REG_A], 7), 4),
			bit32.band(bit32.bor(bit32.lshift(state[REG_A], 1), bit32.extract(state[REG_F], 4)), 0xFF)
	end
	else function(state)
		state[REG_F], state[REG_A] =
			(state[REG_A] // 0x80) * 0b0001_0000, (state[REG_A] * 2 + (state[REG_F] % 0x20) // 0x10) % 0x100
	end

ROTATE[0x0F] = if _G.USE_BIT32
	then function(state)
		local c = bit32.band(state[REG_A], 0x1)
		state[REG_A] = bit32.band(bit32.bor(bit32.rshift(state[REG_A], 1), bit32.lshift(c, 7)), 0xFF)
		state[REG_F] = bit32.lshift(c, 4)
	end
	else function(state)
		local carry = state[REG_A] % 2
		state[REG_A] = (state[REG_A] // 2 + carry * 0x80) % 0x100
		state[REG_F] = carry * 0b0001_0000
	end

ROTATE[0x1F] = if _G.USE_BIT32
	then function(state)
		state[REG_F], state[REG_A] =
			bit32.lshift(bit32.band(state[REG_A], 0x1), 4),
			bit32.band(bit32.bor(bit32.rshift(state[REG_A], 1), bit32.lshift(bit32.extract(state[REG_F], 4), 7)), 0xFF)
	end
	else function(state)
		state[REG_F], state[REG_A] = (state[REG_A] % 2) * 0b0001_0000, (state[REG_A] // 2 + (state[REG_F] % 0x20) * 0x8) % 0x100
	end

local CB: Common.InstructionSet = {}

local reg_rlc: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.rshift(state[idx], 7)
		state[idx] = bit32.band(bit32.bor(bit32.lshift(state[idx], 1), c), 0xFF)
		state[REG_F] = bit32.bor(flag_z(state[idx]), bit32.lshift(c, 4))
	end
	else function(state, idx)
		local c = state[idx] // 0x80
		state[idx] = (state[idx] * 2 + c) % 0x100
		state[REG_F] = flag_z(state[idx]) + c * 0b0001_0000
	end

local reg_rl: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.rshift(state[idx], 7)
		state[idx] = bit32.band(bit32.bor(bit32.lshift(state[idx], 1), bit32.extract(state[REG_F], 4)), 0xFF)
		state[REG_F] = bit32.bor(flag_z(state[idx]), bit32.lshift(c, 4))
	end
	else function(state, idx)
		local c = (state[idx] // 0x80) * 0b0001_0000
		state[idx] = (state[idx] * 2 + (state[REG_F] % 0x20) // 0x10) % 0x100
		state[REG_F] = flag_z(state[idx]) + c
	end

local reg_rrc: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.band(state[idx], 0x1)
		state[idx] = bit32.band(bit32.bor(bit32.rshift(state[idx], 1), bit32.lshift(c, 7)), 0xFF)
		state[REG_F] = bit32.bor(flag_z(state[idx]), bit32.lshift(c, 4))
	end
	else function(state, idx)
		local c = state[idx] % 2
		state[idx] = (state[idx] // 2 + c * 0x80) % 0x100
		state[REG_F] = flag_z(state[idx]) + c * 0b0001_0000
	end

local reg_rr: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.lshift(bit32.band(state[idx], 0x1), 4)
		state[idx] = bit32.band(bit32.bor(bit32.rshift(state[idx], 1), bit32.lshift(bit32.extract(state[REG_F], 4), 7)), 0xFF)
		state[REG_F] = bit32.bor(flag_z(state[idx]), c)
	end
	else function(state, idx)
		local c = (state[idx] % 2) * 0b0001_0000
		state[idx] = (state[idx] // 2 + (state[REG_F] % 0x20) * 0x8) % 0x100
		state[REG_F] = flag_z(state[idx]) + c
	end

CB[0x00] = function(state)
	reg_rlc(state, REG_B)
end

CB[0x01] = function(state)
	reg_rlc(state, REG_C)
end

CB[0x02] = function(state)
	reg_rlc(state, REG_D)
end

CB[0x03] = function(state)
	reg_rlc(state, REG_E)
end

CB[0x04] = function(state)
	reg_rlc(state, REG_H)
end

CB[0x05] = function(state)
	reg_rlc(state, REG_L)
end

CB[0x06] = function(state)
	read_hla(state)
	reg_rlc(state, REG_HLA)
	write_hla(state)
end

CB[0x07] = function(state)
	reg_rlc(state, REG_A)
end

CB[0x08] = function(state)
	reg_rrc(state, REG_B)
end

CB[0x09] = function(state)
	reg_rrc(state, REG_C)
end

CB[0x0A] = function(state)
	reg_rrc(state, REG_D)
end

CB[0x0B] = function(state)
	reg_rrc(state, REG_E)
end

CB[0x0C] = function(state)
	reg_rrc(state, REG_H)
end

CB[0x0D] = function(state)
	reg_rrc(state, REG_L)
end

CB[0x0E] = function(state)
	read_hla(state)
	reg_rrc(state, REG_HLA)
	write_hla(state)
end

CB[0x0F] = function(state)
	reg_rrc(state, REG_A)
end

CB[0x10] = function(state)
	reg_rl(state, REG_B)
end

CB[0x11] = function(state)
	reg_rl(state, REG_C)
end

CB[0x12] = function(state)
	reg_rl(state, REG_D)
end

CB[0x13] = function(state)
	reg_rl(state, REG_E)
end

CB[0x14] = function(state)
	reg_rl(state, REG_H)
end

CB[0x15] = function(state)
	reg_rl(state, REG_L)
end

CB[0x16] = function(state)
	read_hla(state)
	reg_rl(state, REG_HLA)
	write_hla(state)
end

CB[0x17] = function(state)
	reg_rl(state, REG_A)
end

CB[0x18] = function(state)
	reg_rr(state, REG_B)
end

CB[0x19] = function(state)
	reg_rr(state, REG_C)
end

CB[0x1A] = function(state)
	reg_rr(state, REG_D)
end

CB[0x1B] = function(state)
	reg_rr(state, REG_E)
end

CB[0x1C] = function(state)
	reg_rr(state, REG_H)
end

CB[0x1D] = function(state)
	reg_rr(state, REG_L)
end

CB[0x1E] = function(state)
	read_hla(state)
	reg_rr(state, REG_HLA)
	write_hla(state)
end

CB[0x1F] = function(state)
	reg_rr(state, REG_A)
end

local reg_sla: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.lshift(bit32.rshift(state[idx], 7), 4)
		state[idx] = bit32.band(bit32.lshift(state[idx], 1), 0xFF)
		state[REG_F] = bit32.bor(flag_z(state[idx]), c)
	end
	else function(state, idx)
		local c = state[idx] // 0x80 * 0x10
		state[idx] = (state[idx] * 0x2) % 0x100
		state[REG_F] = flag_z(state[idx]) + c
	end

local reg_srl: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		local c = bit32.lshift(bit32.band(state[idx], 1), 4)
		state[idx] = bit32.rshift(state[idx], 1)
		state[REG_F] = bit32.bor(flag_z(state[idx]), c)
	end
	else function(state, idx)
		local c = (state[idx] % 2) * 0b0001_0000
		state[idx] //= 2
		state[REG_F] = flag_z(state[idx]) + c
	end

local reg_sra: (GBState, REG_IDX) -> () = function(state, idx)
	reg_srl(state, idx)
	if state[idx] > 0x3F then
		state[idx] += 0x80
	end
end

local reg_swap: (GBState, REG_IDX) -> () = if _G.USE_BIT32
	then function(state, idx)
		state[REG_F], state[idx] =
			flag_z(state[idx]),
			bit32.bor(bit32.rshift(bit32.band(state[idx], 0xF0), 4), bit32.lshift(bit32.band(state[idx], 0x0F), 4))
	end
	else function(state, idx)
		state[REG_F], state[idx] = flag_z(state[idx]), state[idx] // 0x10 + (state[idx] % 0x10) * 0x10
	end

CB[0x20] = function(state)
	reg_sla(state, REG_B)
end

CB[0x21] = function(state)
	reg_sla(state, REG_C)
end

CB[0x22] = function(state)
	reg_sla(state, REG_D)
end

CB[0x23] = function(state)
	reg_sla(state, REG_E)
end

CB[0x24] = function(state)
	reg_sla(state, REG_H)
end

CB[0x25] = function(state)
	reg_sla(state, REG_L)
end

CB[0x26] = function(state)
	read_hla(state)
	reg_sla(state, REG_HLA)
	write_hla(state)
end

CB[0x27] = function(state)
	reg_sla(state, REG_A)
end

CB[0x28] = function(state)
	reg_sra(state, REG_B)
end

CB[0x29] = function(state)
	reg_sra(state, REG_C)
end

CB[0x2A] = function(state)
	reg_sra(state, REG_D)
end

CB[0x2B] = function(state)
	reg_sra(state, REG_E)
end

CB[0x2C] = function(state)
	reg_sra(state, REG_H)
end

CB[0x2D] = function(state)
	reg_sra(state, REG_L)
end

CB[0x2E] = function(state)
	read_hla(state)
	reg_sra(state, REG_HLA)
	write_hla(state)
end

CB[0x2F] = function(state)
	reg_sra(state, REG_A)
end

CB[0x30] = function(state)
	reg_swap(state, REG_B)
end

CB[0x31] = function(state)
	reg_swap(state, REG_C)
end

CB[0x32] = function(state)
	reg_swap(state, REG_D)
end

CB[0x33] = function(state)
	reg_swap(state, REG_E)
end

CB[0x34] = function(state)
	reg_swap(state, REG_H)
end

CB[0x35] = function(state)
	reg_swap(state, REG_L)
end

CB[0x36] = function(state)
	read_hla(state)
	reg_swap(state, REG_HLA)
	write_hla(state)
end

CB[0x37] = function(state)
	reg_swap(state, REG_A)
end

CB[0x38] = function(state)
	reg_srl(state, REG_B)
end

CB[0x39] = function(state)
	reg_srl(state, REG_C)
end

CB[0x3A] = function(state)
	reg_srl(state, REG_D)
end

CB[0x3B] = function(state)
	reg_srl(state, REG_E)
end

CB[0x3C] = function(state)
	reg_srl(state, REG_H)
end

CB[0x3D] = function(state)
	reg_srl(state, REG_L)
end

CB[0x3E] = function(state)
	read_hla(state)
	reg_srl(state, REG_HLA)
	write_hla(state)
end

CB[0x3F] = function(state)
	reg_srl(state, REG_A)
end

local BIT_OPS: { (GBState, number, number) -> () } = {}

-- test bit
BIT_OPS[0b01] = function(state, idx, bit)
	state[REG_F] = bit32.bor(
		bit32.lshift(bit32.bxor(bit32.extract(state[idx], bit), 0x1), 7),
		0b0010_0000,
		bit32.band(state[REG_F], 0b0001_0000)
	)
end

-- reset bit
BIT_OPS[0b10] = function(state, idx, bit)
	state[idx] = bit32.band(state[idx], bit32.bnot(bit32.lshift(0x1, bit)))
end

-- set bit
BIT_OPS[0b11] = function(state, idx, bit)
	state[idx] = bit32.bor(state[idx], bit32.lshift(0x1, bit))
end

ROTATE[0xCB] = function(state)
	local cb_opcode = read_n8(state)
	if cb_opcode < 0x40 then
		CB[cb_opcode](state)
		return
	end
	local op = bit32.rshift(cb_opcode, 6)
	local bit_idx = bit32.rshift(bit32.band(cb_opcode, 0b00_111_000), 3)
	local reg_idx = 1 + bit32.band(cb_opcode, 0b00_000_111)
	if reg_idx == ((REG_HLA :: unknown) :: number) then
		read_hla(state)
		BIT_OPS[op](state, reg_idx, bit_idx)
		write_hla(state)
	else
		BIT_OPS[op](state, reg_idx, bit_idx)
	end
end

return ROTATE
