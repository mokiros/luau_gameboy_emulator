local Common = require("./common")
local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

local WRAM_SIZE = 2 ^ 13
local HRAM_SIZE = 127

-- TODO: Test out if subtracting instead of `band` would be faster
local function wram_read(state, addr)
	return buffer.readu8(state[MEMORY_WRAM], bit32.band(addr, 0x1FFF))
end

local function wram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_WRAM], bit32.band(addr, 0x1FFF), value)
end

for addr = 0xC000, 0xFDFF do
	MMU_READ[addr] = wram_read
	MMU_WRITE[addr] = wram_write
end

local function hram_read(state, addr)
	return buffer.readu8(state[MEMORY_HRAM], bit32.band(addr, 0x7F))
end

local function hram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_HRAM], bit32.band(addr, 0x7F), value)
end

for addr = 0xFF80, 0xFFFE do
	MMU_READ[addr] = hram_read
	MMU_WRITE[addr] = hram_write
end

return {
	WRAM_SIZE = WRAM_SIZE,
	HRAM_SIZE = HRAM_SIZE,
}
