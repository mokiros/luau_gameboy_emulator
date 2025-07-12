local function parse_registers(file: string)
	local t = {}
	local lines = string.split(file, "\n")
	local counter = 1
	for _, line in lines do
		local key = string.match(line, "^declare ([^:]+)")
		if not key then
			continue
		end
		local idx = string.match(line, "--#%s*(%d+)")
		t[key] = idx or counter
		if not idx then
			counter += 1
		end
	end
	return t
end

return parse_registers
