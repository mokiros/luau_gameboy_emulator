local fs = require("@lune/fs")
local net = require("@lune/net")

local args = require("./args")

local parsed = args.parse_args({
	p = "string",
	r = "string",
	bit32 = "string",
	branched = "string",
})

local settings = {
	bit32 = if parsed.bit32 == "true"
		then true
		elseif parsed.bit32 == "false" then false
		else error(`Invalid '-bit32' value: {parsed.bit32}`),

	branched = if parsed.branched == "true"
		then true
		elseif parsed.branched == "false" then false
		else error(`Invalid '-branched' value: {parsed.branched}`),
}

local base_rules = {
	-- "remove_types",
	"compute_expression",
	"remove_unused_if_branch",
	"remove_unused_while",
	"filter_after_early_return",
	"remove_empty_do",
	"remove_unused_variable",
	"convert_index_to_field",
	"remove_nil_declaration",
}
local rules: { any } = {}

local function add_global(reg, idx)
	table.insert(rules, {
		rule = "inject_global_value",
		identifier = reg,
		value = idx,
	})
end

local registers_file = fs.readFile(parsed.r)

for reg, idx in string.gmatch(registers_file, "declare ([^:]+)[^-]+--#%s*(%d+)") do
	add_global(reg, tonumber(idx))
end

add_global("USE_BIT32", settings.bit32)
add_global("NO_BRANCHED_EXPRESSIONS", settings.branched)

for _, rule in base_rules do
	table.insert(rules, rule)
end

fs.writeFile(parsed.p, net.jsonEncode({ rules = rules }, true))
