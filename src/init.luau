local Common = require("@self/common")
local Z80 = require("@self/z80")
local MMU = require("@self/mmu")
local PPU = require("@self/ppu")
local Timer = require("@self/timer")

type GBState = Common.GBState

local z80_init = Z80.init
local z80_step = Z80.step

local mmu_init = MMU.init

local ppu_init = PPU.init
local ppu_step = PPU.step

local timer_init = Timer.init
local timer_step = Timer.step

local function init(rom: buffer): GBState
	local state = {} :: GBState

	z80_init(state)
	mmu_init(state, rom)
	timer_init(state)
	ppu_init(state)

	return state
end

local function step(state: GBState): ()
	local cycles = z80_step(state)
	timer_step(state, cycles)
	ppu_step(state, cycles * 4)
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
	PPU = PPU,
	init = init,
	step = step,
	run = run,
}
