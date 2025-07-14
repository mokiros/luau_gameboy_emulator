local Common = require("./common")

local RAM_READ = Common.MMU_READ
local RAM_WRITE = Common.MMU_WRITE

local function wram_read(state, addr)
	return buffer.readu8(state[MEMORY_WRAM], bit32.band(addr, 0x1FFF))
end

local function wram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_WRAM], bit32.band(addr, 0x1FFF), value)
end

for addr = 0xC000, 0xFDFF do
	RAM_READ[addr] = wram_read
	RAM_WRITE[addr] = wram_write
end

local function vram_read(state, addr)
	return buffer.readu8(state[MEMORY_VRAM], bit32.band(addr, 0x1FFF))
end

local function vram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_VRAM], bit32.band(addr, 0x1FFF), value)
end

for addr = 0x8000, 0x9FFF do
	RAM_READ[addr] = vram_read
	RAM_WRITE[addr] = vram_write
end

local function hram_read(state, addr)
	return buffer.readu8(state[MEMORY_HRAM], bit32.band(addr, 0x7F))
end

local function hram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_HRAM], bit32.band(addr, 0x7F), value)
end

for addr = 0xFF80, 0xFFFE do
	RAM_READ[addr] = hram_read
	RAM_WRITE[addr] = hram_write
end

return {
	WRAM_SIZE = 2 ^ 13,
	VRAM_SIZE = 2 ^ 13,
	HRAM_SIZE = 127,
	OAM_SIZE = 160,
}
