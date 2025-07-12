local Common = require("./common")
type GBState = Common.GBState

local Interrupts = require("./z80/interrupts")
local raise_interrupt = Interrupts.raise_interrupt

-- Timer frequencies (in T-cycles)
local TIMER_FREQUENCIES = {
	[0b00] = 0b10_0000_0000,
	[0b01] = 0b1_0000,
	[0b10] = 0b100_0000,
	[0b11] = 0b1_0000_0000,
}

local function init(state: GBState)
	state[CLOCK_M] = 0
	state[TARGET_CLOCK_M] = 0
	state[REG_DIV] = 0
	state[REG_TIMA] = 0
	state[REG_TMA] = 0
	state[REG_TAC] = 0
	state[TIMER_COUNTER] = 0
end

local function step(state: GBState, mcycles: number)
	state[CLOCK_M] += mcycles
	local prev_counter = state[TIMER_COUNTER]
	local tcycles = mcycles * 4
	local counter = bit32.band(prev_counter + tcycles, 0xFFFF)

	if bit32.band(state[REG_TAC], 0b100) ~= 0 then
		local freq = TIMER_FREQUENCIES[bit32.band(state[REG_TAC], 0b11)]
		local new_cycles = prev_counter % freq + tcycles
		local remaining = (0x100 - state[REG_TIMA]) * freq

		if new_cycles >= remaining then
			state[REG_TIMA] = state[REG_TMA]
			local extra_cycles = new_cycles - remaining
			counter -= extra_cycles
			state[CLOCK_M] -= extra_cycles // 4
			raise_interrupt(state, INT_TIMER)
		else
			state[REG_TIMA] += new_cycles // freq
		end
	end

	state[REG_DIV] = bit32.rshift(counter, 8)
	state[TIMER_COUNTER] = counter
end

return {
	init = init,
	step = step,
}
