-- lua/failed_request_trace/redact.lua
--
-- Sensitive value redaction.
-- Masks sensitive headers and values before serialization.

local M = {}

local REDACTED = "[REDACTED]"

-- Redact a single value
-- Returns REDACTED if value is sensitive, otherwise returns the original value
function M.redact_value(value)
  if value == nil then
    return nil
  end
  return REDACTED
end

-- Redact a headers table
-- Input: headers table (e.g., from ngx.req.get_headers())
-- Output: new table with sensitive headers redacted
function M.redact_headers(headers, config)
  if not headers then
    return {}
  end
  
  local redacted = {}
  local denylist = config.sensitive_headers_denylist or {}
  
  for name, value in pairs(headers) do
    local lower_name = string.lower(name)
    
    if denylist[lower_name] then
      redacted[name] = REDACTED
    else
      redacted[name] = value
    end
  end
  
  return redacted
end

return M
