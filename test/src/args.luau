local process = require("@lune/process")

export type ArgsConfig = { [string]: "number" | "string" | "boolean" }

local function parse_args(cfg: ArgsConfig): any
	local parsed = {}
	local i = 1
	local n = #process.args
	while i <= n do
		local arg = process.args[i]
		i += 1
		if string.sub(arg, 1, 1) ~= "-" then
			continue
		end
		local key = string.sub(arg, 2)
		local t = cfg[key]
		if t == "boolean" then
			parsed[key] = true
			continue
		elseif not t or i > n then
			continue
		end
		local v = process.args[i]
		i += 1
		if t == "number" then
			v = tonumber(v) or error(`Invalid argument: {arg} {v}`)
		end
		parsed[key] = v
	end

	for k, v in cfg do
		if not parsed[k] then
			if v == "boolean" then
				parsed[k] = false
			else
				error(`Missing argument: -{k}`)
			end
		end
	end

	return parsed
end

return {
	parse_args = parse_args,
}
