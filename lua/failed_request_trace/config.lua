-- lua/failed_request_trace/config.lua
--
-- Default configuration for FailedRequestTrace.
-- Users can override via init(user_config).

local M = {}

-- Default configuration table
local default_config = {
  enabled = true,
  output_format = "json",  -- "json" or "xml"
  
  -- Capture request/response headers
  capture_request_headers = true,
  capture_response_headers = true,
  
  -- Request header allowlist (lowercased)
  request_headers_allowlist = {
    ["host"] = true,
    ["user-agent"] = true,
    ["accept"] = true,
    ["content-type"] = true,
    ["x-forwarded-for"] = true,
    ["x-forwarded-proto"] = true,
    ["x-request-id"] = true,
    ["x-correlation-id"] = true,
  },
  
  -- Response header allowlist (lowercased)
  response_headers_allowlist = {
    ["content-type"] = true,
    ["location"] = true,
    ["x-request-id"] = true,
    ["x-correlation-id"] = true,
  },
  
  -- Sensitive header denylist (lowercased) - always redact regardless of allowlist
  sensitive_headers_denylist = {
    ["authorization"] = true,
    ["cookie"] = true,
    ["set-cookie"] = true,
    ["x-api-key"] = true,
    ["proxy-authorization"] = true,
  },
}

-- Get a copy of the default configuration
function M.get()
  local config = {}
  for k, v in pairs(default_config) do
    if type(v) == "table" then
      -- Deep copy tables
      config[k] = {}
      for tk, tv in pairs(v) do
        config[k][tk] = tv
      end
    else
      config[k] = v
    end
  end
  return config
end

-- Merge user config with defaults
-- User config values override defaults
function M.merge(user_config)
  local config = M.get()
  
  if not user_config then
    return config
  end
  
  for k, v in pairs(user_config) do
    if type(v) == "table" and type(config[k]) == "table" then
      -- Merge table values
      for tk, tv in pairs(v) do
        config[k][tk] = tv
      end
    else
      config[k] = v
    end
  end
  
  return config
end

return M
