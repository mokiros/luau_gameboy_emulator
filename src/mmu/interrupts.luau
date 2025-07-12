local Common = require("./common")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

MMU_READ[0xFF0F] = function(state, _)
	return state[REG_IF]
end

MMU_WRITE[0xFF0F] = function(state, _, value)
	state[REG_IF] = bit32.band(value, 0x1F)
end

MMU_READ[0xFFFF] = function(state, _)
	return state[REG_IE]
end

MMU_WRITE[0xFFFF] = function(state, _, value)
	state[REG_IE] = value
end

return {}
