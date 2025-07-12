local Common = require("./common")
local r16 = Common.r16
local read_n8 = Common.read_n8
local read_e8 = Common.read_e8

local MMU = require("../mmu/common")
local mmu_read8 = MMU.read8

local ARITH = Common.INSTRUCTIONS

local function flag_z(value)
	return if _G.NO_BRANCHED_EXPRESSIONS and _G.USE_BIT32
		then (bit32.rshift(bit32.band(bit32.bnot(bit32.band(value, 0xFF) + 0xFF), 0b1_0000_0000), 1))
		elseif _G.NO_BRANCHED_EXPRESSIONS and not _G.USE_BIT32 then ((1 - ((value % 0x100) + 0xFF) // 0x100) * 0b1000_0000)
		elseif _G.USE_BIT32 then (if bit32.band(value, 0xFF) == 0 then 0b1000_0000 else 0)
		else (if value % 0x100 == 0 then 0b1000_0000 else 0)
end

---#inline
local function add_to_a(state, value)
	local sum = state[REG_A] + value
	state[REG_F] = if _G.NO_BRANCHED_EXPRESSIONS and _G.USE_BIT32
		then bit32.bor(
			flag_z(sum),
			bit32.lshift(bit32.band(bit32.band(state[REG_A], 0xF) + bit32.band(value, 0xF), 0b0001_0000), 1),
			bit32.rshift(bit32.band(sum, 0b1_0000_0000), 4)
		)
		elseif _G.NO_BRANCHED_EXPRESSIONS and not _G.USE_BIT32 then (
			flag_z(sum)
			+ (state[REG_A] % 0x10 + value % 0x10) // 0x10 * 0b0010_0000
			+ sum // 0x100 * 0b0001_0000
		)
		elseif _G.USE_BIT32 then bit32.bor(
			flag_z(sum),
			(if bit32.band(state[REG_A], 0xF) + bit32.band(value, 0xF) > 0xF then 0b0010_0000 else 0),
			(if sum > 0xFF then 0b0001_0000 else 0)
		)
		else (flag_z(sum) + (if state[REG_A] % 0x10 + value % 0x10 > 0xF then 0b0010_0000 else 0) + (if sum > 0xFF
			then 0b0001_0000
			else 0))

	state[REG_A] = if _G.USE_BIT32 then bit32.band(sum, 0xFF) else sum % 0x100
end

ARITH[0x80] = function(state)
	add_to_a(state, state[REG_B])
end

ARITH[0x81] = function(state)
	add_to_a(state, state[REG_C])
end

ARITH[0x82] = function(state)
	add_to_a(state, state[REG_D])
end

ARITH[0x83] = function(state)
	add_to_a(state, state[REG_E])
end

ARITH[0x84] = function(state)
	add_to_a(state, state[REG_H])
end

ARITH[0x85] = function(state)
	add_to_a(state, state[REG_L])
end

ARITH[0x86] = function(state)
	add_to_a(state, mmu_read8(state, r16(state[REG_H], state[REG_L])))
end

ARITH[0x87] = function(state)
	add_to_a(state, state[REG_A])
end

ARITH[0xC6] = function(state)
	add_to_a(state, read_n8(state))
end

---#inline
local function adc_to_a(state, value)
	local carry = (if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else (state[REG_F] // 0x10) % 2)
	local sum = state[REG_A] + value + carry

	state[REG_F] = if _G.NO_BRANCHED_EXPRESSIONS and _G.USE_BIT32
		then bit32.bor(
			flag_z(sum),
			bit32.lshift(bit32.band(bit32.band(state[REG_A], 0xF) + bit32.band(value, 0xF) + carry, 0b0001_0000), 1),
			bit32.rshift(bit32.band(sum, 0b1_0000_0000), 4)
		)
		elseif _G.NO_BRANCHED_EXPRESSIONS and not _G.USE_BIT32 then (
			flag_z(sum)
			+ (state[REG_A] % 0x10 + value % 0x10 + carry) // 0x10 * 0b0010_0000
			+ sum // 0x100 * 0b0001_0000
		)
		elseif _G.USE_BIT32 then bit32.bor(
			flag_z(sum),
			(if bit32.band(state[REG_A], 0xF) + bit32.band(value, 0xF) + carry > 0xF then 0b0010_0000 else 0),
			(if sum > 0xFF then 0b0001_0000 else 0)
		)
		else (flag_z(sum) + (if state[REG_A] % 0x10 + value % 0x10 + carry > 0xF then 0b0010_0000 else 0) + (if sum
				> 0xFF
			then 0b0001_0000
			else 0))

	state[REG_A] = if _G.USE_BIT32 then bit32.band(sum, 0xFF) else sum % 0x100
end

ARITH[0x88] = function(state)
	adc_to_a(state, state[REG_B])
end

ARITH[0x89] = function(state)
	adc_to_a(state, state[REG_C])
end

ARITH[0x8A] = function(state)
	adc_to_a(state, state[REG_D])
end

ARITH[0x8B] = function(state)
	adc_to_a(state, state[REG_E])
end

ARITH[0x8C] = function(state)
	adc_to_a(state, state[REG_H])
end

ARITH[0x8D] = function(state)
	adc_to_a(state, state[REG_L])
end

ARITH[0x8E] = function(state)
	adc_to_a(state, mmu_read8(state, r16(state[REG_H], state[REG_L])))
end

ARITH[0x8F] = function(state)
	adc_to_a(state, state[REG_A])
end

ARITH[0xCE] = function(state)
	adc_to_a(state, read_n8(state))
end

---#inline
local function sub_from_a(state, value)
	local sum = state[REG_A] - value

	state[REG_F] = if _G.NO_BRANCHED_EXPRESSIONS and _G.USE_BIT32
		then bit32.bor(
			flag_z(sum),
			bit32.lshift(bit32.band(bit32.band(state[REG_A], 0xF) - bit32.band(value, 0xF), 0b0001_0000), 1),
			bit32.rshift(bit32.band(sum, 0b1_0000_0000), 4),
			0b0100_0000
		)
		elseif _G.NO_BRANCHED_EXPRESSIONS and not _G.USE_BIT32 then (
			flag_z(sum)
			+ (1 - (state[REG_A] % 0x10 - value % 0x10 + 0x10) // 0x10) * 0b0010_0000
			+ (1 - (sum + 0x100) // 0x100) * 0b0001_0000
			+ 0b0100_0000
		)
		elseif _G.USE_BIT32 then bit32.bor(
			flag_z(sum),
			(if bit32.band(state[REG_A], 0xF) - bit32.band(value, 0xF) < 0 then 0b0010_0000 else 0),
			(if sum < 0 then 0b0001_0000 else 0),
			0b0100_0000
		)
		else (flag_z(sum) + (if state[REG_A] % 0x10 - value % 0x10 < 0 then 0b0010_0000 else 0) + (if sum < 0
			then 0b0001_0000
			else 0) + 0b0100_0000)

	state[REG_A] = if _G.USE_BIT32 then bit32.band(sum, 0xFF) else sum % 256
end

ARITH[0x90] = function(state)
	sub_from_a(state, state[REG_B])
end

ARITH[0x91] = function(state)
	sub_from_a(state, state[REG_C])
end

ARITH[0x92] = function(state)
	sub_from_a(state, state[REG_D])
end

ARITH[0x93] = function(state)
	sub_from_a(state, state[REG_E])
end

ARITH[0x94] = function(state)
	sub_from_a(state, state[REG_H])
end

ARITH[0x95] = function(state)
	sub_from_a(state, state[REG_L])
end

ARITH[0x96] = function(state)
	sub_from_a(state, mmu_read8(state, r16(state[REG_H], state[REG_L])))
end

ARITH[0x97] = function(state)
	sub_from_a(state, state[REG_A])
end

ARITH[0xD6] = function(state)
	sub_from_a(state, read_n8(state))
end

---#inline
local function sbc_from_a(state, value)
	local carry = (if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else (state[REG_F] // 0x10) % 0x2)
	local sum = state[REG_A] - value - carry

	state[REG_F] = if _G.NO_BRANCHED_EXPRESSIONS and _G.USE_BIT32
		then bit32.bor(
			flag_z(sum),
			bit32.lshift(bit32.band(bit32.band(state[REG_A], 0xF) - bit32.band(value, 0xF) - carry, 0b0001_0000), 1),
			bit32.rshift(bit32.band(sum, 0b1_0000_0000), 4),
			0b0100_0000
		)
		elseif _G.NO_BRANCHED_EXPRESSIONS and not _G.USE_BIT32 then (
			flag_z(sum)
			+ (1 - (state[REG_A] % 0x10 - value % 0x10 - carry + 0x10) // 0x10) * 0b0010_0000
			+ (1 - (sum + 0x100) // 0x100) * 0b0001_0000
			+ 0b0100_0000
		)
		elseif _G.USE_BIT32 then bit32.bor(
			flag_z(sum),
			(if bit32.band(state[REG_A], 0xF) - bit32.band(value, 0xF) - carry < 0 then 0b0010_0000 else 0),
			(if sum < 0 then 0b0001_0000 else 0),
			0b0100_0000
		)
		else ((if sum % 256 == 0 then 0b1000_0000 else 0) + (if state[REG_A] % 0x10 - value % 0x10 - carry < 0
			then 0b0010_0000
			else 0) + (if sum < 0 then 0b0001_0000 else 0) + 0b0100_0000)

	state[REG_A] = if _G.USE_BIT32 then bit32.band(sum, 0xFF) else sum % 0x100
end

ARITH[0x98] = function(state)
	sbc_from_a(state, state[REG_B])
end

ARITH[0x99] = function(state)
	sbc_from_a(state, state[REG_C])
end

ARITH[0x9A] = function(state)
	sbc_from_a(state, state[REG_D])
end

ARITH[0x9B] = function(state)
	sbc_from_a(state, state[REG_E])
end

ARITH[0x9C] = function(state)
	sbc_from_a(state, state[REG_H])
end

ARITH[0x9D] = function(state)
	sbc_from_a(state, state[REG_L])
end

ARITH[0x9E] = function(state)
	sbc_from_a(state, mmu_read8(state, r16(state[REG_H], state[REG_L])))
end

ARITH[0x9F] = function(state)
	sbc_from_a(state, state[REG_A])
end

ARITH[0xDE] = function(state)
	sbc_from_a(state, read_n8(state))
end

ARITH[0x27] = function(state)
	local a = state[REG_A]
	local f = state[REG_F]

	local n = bit32.extract(f, 6)
	local h = bit32.extract(f, 5)
	local c = bit32.extract(f, 4)

	if n == 0 then
		-- Addition mode
		if h ~= 0 or bit32.band(a, 0x0F) > 0x09 then
			a += 0x06
		end
		if c ~= 0 or a > 0x9F then
			a += 0x60
		end
	else
		-- Subtraction mode
		a = if _G.USE_BIT32 then bit32.band(a - h * 0x06, 0xFF) else (a - h * 0x06) % 256
		a -= c * 0x60
	end

	state[REG_A] = if _G.USE_BIT32 then bit32.band(a, 0xFF) else a % 256
	state[REG_F] = if _G.USE_BIT32
		then bit32.bor(flag_z(a), bit32.band(f, 0x40), if a > 0xFF or a < 0 then 0x10 else bit32.lshift(c, 4))
		else flag_z(a) + n * 0x40 + (if a > 0xFF or a < 0 then 0x10 else c * 0x10)
end

---#inline
local function add_to_hl(state, value)
	local hl = r16(state[REG_H], state[REG_L])
	local sum = hl + value

	state[REG_F] = (state[REG_F] // 128 * 0b1000_0000)
		+ (if (hl % 0x1000 + value % 0x1000) > 0xFFF then 0b0010_0000 else 0)
		+ (if sum > 0xFFFF or sum < 0 then 0b0001_0000 else 0)

	hl = sum % 0x10000
	state[REG_H] = hl // 256
	state[REG_L] = hl % 256
end

ARITH[0x09] = function(state)
	add_to_hl(state, r16(state[REG_B], state[REG_C]))
end

ARITH[0x19] = function(state)
	add_to_hl(state, r16(state[REG_D], state[REG_E]))
end

ARITH[0x29] = function(state)
	add_to_hl(state, r16(state[REG_H], state[REG_L]))
end

ARITH[0x39] = function(state)
	add_to_hl(state, state[REG_SP])
end

ARITH[0x03] = function(state)
	state[REG_B] = (state[REG_B] + (state[REG_C] + 1) // 256) % 256
	state[REG_C] = (state[REG_C] + 1) % 256
end

ARITH[0x13] = function(state)
	state[REG_D] = (state[REG_D] + (state[REG_E] + 1) // 256) % 256
	state[REG_E] = (state[REG_E] + 1) % 256
end

ARITH[0x23] = function(state)
	state[REG_H] = (state[REG_H] + (state[REG_L] + 1) // 256) % 256
	state[REG_L] = (state[REG_L] + 1) % 256
end

ARITH[0x33] = function(state)
	state[REG_SP] = (state[REG_SP] + 1) % 0x10000
end

ARITH[0x0B] = function(state)
	state[REG_B] = (state[REG_B] + (state[REG_C] - 1) // 256) % 256
	state[REG_C] = (state[REG_C] - 1) % 256
end

ARITH[0x1B] = function(state)
	state[REG_D] = (state[REG_D] + (state[REG_E] - 1) // 256) % 256
	state[REG_E] = (state[REG_E] - 1) % 256
end

ARITH[0x2B] = function(state)
	state[REG_H] = (state[REG_H] + (state[REG_L] - 1) // 256) % 256
	state[REG_L] = (state[REG_L] - 1) % 256
end

ARITH[0x3B] = function(state)
	state[REG_SP] = (state[REG_SP] - 1) % 0x10000
end

ARITH[0xE8] = function(state)
	local offset = read_e8(state)

	local sp = state[REG_SP]

	state[REG_F] = if _G.USE_BIT32
		then (bit32.lshift(bit32.band(bit32.band(sp, 0xF) + bit32.band(offset, 0xF), 0x10), 1) + bit32.rshift(
			bit32.band(bit32.band(sp, 0xFF) + bit32.band(offset, 0xFF), 0x100),
			4
		))
		else ((if sp % 0x10 + offset % 0x10 > 0xF then 0b0010_0000 else 0) + (if sp % 0x100 + offset % 0x100 > 0xFF
			then 0b0001_0000
			else 0))

	state[REG_SP] = (sp + offset) % 0x10000
end

return true
