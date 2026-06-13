-- lua/failed_request_trace/capture.lua
--
-- Request and response data capture.
-- Captures headers, timing, and metadata within allowlist constraints.

local M = {}

-- Capture request data
-- Called in the access phase
function M.capture_request(config)
  local request = {
    method = ngx.req.get_method(),
    uri = ngx.var.uri,
    args = ngx.var.args or "",
    host = ngx.var.host or ngx.var.server_name or "",
    headers = {},
  }
  
  -- Capture request headers (allowlist only)
  if config.capture_request_headers then
    local all_headers = ngx.req.get_headers()
    local allowlist = config.request_headers_allowlist or {}
    
    for name, value in pairs(all_headers) do
      local lower_name = string.lower(name)
      if allowlist[lower_name] then
        request.headers[lower_name] = value
      end
    end
  end
  
  return request
end

-- Capture response data
-- Called in the header_filter phase
function M.capture_response(config)
  local response = {
    status = ngx.status or 0,
    headers = {},
  }
  
  -- Capture upstream status if available
  if ngx.var.upstream_status then
    response.upstream_status = ngx.var.upstream_status
  end
  
  -- Capture response headers (allowlist only)
  if config.capture_response_headers then
    local all_headers = ngx.resp.get_headers()
    local allowlist = config.response_headers_allowlist or {}
    
    for name, value in pairs(all_headers) do
      local lower_name = string.lower(name)
      if allowlist[lower_name] then
        response.headers[lower_name] = value
      end
    end
  end
  
  return response
end

-- Capture timing information
-- Called in the log phase
function M.capture_timing()
  local timing = {
    request_time = tonumber(ngx.var.request_time) or 0,
  }
  
  -- Include upstream response time if available
  if ngx.var.upstream_response_time then
    timing.upstream_response_time = ngx.var.upstream_response_time
  end
  
  return timing
end

return M
