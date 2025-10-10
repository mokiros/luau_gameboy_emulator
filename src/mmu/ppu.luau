local Common = require("./common")
local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE
local read8 = Common.read8

local PPU = require("../ppu/common")
local ppu_update_tile_in_block = PPU.ppu_update_tile_in_block
local ppu_update_palette = PPU.ppu_update_palette

local VRAM_SIZE = 2 ^ 13
local OAM_SIZE = 160

local function vram_read(state, addr)
	return buffer.readu8(state[MEMORY_VRAM], bit32.band(addr, 0x1FFF))
end

local function vram_write(state, addr, value)
	buffer.writeu8(state[MEMORY_VRAM], bit32.band(addr, 0x1FFF), value)
end

local function vram_tile_block_write(state, addr, value)
	vram_write(state, addr, value)
	local row_addr = bit32.band(addr, 0x1FFE) -- always even address to get the whole line
	local row_16bits = buffer.readu16(state[MEMORY_VRAM], row_addr)
	ppu_update_tile_in_block(state, row_addr, row_16bits)
end

local function vram_tile_map_write(state, addr, value)
	vram_write(state, addr, value)
end

for addr = 0x8000, 0x9FFF do
	MMU_READ[addr] = vram_read
end

for addr = 0x8000, 0x97FF do
	MMU_WRITE[addr] = vram_tile_block_write
end

for addr = 0x9800, 0x9FFF do
	MMU_WRITE[addr] = vram_tile_map_write
end

local function oam_read(state, addr)
	return buffer.readu8(state[MEMORY_OAM], bit32.band(addr, 0x00FF))
end

local function oam_write(state, addr, value)
	buffer.writeu8(state[MEMORY_OAM], bit32.band(addr, 0x00FF), value)
end

for addr = 0xFE00, 0xFE9F do
	MMU_READ[addr] = oam_read
	MMU_WRITE[addr] = oam_write
end

MMU_READ[0xFF40] = function(state)
	return state[PPU_LCDC]
end

MMU_WRITE[0xFF40] = function(state, _, value)
	state[PPU_LCDC] = value
end

MMU_READ[0xFF41] = function(state)
	return if _G.USE_BIT32
		then bit32.bor(state[PPU_STAT], if state[PPU_LY] == state[PPU_LYC] then 0b100 else 0b000, state[PPU_MODE])
		else state[PPU_STAT] + (if state[PPU_LY] == state[PPU_LYC] then 0b100 else 0b000) + state[PPU_MODE]
end

MMU_WRITE[0xFF41] = function(state, _, value)
	state[PPU_STAT] = bit32.band(value, 0b01111000)
end

MMU_READ[0xFF42] = function(state)
	return state[PPU_SCY]
end

MMU_WRITE[0xFF42] = function(state, _, value)
	state[PPU_SCY] = value
end

MMU_READ[0xFF43] = function(state)
	return state[PPU_SCX]
end

MMU_WRITE[0xFF43] = function(state, _, value)
	state[PPU_SCX] = value
end

MMU_READ[0xFF44] = function(state)
	return state[PPU_LY]
end

MMU_READ[0xFF45] = function(state)
	return state[PPU_LYC]
end

MMU_WRITE[0xFF45] = function(state, _, value)
	state[PPU_LYC] = value
end

MMU_WRITE[0xFF46] = function(state, _, value)
	local src = bit32.lshift(value, 8)
	for i = 0, 159 do
		local byte = read8(state, src + i)
		buffer.writeu8(state[MEMORY_OAM], i, byte)
	end
	-- TODO: Block memory access during DMA
end

MMU_READ[0xFF47] = function(state)
	return state[PPU_BGP]
end

MMU_WRITE[0xFF47] = function(state, _, value)
	state[PPU_BGP] = value
	ppu_update_palette(state, value)
end

MMU_READ[0xFF48] = function(state)
	return state[PPU_OBP0]
end

MMU_WRITE[0xFF48] = function(state, _, value)
	state[PPU_OBP0] = value
end

MMU_READ[0xFF49] = function(state)
	return state[PPU_OBP1]
end

MMU_WRITE[0xFF49] = function(state, _, value)
	state[PPU_OBP1] = value
end

MMU_READ[0xFF4A] = function(state)
	return state[PPU_WY]
end

MMU_WRITE[0xFF4A] = function(state, _, value)
	state[PPU_WY] = value
end

MMU_READ[0xFF4B] = function(state)
	return state[PPU_WX]
end

MMU_WRITE[0xFF4B] = function(state, _, value)
	state[PPU_WX] = value
end

return {
	VRAM_SIZE = VRAM_SIZE,
	OAM_SIZE = OAM_SIZE,
}
