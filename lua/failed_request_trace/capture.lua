-- lua/failed_request_trace/capture.lua

local M = {}

local redact = require("failed_request_trace.redact")

local function build_lookup(list)
	local lookup = {}

	for key, value in pairs(list or {}) do
		if type(key) == "number" then
			lookup[string.lower(tostring(value))] = true
		else
		lookup[string.lower(tostring(key))] = value and true or false
		end
	end

	return lookup
end

local function capture_allowed_headers(all_headers, allowlist)
	local captured = {}
	local allowed = build_lookup(allowlist)

	for name, value in pairs(all_headers or {}) do
		local lower_name = string.lower(tostring(name))

		if allowed[lower_name] then
			captured[lower_name] = value
		end
	end

	return captured
end

local function capture_allowed_query_args(all_args, allowlist)
	local captured = {}
	local allowed = build_lookup(allowlist)

	for name, value in pairs(all_args or {}) do
		local lower_name = string.lower(tostring(name))

		if allowed[lower_name] then
			captured[lower_name] = value
		end
	end

	return captured
end

function M.capture_request(config)
	local request = {
		method = ngx.req.get_method(),
		uri = ngx.var.uri,
		query = {},
		host = ngx.var.host or ngx.var.server_name or "",
		headers = {},
	}

	if config.capture_request_headers then
		request.headers = capture_allowed_headers(
			ngx.req.get_headers(),
			config.request_headers_allowlist
		)
	end

	if config.capture_query_args then
		local allowed_query_args = capture_allowed_query_args(
			ngx.req.get_uri_args(),
			config.query_args_allowlist
		)

		request.query = redact.redact_query_args(
			allowed_query_args,
			config
		)
	end

	return request
end

function M.capture_response(config)
	local response = {
		status = ngx.status or 0,
		headers = {},
	}

	if ngx.var.upstream_status then
		response.upstream_status = ngx.var.upstream_status
	end

	if config.capture_response_headers then
		response.headers = capture_allowed_headers(
			ngx.resp.get_headers(),
			config.response_headers_allowlist
		)
	end

	return response
end

function M.capture_timing()
	local timing = {
		request_time = tonumber(ngx.var.request_time) or 0,
	}

	if ngx.var.upstream_response_time then
		timing.upstream_response_time = ngx.var.upstream_response_time
	end

	return timing
end

return M