-- lua/failed_request_trace/logger.lua
--
-- Trace emission and logging.
-- Serializes traces and writes them to nginx error log via ngx.log.

local M = {}

-- Emit a trace log
-- Serializes the trace and writes to nginx error log at INFO level
function M.emit(trace, config)
	if not trace then
		return
	end

	local serializer = require("failed_request_trace.serializer")
	local serialized = serializer.serialize(trace, config)

	if serialized and serialized ~= "" then
		ngx.log(ngx.INFO, serialized)
	end
end

return M
