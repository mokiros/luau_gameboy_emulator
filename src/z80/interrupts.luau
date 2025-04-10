local GlobalCommon = require("../common")

type GBState = GlobalCommon.GBState

local Common = require("./common")
local stack_push16 = Common.stack_push16

local MMU = require("../mmu")
local MMU_Common = require("../mmu/common")

local read8 = MMU.read8
local write8 = MMU.write8
local MMU_READ = MMU_Common.MMU_READ
local MMU_WRITE = MMU_Common.MMU_WRITE

local Interrupts = {}

local function service_interrupt(state: GBState): boolean
	local pending = bit32.band(state[REG_IE], state[REG_IF])
	if pending == 0 then
		return false
	end

	state[REG_HALT] = false

	if not state[REG_IME] then
		return false
	end

	state[REG_IME] = false

	local int_idx = bit32.countrz(pending) -- no point in a no-bit32 version, since it will be a loop
	if _G.DEBUG then
		if int_idx > 4 then
			error(string.format("Invalid interrupt pending value: %d; IE: %02X; IF: %02X", pending, state[REG_IE], state[REG_IF]))
		end
	end
	local int_addr = if _G.USE_BIT32 then bit32.bor(0x0040, bit32.lshift(int_idx, 3)) else 0x0040 + int_idx * 0x8

	-- clear the bit
	state[REG_IE] = if _G.USE_BIT32 then bit32.bxor(bit32.lshift(0x1, int_idx), state[REG_IE]) else state[REG_IE] - 2 ^ int_idx

	stack_push16(state, state[REG_PC])

	state[REG_PC] = int_addr

	state[CLOCK_M] += 3

	return true
end

local function raise_interrupt(state: GBState, bitmask: INT_IDX): ()
	write8(state, 0xFF0F, bit32.band(bit32.bor(read8(state, 0xFF0F), (bitmask :: unknown) :: number), 0x1F))
	service_interrupt(state)
end

Interrupts.service_interrupt = service_interrupt
Interrupts.raise_interrupt = raise_interrupt

MMU_READ[0xFF0F] = function(state, _)
	return bit32.bor(state[REG_IF], 0xE0)
end

MMU_WRITE[0xFF0F] = function(state, _, value)
	state[REG_IF] = bit32.band(value, 0x1F)
	service_interrupt(state)
end

MMU_READ[0xFFFF] = function(state, _)
	return state[REG_IE]
end

MMU_WRITE[0xFFFF] = function(state, _, value)
	state[REG_IE] = value
	service_interrupt(state)
end

return Interrupts
