local Common = require("./common")
local read_n16 = Common.read_n16
local stack_push16 = Common.stack_push16
local stack_pop16 = Common.stack_pop16

local CALL = Common.INSTRUCTIONS

---#inline
local function call_n16(state)
	local new_pc = read_n16(state)

	stack_push16(state, state[REG_PC])

	state[REG_PC] = new_pc
end

CALL[0xCD] = function(state)
	call_n16(state)
end

CALL[0xC4] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127 then
		state[REG_PC] += 2
	else
		call_n16(state)
		state[CLOCK_M] += 3
	end
end

CALL[0xCC] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127 then
		call_n16(state)
		state[CLOCK_M] += 3
	else
		state[REG_PC] += 2
	end
end

CALL[0xD4] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15 then
		state[REG_PC] += 2
	else
		call_n16(state)
		state[CLOCK_M] += 3
	end
end

CALL[0xDC] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x10) else (state[REG_F] % 32) > 15 then
		call_n16(state)
		state[CLOCK_M] += 3
	else
		state[REG_PC] += 2
	end
end

---#inline
local function ret(state)
	state[REG_PC] = stack_pop16(state)
end

CALL[0xC9] = function(state)
	ret(state)
end

CALL[0xC0] = function(state)
	if if _G.USE_BIT32 then not bit32.btest(state[REG_F], 0x80) else state[REG_F] < 128 then
		ret(state)
	end
end

CALL[0xC8] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0x80) else state[REG_F] > 127 then
		ret(state)
	end
end

CALL[0xD0] = function(state)
	if if _G.USE_BIT32 then not bit32.btest(state[REG_F], 0b0001_0000) else (state[REG_F] % 32) == 0 then
		ret(state)
	end
end

CALL[0xD8] = function(state)
	if if _G.USE_BIT32 then bit32.btest(state[REG_F], 0b0001_0000) else (state[REG_F] % 32) ~= 0 then
		ret(state)
	end
end

CALL[0xD9] = function(state)
	state[REG_IME] = true
	ret(state)
end

---#inline
local function call_addr(state, addr)
	stack_push16(state, state[REG_PC])
	state[REG_PC] = addr
end

CALL[0xC7] = function(state)
	call_addr(state, 0x00)
end

CALL[0xCF] = function(state)
	call_addr(state, 0x08)
end

CALL[0xD7] = function(state)
	call_addr(state, 0x10)
end

CALL[0xDF] = function(state)
	call_addr(state, 0x18)
end

CALL[0xE7] = function(state)
	call_addr(state, 0x20)
end

CALL[0xEF] = function(state)
	call_addr(state, 0x28)
end

CALL[0xF7] = function(state)
	call_addr(state, 0x30)
end

CALL[0xFF] = function(state)
	call_addr(state, 0x38)
end

return true
