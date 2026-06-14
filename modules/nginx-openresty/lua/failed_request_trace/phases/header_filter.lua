-- lua/failed_request_trace/phases/header_filter.lua
--
-- Header filter phase handler.
-- Captures response headers and status code.

local M = {}

-- Header filter phase entry point
function M.run(config)
	local capture = require("failed_request_trace.capture")

	local frt = ngx.ctx.frt
	if not frt then
		return
	end

	frt.response_data = capture.capture_response(config)
end

return M
