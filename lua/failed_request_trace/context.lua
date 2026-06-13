-- lua/failed_request_trace/context.lua
--
-- Request context initialization and per-request state management.
-- Stores state in ngx.ctx.frt to avoid namespace collisions.

local M = {}

-- Initialize request context
-- Called early in the request lifecycle (rewrite phase)
function M.initialize(config)
	if not ngx.ctx.frt then
		ngx.ctx.frt = {
			request_id = M.ensure_request_id(),
			config = config,
			request_data = {},
			response_data = {},
			timing = {},
		}
	end
	return ngx.ctx.frt
end

-- Generate or retrieve request ID
-- Checks for existing IDs in headers (x-request-id, x-correlation-id)
-- Falls back to generating a UUID-like string
function M.ensure_request_id()
	local existing_id = ngx.var.http_x_request_id or ngx.var.http_x_correlation_id

	if existing_id and existing_id ~= "" then
		return existing_id
	end

	-- Generate a simple request ID: timestamp-random
	local timestamp = string.format("%x", ngx.time())
	local random = string.format("%08x", math.random(0, 0xffffffff))
	return timestamp .. "-" .. random
end

-- Get current request ID
function M.get_request_id()
	if ngx.ctx.frt then
		return ngx.ctx.frt.request_id
	end
	return M.ensure_request_id()
end

return M
