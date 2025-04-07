local Common = require("./common")
local REG_A = REG_A
local r16 = Common.r16

local MMU = require("../mmu")
local mmu_read8 = MMU.read8
local mmu_write8 = MMU.write8

local ID = Common.INSTRUCTIONS

---#inline
local function flag_z(value)
	return if value ~= 0 then 0b0000_0000 else 0b1000_0000
end

---#inline
local function flag_h_inc(value)
	return if _G.USE_BIT32
		then (if bit32.band(value, 0xF) == 0 then 0b0010_0000 else 0)
		else (if value % 0x10 == 0 then 0b0010_0000 else 0)
end

---#inline
local function flag_h_dec(value)
	return if _G.USE_BIT32
		then (if bit32.band(value, 0xF) == 0xF then 0b0010_0000 else 0)
		else (if value % 0x10 == 0xF then 0b0010_0000 else 0)
end

local flag_n = 0b0100_0000

---#inline
local function set_flags_inc(state, value)
	state[REG_F] = if _G.USE_BIT32
		then (bit32.bor(flag_z(value), flag_h_inc(value), bit32.band(state[REG_F], 0b0001_0000)))
		else (flag_z(value) + flag_h_inc(value) + state[REG_F] % 0b0010_0000)
end

---#inline
local function set_flags_dec(state, value)
	state[REG_F] = if _G.USE_BIT32
		then (bit32.bor(flag_z(value), flag_n, flag_h_dec(value), bit32.band(state[REG_F], 0b0001_0000)))
		else (flag_z(value) + 0b0100_0000 + flag_h_dec(value) + state[REG_F] % 0b0010_0000)
end

---#inline
local function inc_reg(state, reg_idx)
	local v = if _G.USE_BIT32 then bit32.band(state[reg_idx] + 1, 0xFF) else (state[reg_idx] + 1) % 256
	state[reg_idx] = v
	set_flags_inc(state, v)
end

ID[0x04] = function(state)
	inc_reg(state, REG_B)
end

ID[0x0C] = function(state)
	inc_reg(state, REG_C)
end

ID[0x14] = function(state)
	inc_reg(state, REG_D)
end

ID[0x1C] = function(state)
	inc_reg(state, REG_E)
end

ID[0x24] = function(state)
	inc_reg(state, REG_H)
end

ID[0x2C] = function(state)
	inc_reg(state, REG_L)
end

ID[0x34] = function(state)
	local hl = r16(state[REG_H], state[REG_L])
	local v = (mmu_read8(state, hl) + 1) % 256
	mmu_write8(state, hl, v)
	set_flags_inc(state, v)
end

ID[0x3C] = function(state)
	inc_reg(state, REG_A)
end

---#inline
local function dec_reg(state, reg_idx)
	local v = (state[reg_idx] - 1) % 256
	state[reg_idx] = v
	set_flags_dec(state, v)
end

ID[0x05] = function(state)
	dec_reg(state, REG_B)
end

ID[0x0D] = function(state)
	dec_reg(state, REG_C)
end

ID[0x15] = function(state)
	dec_reg(state, REG_D)
end

ID[0x1D] = function(state)
	dec_reg(state, REG_E)
end

ID[0x25] = function(state)
	dec_reg(state, REG_H)
end

ID[0x2D] = function(state)
	dec_reg(state, REG_L)
end

ID[0x35] = function(state)
	local hl = r16(state[REG_H], state[REG_L])
	local v = (mmu_read8(state, hl) - 1) % 256
	mmu_write8(state, hl, v)
	set_flags_dec(state, v)
end

ID[0x3D] = function(state)
	dec_reg(state, REG_A)
end

return true
