-- lua/failed_request_trace/formatters/xml.lua
--
-- XML output formatter (placeholder).
-- Provides a simple XML representation of trace data.
-- Future enhancements can make this more FREB-like.

local M = {}

-- Format trace as XML
function M.format(trace, config)
  if not trace then
    return "<trace></trace>"
  end
  
  local request_id = trace.request_id or ""
  local method = (trace.request and trace.request.method) or ""
  local uri = (trace.request and trace.request.uri) or ""
  local status = (trace.response and trace.response.status) or ""
  local request_time = (trace.timing and trace.timing.request_time) or ""
  
  local xml = string.format(
    '<trace request_id="%s" timestamp="%d">' ..
    '<request method="%s" uri="%s" />' ..
    '<response status="%s" />' ..
    '<timing request_time="%s" />' ..
    '</trace>',
    request_id,
    ngx.time(),
    method,
    uri,
    status,
    request_time
  )
  
  return xml
end

return M
