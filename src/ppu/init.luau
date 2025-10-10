local GlobalCommon = require("./common")
local raise_interrupt = GlobalCommon.raise_interrupt
type GBState = GlobalCommon.GBState

local Common = require("@self/common")

local PPU_SCREEN_WIDTH = Common.PPU_SCREEN_WIDTH
local PPU_SCREEN_HEIGHT = Common.PPU_SCREEN_HEIGHT
local PPU_BYTES_PER_PIXEL = Common.PPU_BYTES_PER_PIXEL

local DEFAULT_PALETTE = Common.DEFAULT_PALETTE

local PPU_TILE_SIZE = Common.PPU_TILE_SIZE
local PPU_TILES_PER_BLOCK = Common.PPU_TILES_PER_BLOCK
local PPU_TILE_BLOCKS = Common.PPU_TILE_BLOCKS

local PPU_TILEMAP_WIDTH = Common.PPU_TILEMAP_WIDTH
local PPU_TILEMAP_HEIGHT = Common.PPU_TILEMAP_HEIGHT

local bytes_per_tile_row = PPU_TILE_SIZE * PPU_BYTES_PER_PIXEL
local bytes_per_block_row = bytes_per_tile_row * PPU_TILES_PER_BLOCK
local bytes_per_all_blocks_row = bytes_per_block_row * PPU_TILE_BLOCKS
local total_bytes_for_all_blocks = bytes_per_all_blocks_row * PPU_TILE_SIZE

function ppu_init(state: GBState)
	state[SCREEN_BUFFER] = buffer.create(PPU_SCREEN_WIDTH * PPU_SCREEN_HEIGHT * PPU_BYTES_PER_PIXEL)
	state[PPU_TILE_BLOCK_BUFFER] = buffer.create(total_bytes_for_all_blocks)
	-- state[PPU_OBJECT_BUFFER] = buffer.create()
	state[PPU_PALETTE] = DEFAULT_PALETTE
	state[PPU_MODECLOCK] = 0
	state[PPU_MODE] = 0
	state[PPU_LY] = 0
	state[PPU_LCDC] = 0
	state[PPU_SCY] = 0
	state[PPU_SCX] = 0
	state[PPU_BGP] = 0
	state[PPU_OBP0] = 0
	state[PPU_OBP1] = 0
	state[PPU_WX] = 0
	state[PPU_WY] = 0
end

local function render_scanline(state: GBState)
	local y = state[PPU_LY]
	if _G.DEBUG then
		if y >= PPU_SCREEN_HEIGHT then
			error(`Tried to render a scanline in the VBLANK area (y value received: {y})`)
		end
	end

	local VRAM = state[MEMORY_VRAM]
	local TILE_BLOCK_BUFFER = state[PPU_TILE_BLOCK_BUFFER]
	local SCREEN_BUFFER = state[SCREEN_BUFFER]

	local LCDC = state[PPU_LCDC]
	local LCDC4 = bit32.extract(LCDC, 4)
	local LCDC3 = bit32.extract(LCDC, 3)

	local SCX = state[PPU_SCX]
	local SCY = state[PPU_SCY]

	local tile_index_offset = PPU_TILES_PER_BLOCK * (1 - LCDC4)
	local tilemap_offset = 0x1800 + LCDC3 * 0x400

	local screen_y = y
	local screen_line_offset = screen_y * PPU_SCREEN_WIDTH
	local tilemap_y = SCY + y
	local tile_y = (tilemap_y // 8) % PPU_TILEMAP_HEIGHT
	local tile_row = tilemap_y % 8

	local tile_block_line_offset = bytes_per_all_blocks_row * tile_row
	local tilemap_y_offset = tilemap_offset + tile_y * PPU_TILEMAP_WIDTH

	local start_x = SCX
	local end_x = SCX + PPU_SCREEN_WIDTH - 1

	local start_tile_x = start_x // 8
	local end_tile_x = end_x // 8

	for tile_x = start_tile_x, end_tile_x do
		local tile_pixel_x = tile_x * 8
		local left_cutoff = math.max(0, start_x - tile_pixel_x)
		local right_cutoff = math.max(0, (tile_pixel_x + 8) - (end_x + 1))
		local tile_width = 8 - left_cutoff - right_cutoff

		local tilemap_address = tilemap_y_offset + (tile_x % PPU_TILEMAP_WIDTH)
		local tile_index_raw = buffer.readu8(VRAM, tilemap_address)
		local tile_index = (tile_index_raw - tile_index_offset) % 0xFF + tile_index_offset

		local tile_block_offset = tile_block_line_offset + tile_index * bytes_per_tile_row + left_cutoff

		local screen_x = tile_pixel_x - SCX + left_cutoff
		local screen_buffer_offset = screen_line_offset + screen_x
		buffer.copy(
			SCREEN_BUFFER,
			screen_buffer_offset * PPU_BYTES_PER_PIXEL,
			TILE_BLOCK_BUFFER,
			tile_block_offset,
			tile_width * PPU_BYTES_PER_PIXEL
		)
	end
end

local MODE_TIMINGS = {
	[PPU_MODE_HBLANK] = 204 / 4,
	[PPU_MODE_VBLANK] = 456 / 4,
	[PPU_MODE_OAM_SCAN] = 80 / 4,
	[PPU_MODE_DRAWING] = 172 / 4,
}

local function ppu_step(state: GBState, cycles: number)
	local clock = state[PPU_MODECLOCK] + cycles
	state[PPU_MODECLOCK] = clock

	local mode = state[PPU_MODE]

	local mode_timing = MODE_TIMINGS[mode]

	if clock >= mode_timing then
		clock -= mode_timing
		if mode == PPU_MODE_OAM_SCAN then
			state[PPU_MODE] = PPU_MODE_DRAWING
		elseif mode == PPU_MODE_DRAWING then
			state[PPU_MODE] = PPU_MODE_HBLANK
			render_scanline(state)
		elseif mode == PPU_MODE_HBLANK then
			local line = state[PPU_LY]
			state[PPU_LY] = line + 1
			if line == 144 - 1 then
				state[PPU_MODE] = PPU_MODE_VBLANK
				raise_interrupt(state, INT_VBLANK)
			else
				state[PPU_MODE] = PPU_MODE_OAM_SCAN
			end
		else -- if mode == PPU_MODE_VBLANK then
			if _G.DEBUG then
				if mode ~= PPU_MODE_VBLANK then
					error(`Invalid PPU mode: {mode}`)
				end
			end
			local line = state[PPU_LY]
			state[PPU_LY] = line + 1
			if line > 153 - 1 then
				state[PPU_MODE] = PPU_MODE_OAM_SCAN
				state[PPU_LY] = 0
			end
		end
	end
end

return {
	Common = Common,
	init = ppu_init,
	step = ppu_step,
}
