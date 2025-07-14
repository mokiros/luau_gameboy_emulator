local GlobalCommon = require("../common")

type GBState = GlobalCommon.GBState

export type MemoryReadHandler = (state: GlobalCommon.GBState, addr: number) -> number
export type MemoryWriteHandler = (state: GlobalCommon.GBState, addr: number, value: number) -> ()

export type MemoryReadHandlers = { [number]: MemoryReadHandler }
export type MemoryWriteHandlers = { [number]: MemoryWriteHandler }

local function read_noop()
	return 0
end
local function noop() end

local MMU_READ = table.create(0x10000, if _G.DEBUG then nil else read_noop) :: MemoryReadHandlers
local MMU_WRITE = table.create(0x10000, if _G.DEBUG then nil else noop) :: MemoryWriteHandlers

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

local function read16(state: GBState, addr: number): number
	return u16(read8(state, addr), read8(state, addr + 1))
end

local function write16(state: GBState, addr: number, value: number): ()
	write8(state, addr, if _G.USE_BIT32 then bit32.band(value, 0xFF) else value % 0x100)
	write8(state, addr + 1, if _G.USE_BIT32 then bit32.rshift(value, 8) else value // 0x100)
end

local Common = {
	MMU_READ = MMU_READ,
	MMU_WRITE = MMU_WRITE,
	noop = noop,
	read_noop = read_noop,
	read8 = read8,
	write8 = write8,
	read16 = read16,
	write16 = write16,
}

return Common
