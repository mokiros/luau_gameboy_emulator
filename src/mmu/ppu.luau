local Common = require("./common")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

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

MMU_WRITE[0xFF46] = function(state, _, value)
	local src = bit32.lshift(value, 8)
	for i = 0, 159 do
		local byte = Common.read8(state, src + i)
		buffer.writeu8(state[MEMORY_OAM], i, byte)
	end
	-- TODO: Block memory access during DMA
end

MMU_READ[0xFF47] = function(state)
	return state[PPU_BGP]
end

MMU_WRITE[0xFF47] = function(state, _, value)
	state[PPU_BGP] = value
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

return {}
