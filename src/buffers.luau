local function read_string_buffer(size: number, str: string): buffer
	local buf = buffer.create(size)
	local idx = 0

	for code in string.gmatch(str, "%x%x") do
		local n = tonumber(code, 16) or error(`Could not read number: ${code}`)
		buffer.writeu8(buf, idx, n)
		idx += 1
	end

	return buf
end

local INSTRUCTION_TIMINGS_MCYCLE = read_string_buffer(
	256,
	[[
	01 03 02 02 01 01 02 01 14 02 02 02 01 01 02 01
	01 03 02 02 01 01 02 01 03 02 02 02 01 01 02 01
	02 03 02 02 01 01 02 01 02 02 02 02 01 01 02 01
	02 03 02 02 03 03 03 01 02 02 02 02 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	02 02 02 02 02 02 01 02 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	01 01 01 01 01 01 02 01 01 01 01 01 01 01 02 01
	02 03 03 04 03 04 02 04 02 04 03 01 03 18 02 04
	02 03 03 01 03 04 02 04 02 04 03 01 03 01 02 04
	03 03 02 01 01 04 02 04 04 01 04 01 01 01 02 04
	03 03 02 01 01 04 02 04 03 02 04 01 01 01 02 04
]]
)

return {
	INSTRUCTION_TIMINGS_MCYCLE = INSTRUCTION_TIMINGS_MCYCLE,
}
