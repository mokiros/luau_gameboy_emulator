local GlobalCommon = require("../common")
local Common = require("./common")

type GBState = GlobalCommon.GBState

local RAM = require("./ram")
local ROM = require("./rom")
local _SERIAL = require("./serial")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

local function u16(low: number, high: number): number
	return if _G.USE_BIT32 then bit32.bor(bit32.lshift(high, 8), low) else high * 0x100 + low
end

local function read8(state: GBState, addr: number): number
	return (if _G.DEBUG
		then (MMU_READ[addr] or error(string.format("MMU error: no READ handler found for address 0x%04X", addr)))
		else MMU_READ[addr])(state, addr)
end

local function write8(state: GBState, addr: number, value: number): ()
	(if _G.DEBUG
		then (MMU_WRITE[addr] or error(string.format("MMU error: no WRITE handler found for address 0x%04X", addr)))
		else MMU_WRITE[addr])(state, addr, value)
end

local MMU = {
	Common = Common,
	read8 = read8,
	write8 = write8,
}

function MMU.read16(state: GBState, addr: number): number
	return u16(read8(state, addr), read8(state, addr + 1))
end

function MMU.write16(state: GBState, addr: number, value: number): ()
	write8(state, addr, if _G.USE_BIT32 then bit32.band(value, 0xFF) else value % 0x100)
	write8(state, addr + 1, if _G.USE_BIT32 then bit32.rshift(value, 8) else value // 0x100)
end

function MMU.init(state: GBState, rom: buffer): ()
	state[MEMORY_WRAM] = buffer.create(RAM.WRAM_SIZE)
	state[MEMORY_VRAM] = buffer.create(RAM.VRAM_SIZE)
	state[MEMORY_HRAM] = buffer.create(RAM.HRAM_SIZE)

	state[SERIAL_VALUE] = 0
	state[SERIAL_DATA] = ""

	ROM.load_rom(state, rom)
end

return MMU
