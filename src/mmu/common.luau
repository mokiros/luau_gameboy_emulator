local GlobalCommon = require("../common")

export type MemoryReadHandler = (state: GlobalCommon.GBState, addr: number) -> number
export type MemoryWriteHandler = (state: GlobalCommon.GBState, addr: number, value: number) -> ()

export type MemoryReadHandlers = { [number]: MemoryReadHandler }
export type MemoryWriteHandlers = { [number]: MemoryWriteHandler }

local function read_noop()
	return 0
end
local function noop() end

local Common = {
	MMU_READ = table.create(0x10000, read_noop) :: MemoryReadHandlers,
	MMU_WRITE = table.create(0x10000, noop) :: MemoryWriteHandlers,
	noop = noop,
	read_noop = read_noop,
}

return Common
