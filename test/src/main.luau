local fs = require("@lune/fs")

local args = require("./args")
local parse_registers = require("parse_registers")

local parsed = args.parse_args({
	r = "string",
	f = "string",
	config = "string",
})

-- `require` is put into parentheses to avoid "Unknown require" linter error
local GB = (require)(`../out/{parsed.config}`)
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

local SERIAL_VALUE = REG.SERIAL_VALUE
local reachedEnd = false
local didError = false
local serial_out = ""
MMU.Common.MMU_WRITE[0xFF02] = function(state)
	local v = state[SERIAL_VALUE]
	if v == 0x0A then
		if serial_out ~= "" then
			print("SERIAL:", serial_out)
			if string.find(serial_out, "Passed") then
				reachedEnd = true
			elseif string.find(serial_out, "Failed") then
				reachedEnd = true
				didError = true
			end
			serial_out = ""
		end
	else
		serial_out ..= string.char(v)
	end
end

local startTime = os.clock()

local i = 0
while true do
	i += 1
	GB.step(state)
	if reachedEnd then
		break
	end
end

if didError then
	error("Test ROM failed")
end

print(string.format("Finished in %.4f seconds, instruction count: %d", os.clock() - startTime, i))
