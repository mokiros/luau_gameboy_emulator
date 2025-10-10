local GlobalCommon = require("../common")
type GBState = GlobalCommon.GBState

local PPU_SCREEN_WIDTH = 160
local PPU_SCREEN_HEIGHT = 144
local PPU_BYTES_PER_PIXEL = 4

local DEFAULT_PALETTE = {
	0xFFFFFFFF,
	0xFFAAAAAA,
	0xFF555555,
	0xFF000000,
}

local PPU_TILE_SIZE = 8
local PPU_TILES_PER_BLOCK = 128
local PPU_TILE_BLOCKS = 3

local PPU_TILEMAP_WIDTH = 32
local PPU_TILEMAP_HEIGHT = 32

local function ppu_update_tile_in_block(state: GBState, address: number, two_bytes_row: number)
	local tile_byte_offset = PPU_BYTES_PER_PIXEL * PPU_TILE_SIZE
	local y_offset = tile_byte_offset * PPU_TILES_PER_BLOCK * PPU_TILE_BLOCKS

	local tile_index = if _G.USE_BIT32 then bit32.extract(address, 4, 8) else (address // (2 ^ 4)) % (2 ^ 8)
	local line_index = if _G.USE_BIT32 then bit32.extract(address, 1, 3) else (address // (2 ^ 1)) % (2 ^ 3)

	local tile_address = tile_index * tile_byte_offset + line_index * y_offset

	local palette = state[PPU_PALETTE]
	local tile_block_buffer = state[PPU_TILE_BLOCK_BUFFER]

	-- in the DMG, first byte specifies least significant bit (right), and second byte specifies most significant (left)
	-- luau's buffers use little endian, meaning the byte order is reversed
	-- which is why first byte is high, second byte is low
	for i = 0, 7 do
		local bit_high = (two_bytes_row // (2 ^ (i + 8))) % 2
		local bit_low = (two_bytes_row // (2 ^ i)) % 2
		local color_index = bit_high * 2 + bit_low + 1
		local color = palette[color_index]
		buffer.writeu32(tile_block_buffer, tile_address + (7 - i) * 4, color)
	end
end

local function ppu_update_palette(state: GBState, byte: number)
	state[PPU_PALETTE] = {
		DEFAULT_PALETTE[bit32.extract(byte, 0, 2) + 1],
		DEFAULT_PALETTE[bit32.extract(byte, 2, 2) + 1],
		DEFAULT_PALETTE[bit32.extract(byte, 4, 2) + 1],
		DEFAULT_PALETTE[bit32.extract(byte, 6, 2) + 1],
	}

	for row_addr = 0, 0x17FF, 2 do
		local row_16bits = buffer.readu16(state[MEMORY_VRAM], row_addr)
		ppu_update_tile_in_block(state, row_addr, row_16bits)
	end
end

return {
	PPU_SCREEN_WIDTH = PPU_SCREEN_WIDTH,
	PPU_SCREEN_HEIGHT = PPU_SCREEN_HEIGHT,
	PPU_BYTES_PER_PIXEL = PPU_BYTES_PER_PIXEL,
	PPU_TILE_SIZE = PPU_TILE_SIZE,
	PPU_TILES_PER_BLOCK = PPU_TILES_PER_BLOCK,
	PPU_TILE_BLOCKS = PPU_TILE_BLOCKS,
	DEFAULT_PALETTE = DEFAULT_PALETTE,
	PPU_TILEMAP_WIDTH = PPU_TILEMAP_WIDTH,
	PPU_TILEMAP_HEIGHT = PPU_TILEMAP_HEIGHT,

	ppu_update_tile_in_block = ppu_update_tile_in_block,
	ppu_update_palette = ppu_update_palette,
}
