local fs = require("@lune/fs")
local process = require("@lune/process")
local file_path: string?
local instruction_count: number?

local i = 1
local n = #process.args
while i < n do
	if process.args[i] == "-f" then
		file_path = process.args[i + 1]
	elseif process.args[i] == "-c" then
		instruction_count = tonumber(process.args[i + 1]) or error("Invalid instruction count: " .. tostring(process.args[i + 1]))
	end
	i += 1
end

if not file_path then
	error("Missing file path (the '-f' argument)")
elseif not fs.isFile(file_path) then
	error("File does not exist: " .. file_path)
elseif not instruction_count then
	error("Missing instruction count (the '-c' argument)")
end

local file = buffer.fromstring(fs.readFile(file_path))
local size = buffer.len(file)
if size ~= 0x8000 then
	error("Invalid file size: ", size)
end

return {
	file = file,
	instruction_count = instruction_count,
}
