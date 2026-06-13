-- lua/failed_request_trace/formatters/json.lua
--
-- JSON output formatter.
-- Serializes trace data to structured JSON using cjson.safe.

local M = {}

-- Format trace as JSON
function M.format(trace, config)
  local cjson = require("cjson.safe")
  
  if not trace then
    return "{}"
  end
  
  local output = {
    timestamp = ngx.time(),
    request_id = trace.request_id or "",
    request = trace.request or {},
    response = trace.response or {},
    timing = trace.timing or {},
  }
  
  local json_str = cjson.encode(output)
  
  if not json_str then
    -- Fallback if encoding fails
    return "{}"
  end
  
  return json_str
end

return M
