local Common = require("./common")
type GBState = Common.GBState

local Interrupts = require("./z80/interrupts")
local raise_interrupt = Interrupts.raise_interrupt

-- Timer frequencies (in M-cycles)
local TIMER_FREQUENCIES = {
	[0b00] = 256,
	[0b01] = 4,
	[0b10] = 16,
	[0b11] = 64,
}

local function init(state: GBState)
	state[CLOCK_M] = 0
	state[TARGET_CLOCK_M] = 0
	state[REG_DIV] = 0
	state[REG_TIMA] = 0
	state[REG_TMA] = 0
	state[REG_TAC] = 0
	state[TIMA_COUNTER] = 0
end

local function step(state: GBState, mcycles: number)
	state[CLOCK_M] += mcycles
	state[REG_DIV] += mcycles

	local tma_counter = state[TIMA_COUNTER] + mcycles

	-- TODO: Test for correctness
	if bit32.band(state[REG_TAC], 0b100) ~= 0 then
		local freq = TIMER_FREQUENCIES[bit32.band(state[REG_TAC], 0b11)]
		state[REG_TIMA] += tma_counter // freq
		tma_counter %= freq

		while state[REG_TIMA] > 0xFF do
			raise_interrupt(state, INT_TIMER)
			state[REG_TIMA] = state[REG_TIMA] - 0x100 + state[REG_TMA]
		end
	end

	state[TIMA_COUNTER] = tma_counter
end

return {
	init = init,
	step = step,
}
