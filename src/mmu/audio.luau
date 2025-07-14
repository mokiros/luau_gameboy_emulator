local Common = require("./common")

local RAM_READ = Common.MMU_READ
local RAM_WRITE = Common.MMU_WRITE
local read_noop = Common.read_noop
local noop = Common.noop

for addr = 0xFF10, 0xFF26 do
	RAM_READ[addr] = read_noop
	RAM_WRITE[addr] = noop
end

for addr = 0xFF30, 0xFF3F do
	RAM_READ[addr] = read_noop
	RAM_WRITE[addr] = noop
end

return {}
