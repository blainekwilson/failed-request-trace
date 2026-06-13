-- lua/failed_request_trace/phases/rewrite.lua
--
-- Rewrite phase handler.
-- Initializes request context and request ID.

local M = {}

-- Rewrite phase entry point
function M.run(config)
	local context = require("failed_request_trace.context")
	context.initialize(config)
end

return M
