-- lua/failed_request_trace/phases/access.lua
--
-- Access phase handler.
-- Captures request data (headers, method, URI, etc.).

local M = {}

-- Access phase entry point
function M.run(config)
  local context = require("failed_request_trace.context")
  local capture = require("failed_request_trace.capture")
  
  local frt = context.initialize(config)
  frt.request_data = capture.capture_request(config)
end

return M
