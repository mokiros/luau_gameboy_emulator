local GlobalCommon = require("../common")
local Common = require("./common")

type GBState = GlobalCommon.GBState

local raise_interrupt = GlobalCommon.raise_interrupt

local PPU = {
	Common = Common,
	SCREEN_WIDTH = 160,
	SCREEN_HEIGHT = 144,
	BYTES_PER_PIXEL = 4,
}

function PPU.init(state: GBState)
	state[SCREEN_BUFFER] = buffer.create(PPU.SCREEN_WIDTH * PPU.SCREEN_HEIGHT * PPU.BYTES_PER_PIXEL)
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
	if y >= 144 then
		return
	end

	for x = 0, 159 do
		local offset = (y * 160 + x) * 4
		local r = math.floor((x / 159) * 255)
		local g = math.floor((y / 143) * 255)
		local b = math.floor(((x + y) / (159 + 143)) * 255)
		local a = 0xFF

		-- The bytes are written in little endian format, so it needs to be backwards
		buffer.writeu32(state[SCREEN_BUFFER], offset, a * 0x1000000 + b * 0x10000 + g * 0x100 + r)
	end
end

local MODE_TIMINGS = {
	[PPU_MODE_HBLANK] = 204,
	[PPU_MODE_VBLANK] = 456,
	[PPU_MODE_OAM_SCAN] = 80,
	[PPU_MODE_DRAWING] = 172,
}

function PPU.step(state: GBState, tcycles: number)
	local clock = state[PPU_MODECLOCK] + tcycles

	local mode = state[PPU_MODE]
	local line = state[PPU_LY]

	local mode_timing = MODE_TIMINGS[mode]

	if clock >= mode_timing then
		if mode == PPU_MODE_OAM_SCAN then
			state[PPU_MODE] = PPU_MODE_DRAWING
			clock -= mode_timing
		elseif mode == PPU_MODE_DRAWING then
			state[PPU_MODE] = PPU_MODE_HBLANK
			clock -= mode_timing
			render_scanline(state)
		elseif mode == PPU_MODE_HBLANK then
			clock -= mode_timing
			state[PPU_LY] = line + 1
			if line == 144 - 1 then
				state[PPU_MODE] = PPU_MODE_VBLANK
				raise_interrupt(state, INT_VBLANK)
			else
				state[PPU_MODE] = PPU_MODE_OAM_SCAN
			end
		elseif mode == PPU_MODE_VBLANK then
			clock -= mode_timing
			state[PPU_LY] = line + 1
			if line > 153 - 1 then
				state[PPU_MODE] = PPU_MODE_OAM_SCAN
				state[PPU_LY] = 0
			end
		end
	end

	state[PPU_MODECLOCK] = clock
end

return PPU
