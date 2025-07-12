local fs = require("@lune/fs")

local args = require("./args")
local parse_registers = require("parse_registers")

local init_logs = require("./logs")

local parsed = args.parse_args({
	r = "string",
	f = "string",
	c = "number",
	config = "string",
})

-- `require` is put into parentheses to avoid "Unknown require" linter error
local GB = (require)(`../../out/{parsed.config}`)
local MMU = GB.MMU

if not fs.isFile(parsed.f) then
	error("File does not exist: " .. parsed.f)
elseif not fs.isFile(parsed.r) then
	error("File does not exist: " .. parsed.r)
end

local REG = parse_registers(fs.readFile(parsed.r))
local file = buffer.fromstring(fs.readFile(parsed.f))

local state = GB.init(file) :: any
MMU.Common.MMU_READ[0xFF44] = function()
	return 0x90
end

local function make_log_line(state)
	return string.format(
		"A:%02X F:%02X B:%02X C:%02X D:%02X E:%02X H:%02X L:%02X SP:%04X PC:%04X PCMEM:%02X,%02X,%02X,%02X IME:%s IE:%02X, IF:%02X HALT:%s CLOCK_M:%07d TIMER_COUNTER:%04X DIV:%02X TIMA:%02X TMA:%02X TAC:%02X BIOS:%02X\n",
		state[REG.REG_A],
		state[REG.REG_F],
		state[REG.REG_B],
		state[REG.REG_C],
		state[REG.REG_D],
		state[REG.REG_E],
		state[REG.REG_H],
		state[REG.REG_L],
		state[REG.REG_SP],
		state[REG.REG_PC],
		MMU.read8(state, state[REG.REG_PC] + 0),
		MMU.read8(state, state[REG.REG_PC] + 1),
		MMU.read8(state, state[REG.REG_PC] + 2),
		MMU.read8(state, state[REG.REG_PC] + 3),
		state[REG.REG_IME] and "T" or "F",
		state[REG.REG_IE],
		state[REG.REG_IF],
		state[REG.REG_HALT] and "T" or "F",
		state[REG.CLOCK_M],
		state[REG.TIMER_COUNTER],
		state[REG.REG_DIV],
		state[REG.REG_TIMA],
		state[REG.REG_TMA],
		state[REG.REG_TAC],
		state[REG.BIOS_BANK]
	)
end

local log_line_length = string.len(make_log_line(state))
local logs = init_logs(log_line_length)
local push_log = logs.push_log
local flush_log = logs.flush_log

local function log_state(state)
	push_log(make_log_line(state))
end

local instruction_count = parsed.c

local BIOS_BANK = REG.BIOS_BANK

local startTime = os.clock()

local i = 0
while i <= instruction_count do
	local halt = state[REG.REG_HALT]
	GB.step(state)
	-- do not log during halt (but do log when going into or coming out of halt)
	local halt_log = not halt or (halt and not state[REG.REG_HALT])
	-- also do not log during BIOS state
	if state[BIOS_BANK] > 0 then
		i += 1
		if halt_log then
			log_state(state)
		end
	end
end

flush_log()

print(string.format("Finished in %.4f seconds", os.clock() - startTime))
