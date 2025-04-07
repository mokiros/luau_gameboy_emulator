local stdio = require("@lune/stdio")

local log_lines_per_flush = 10000
local log_line_length = 74
local log_buffer = buffer.create(log_line_length * log_lines_per_flush)
local log_buffer_length = buffer.len(log_buffer)

local current_log_offset = 0
local function flush_log(): ()
	if current_log_offset > 0 then
		stdio.write(buffer.readstring(log_buffer, 0, current_log_offset))
		current_log_offset = 0
	end
end

local function push_log(str: string): ()
	local str_len = #str
	if current_log_offset + str_len >= log_buffer_length then
		flush_log()
	end
	buffer.writestring(log_buffer, current_log_offset, str)
	current_log_offset += str_len
end

return {
	push_log = push_log,
	flush_log = flush_log,
}
