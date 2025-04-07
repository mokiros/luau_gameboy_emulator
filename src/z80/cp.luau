local Common = require("./common")
local read_n8 = Common.read_n8
local read_at_hl = Common.read_at_hl

local CP = Common.INSTRUCTIONS

local function cp_with_a(state, value)
	local a = state[REG_A]
	-- TODO: add _G.USE_BIT32 variant and maybe _G.NO_BRANCHED_EXPRESSIONS
	state[REG_F] = 0b0100_0000
		+ (if a == value then 0b1000_0000 elseif a < value then 0b0001_0000 else 0)
		+ if (a % 16 - value % 16) < 0 then 0b0010_0000 else 0
end

CP[0xB8] = function(state)
	cp_with_a(state, state[REG_B])
end

CP[0xB9] = function(state)
	cp_with_a(state, state[REG_C])
end

CP[0xBA] = function(state)
	cp_with_a(state, state[REG_D])
end

CP[0xBB] = function(state)
	cp_with_a(state, state[REG_E])
end

CP[0xBC] = function(state)
	cp_with_a(state, state[REG_H])
end

CP[0xBD] = function(state)
	cp_with_a(state, state[REG_L])
end

CP[0xBE] = function(state)
	cp_with_a(state, read_at_hl(state))
end

CP[0xBF] = function(state)
	cp_with_a(state, state[REG_A])
end

CP[0xFE] = function(state)
	cp_with_a(state, read_n8(state))
end

return true
