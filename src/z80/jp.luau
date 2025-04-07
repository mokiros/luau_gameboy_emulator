local Common = require("./common")
local r16 = Common.r16
local read_e8 = Common.read_e8
local read_n16 = Common.read_n16

-- TODO: In some instructions, the amount of cycles is different based on
-- whether the jump actually happened or not. Need to account for that.
local JP = Common.INSTRUCTIONS

JP[0xC3] = function(state)
	state[REG_PC] = read_n16(state)
end

JP[0xE9] = function(state)
	state[REG_PC] = r16(state[REG_H], state[REG_L])
end

JP[0xC2] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local Z = if _G.USE_BIT32 then bit32.extract(state[REG_F], 7) else state[REG_F] // 128
		state[REG_PC] = (state[REG_PC] + 2) * Z + read_n16(state) * (1 - Z)
	end
	else function(state)
		state[REG_PC] = if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127)
			then state[REG_PC] + 2
			else read_n16(state)
	end

JP[0xCA] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local Z = if _G.USE_BIT32 then bit32.extract(state[REG_F], 7) else state[REG_F] // 128
		state[REG_PC] = (state[REG_PC] + 2) * (1 - Z) + read_n16(state) * Z
	end
	else function(state)
		state[REG_PC] = if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127)
			then read_n16(state)
			else state[REG_PC] + 2
	end

JP[0xD2] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local C = if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else state[REG_F] // 16 % 2
		state[REG_PC] = (state[REG_PC] + 2) * C + read_n16(state) * (1 - C)
	end
	else function(state)
		state[REG_PC] = if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15)
			then state[REG_PC] + 2
			else read_n16(state)
	end

JP[0xDA] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local C = if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else state[REG_F] // 16 % 2
		state[REG_PC] = (state[REG_PC] + 2) * (1 - C) + read_n16(state) * C
	end
	else function(state)
		state[REG_PC] = if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15)
			then read_n16(state)
			else state[REG_PC] + 2
	end

JP[0x18] = function(state)
	state[REG_PC] += read_e8(state) + 1
end

JP[0x20] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local Z = if _G.USE_BIT32 then bit32.extract(state[REG_F], 7) else state[REG_F] // 128
		state[REG_PC] += 1 + read_e8(state) * (1 - Z)
	end
	else function(state)
		state[REG_PC] += if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127
			then 1
			else read_e8(state) + 1
	end

JP[0x28] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local Z = if _G.USE_BIT32 then bit32.extract(state[REG_F], 7) else state[REG_F] // 128
		state[REG_PC] += 1 + read_e8(state) * Z
	end
	else function(state)
		state[REG_PC] += if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127)
			then read_e8(state) + 1
			else 1
	end

JP[0x30] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local C = if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else state[REG_F] // 16 % 2
		state[REG_PC] += 1 + read_e8(state) * (1 - C)
	end
	else function(state)
		state[REG_PC] += if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15)
			then 1
			else read_e8(state) + 1
	end

JP[0x38] = if _G.NO_BRANCHED_EXPRESSIONS
	then function(state)
		local C = if _G.USE_BIT32 then bit32.extract(state[REG_F], 4) else state[REG_F] // 16 % 2
		state[REG_PC] += 1 + read_e8(state) * C
	end
	else function(state)
		state[REG_PC] += if (if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15)
			then read_e8(state) + 1
			else 1
	end

return true
