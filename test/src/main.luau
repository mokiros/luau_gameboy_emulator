local fs = require("@lune/fs")

local args = require("./args")

local logs = require("./logs")
local push_log = logs.push_log
local flush_log = logs.flush_log

local GB = require("../../out")

local MMU = GB.MMU
local Z80 = GB.Z80
local REG = GB.Common.REG

local parsed = args.parse_args({
	f = "string",
	c = "number",
})

if not fs.isFile(parsed.f) then
	error("File does not exist: " .. parsed.f)
end

local file = buffer.fromstring(fs.readFile(parsed.f))

local state = GB.init() :: any
MMU.writeROM(state, file)
MMU.write8(state, 0xFF44, 0x90)

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
	Z80.run(state, 1)
	log_state()
	if state[REG.STOP] >= 0 then
		break
	end
end

flush_log()
