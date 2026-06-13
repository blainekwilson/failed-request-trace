-- lua/failed_request_trace/phases/log.lua
--
-- Log phase handler.
-- Captures timing, applies redaction, and emits the final trace.

local M = {}

-- Log phase entry point
function M.run(config)
  local context = require("failed_request_trace.context")
  local capture = require("failed_request_trace.capture")
  local redact = require("failed_request_trace.redact")
  local logger = require("failed_request_trace.logger")
  
  local frt = ngx.ctx.frt
  if not frt then
    return
  end
  
  -- Capture timing
  frt.timing = capture.capture_timing()
  
  -- Redact headers before serialization
  if frt.request_data and frt.request_data.headers then
    frt.request_data.headers = redact.redact_headers(frt.request_data.headers, config)
  end
  
  if frt.response_data and frt.response_data.headers then
    frt.response_data.headers = redact.redact_headers(frt.response_data.headers, config)
  end
  
  -- Build final trace
  local trace = {
    request_id = frt.request_id,
    request = frt.request_data,
    response = frt.response_data,
    timing = frt.timing,
  }
  
  -- Emit the trace
  logger.emit(trace, config)
end

return M
