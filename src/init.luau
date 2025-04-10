local Common = require("./common")
local Z80 = require("./z80")
local MMU = require("./mmu")

type GBState = Common.GBState

local Z80_step = Z80.step

local function init(rom: buffer): GBState
	local state = {} :: GBState

	Z80.init(state)
	MMU.init(state, rom)

	return state
end

local function step(state: GBState): ()
	Z80_step(state)
end

local function run(state: GBState): ()
	while state[CLOCK_M] < state[TARGET_CLOCK_M] do
		step(state)
	end
end

return {
	Common = Common,
	Z80 = Z80,
	MMU = MMU,
	init = init,
	step = step,
	run = run,
}
