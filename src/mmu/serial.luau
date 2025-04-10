local Common = require("./common")

local MMU_READ = Common.MMU_READ
local MMU_WRITE = Common.MMU_WRITE

MMU_READ[0xFF01] = function()
	return 0xFF
end

MMU_WRITE[0xFF01] = function(state, _, value)
	state[SERIAL_VALUE] = value
end

MMU_READ[0xFF02] = function()
	return 0x7E
end

MMU_WRITE[0xFF02] = function(state, _, value)
	if bit32.band(value, 0b1000_0001) == 0b1000_0001 then
		state[SERIAL_DATA] ..= string.char(state[SERIAL_VALUE])
	end
end

return {}
