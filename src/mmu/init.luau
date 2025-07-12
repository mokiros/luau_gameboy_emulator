local GlobalCommon = require("../common")
local Common = require("./common")

type GBState = GlobalCommon.GBState

local RAM = require("./ram")
local ROM = require("./rom")
local _SERIAL = require("./serial")
local _TIMER = require("./timer")

local MMU = {
	Common = Common,
}

function MMU.init(state: GBState, rom: buffer): ()
	state[MEMORY_WRAM] = buffer.create(RAM.WRAM_SIZE)
	state[MEMORY_VRAM] = buffer.create(RAM.VRAM_SIZE)
	state[MEMORY_HRAM] = buffer.create(RAM.HRAM_SIZE)

	state[SERIAL_VALUE] = 0
	state[SERIAL_DATA] = ""

	ROM.load_rom(state, rom)
end

return MMU
