local function parse_registers(file: string)
	local t = {}
	for reg, idx in string.gmatch(file, "declare ([^:]+)[^-]+--#%s*(%d+)") do
		t[reg] = tonumber(idx)
	end
	return t
end

return parse_registers
