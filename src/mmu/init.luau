local GlobalCommon = require("./common")
local Common = require("@self/common")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE
local read_noop = Common.read_noop
local noop = Common.noop

type GBState = GlobalCommon.GBState

local RAM = require("@self/ram")
local ROM = require("@self/rom")
local _SERIAL = require("@self/serial")
local _TIMER = require("@self/timer")
local _INTERRUPTS = require("@self/interrupts")
local _PPU = require("@self/ppu")
local _AUDIO = require("@self/audio")

local MMU = {
	Common = Common,
}

-- Gameboy Color CPU speed switches
MMU_READ[0xFF4C] = read_noop
MMU_WRITE[0xFF4C] = noop
MMU_READ[0xFF4D] = read_noop
MMU_WRITE[0xFF4D] = noop

function MMU.init(state: GBState, rom: buffer): ()
	state[MEMORY_WRAM] = buffer.create(RAM.WRAM_SIZE)
	state[MEMORY_VRAM] = buffer.create(RAM.VRAM_SIZE)
	state[MEMORY_HRAM] = buffer.create(RAM.HRAM_SIZE)
	state[MEMORY_OAM] = buffer.create(RAM.OAM_SIZE)

	state[SERIAL_VALUE] = 0
	state[SERIAL_DATA] = ""

	ROM.load_rom(state, rom)
end

return MMU
