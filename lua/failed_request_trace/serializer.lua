-- lua/failed_request_trace/serializer.lua
--
-- Trace serialization and formatter delegation.
-- Selects the appropriate formatter based on output_format config.

local M = {}

-- Serialize a trace
-- Selects formatter based on config.output_format
-- Input: trace table with request, response, timing
-- Output: formatted string
function M.serialize(trace, config)
  if not trace then
    return ""
  end
  
  local output_format = config.output_format or "json"
  
  if output_format == "xml" then
    local xml_formatter = require("failed_request_trace.formatters.xml")
    return xml_formatter.format(trace, config)
  else
    -- Default to JSON
    local json_formatter = require("failed_request_trace.formatters.json")
    return json_formatter.format(trace, config)
  end
end

return M
