local args = require("./args")

local GB = require("../../out")

local MMU = GB.MMU
local Z80 = GB.Z80
local REG = GB.Common.REG

local state = GB.init() :: any
MMU.writeROM(state, args.file)
MMU.write8(state, 0xFF44, 0x90)

local instruction_count = args.instruction_count

local t = os.clock()
for _ = 1, instruction_count do
	Z80.run(state, 1)
	if state[REG.STOP] >= 0 then
		break
	end
end

print(string.format("Executed %d instructions in %.4f seconds", instruction_count, os.clock() - t))
