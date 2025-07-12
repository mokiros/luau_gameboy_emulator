local Common = require("./common")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

-- DIV (0xFF04)
MMU_READ[0xFF04] = function(state)
	return bit32.rshift(state[REG_DIV], 6)
end

-- TIMA (0xFF05)
MMU_READ[0xFF05] = function(state)
	return state[REG_TIMA]
end

-- TMA (0xFF06)
MMU_READ[0xFF06] = function(state)
	return state[REG_TMA]
end

-- TAC (0xFF07)
MMU_READ[0xFF07] = function(state)
	return state[REG_TAC]
end

-- DIV write (0xFF04)
MMU_WRITE[0xFF04] = function(state)
	-- Writing any value to DIV resets it to 0
	state[REG_DIV] = 0
	state[TIMA_COUNTER] = 0
end

-- TIMA write (0xFF05)
MMU_WRITE[0xFF05] = function(state, _, value)
	state[REG_TIMA] = value
end

-- TMA write (0xFF06)
MMU_WRITE[0xFF06] = function(state, _, value)
	state[REG_TMA] = value
end

-- TAC write (0xFF07)
MMU_WRITE[0xFF07] = function(state, _, value)
	-- print("TAC set", value)
	state[REG_TAC] = bit32.band(value, 0b111) -- Only bits 0-2 are used
end

return {}
