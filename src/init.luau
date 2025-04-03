local Common = require("./common")
local Z80 = require("./z80")
local MMU = require("./mmu")

local function init(): Common.GBState
	local state = {} :: Common.GBState

	Z80.init(state)
	MMU.init(state)

	return state
end

return {
	Common = Common,
	Z80 = Z80,
	MMU = MMU,
	init = init,
}
