local fs = require("@lune/fs")

local args = require("./args")
local parse_registers = require("parse_registers")

local logs = require("./logs")
local push_log = logs.push_log
local flush_log = logs.flush_log

local GB = require("../../out")
local MMU = GB.MMU

local parsed = args.parse_args({
	r = "string",
	f = "string",
	c = "number",
})

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

local function log_state()
	local str = string.format(
		"A:%02X F:%02X B:%02X C:%02X D:%02X E:%02X H:%02X L:%02X SP:%04X PC:%04X PCMEM:%02X,%02X,%02X,%02X\n",
		state[REG.A],
		state[REG.F],
		state[REG.B],
		state[REG.C],
		state[REG.D],
		state[REG.E],
		state[REG.H],
		state[REG.L],
		state[REG.SP],
		state[REG.PC],
		MMU.read8(state, state[REG.PC] + 0),
		MMU.read8(state, state[REG.PC] + 1),
		MMU.read8(state, state[REG.PC] + 2),
		MMU.read8(state, state[REG.PC] + 3)
	)
	push_log(str)
end

local instruction_count = parsed.c

log_state()
for _ = 1, instruction_count do
	GB.step(state)
	log_state()
end

flush_log()
