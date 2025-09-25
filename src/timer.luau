local Common = require("./common")
type GBState = Common.GBState

local raise_interrupt = Common.raise_interrupt

-- Timer frequencies (in M-cycles)
local TIMER_FREQUENCIES = {
	[0b00] = 256,
	[0b01] = 4,
	[0b10] = 16,
	[0b11] = 64,
}

local function timer_init(state: GBState)
	state[CLOCK_M] = 0
	state[TARGET_CLOCK_M] = 0
	state[REG_DIV] = 0
	state[REG_TIMA] = 0
	state[REG_TMA] = 0
	state[REG_TAC] = 0
	state[TIMA_COUNTER] = 0
end

local function timer_step(state: GBState, mcycles: number)
	state[CLOCK_M] += mcycles
	state[REG_DIV] += mcycles

	local tma_counter = state[TIMA_COUNTER] + mcycles
	local freq = TIMER_FREQUENCIES[bit32.band(state[REG_TAC], 0b11)]
	local overflow_freq = tma_counter // freq
	state[TIMA_COUNTER] = tma_counter % freq

	-- TODO: Test for correctness
	if bit32.band(state[REG_TAC], 0b100) ~= 0 then
		state[REG_TIMA] += overflow_freq

		-- TODO: This can be done without a loop
		while state[REG_TIMA] > 0xFF do
			raise_interrupt(state, INT_TIMER)
			state[REG_TIMA] = state[REG_TIMA] - 0x100 + state[REG_TMA]
		end
	end
end

return {
	init = timer_init,
	step = timer_step,
}
