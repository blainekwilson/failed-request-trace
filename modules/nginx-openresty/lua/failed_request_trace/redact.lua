-- lua/failed_request_trace/redact.lua
--
-- Sensitive value redaction.
-- Most captured headers are logged as-is.
-- Built-in sensitive headers are redacted by default unless explicitly unredacted.

local M = {}

local REDACTED = "[REDACTED]"

local BUILT_IN_SENSITIVE_HEADERS = {
	["authorization"] = true,
	["cookie"] = true,
	["set-cookie"] = true,
	["x-api-key"] = true,
	["proxy-authorization"] = true,
}

local BUILT_IN_SENSITIVE_QUERY_ARGS = {
    ["password"] = true,
    ["passwd"] = true,
    ["pwd"] = true,
    ["secret"] = true,
    ["token"] = true,
    ["access_token"] = true,
    ["refresh_token"] = true,
    ["id_token"] = true,
    ["client_secret"] = true,
    ["api_key"] = true,
    ["apikey"] = true,
    ["jwt"] = true,
    ["sessionid"] = true,
    ["session_id"] = true,
}

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

function M.redact_value(value)
	if value == nil then
		return nil
	end

	return REDACTED
end

function M.redact_headers(headers, config, scope)
	if not headers then
		return {}
	end

	config = config or {}
	scope = scope or "request"

	local unredacted

	if scope == "response" then
		unredacted = build_lookup(config.response_headers_unredacted)
	else
		unredacted = build_lookup(config.request_headers_unredacted)
	end

	local redacted = {}

	for name, value in pairs(headers) do
		local lower_name = string.lower(tostring(name))

		if BUILT_IN_SENSITIVE_HEADERS[lower_name] and not unredacted[lower_name] then
			redacted[lower_name] = REDACTED
		else
			redacted[lower_name] = value
		end
	end

	return redacted
end

function M.redact_query_args(args, config)
	if not args then
		return {}
	end

	config = config or {}

	local redacted = {}
	local unredacted = build_lookup(config.query_args_unredacted)

	for name, value in pairs(args) do
		local lower_name = string.lower(tostring(name))

		if BUILT_IN_SENSITIVE_QUERY_ARGS[lower_name] and not unredacted[lower_name] then
			redacted[lower_name] = REDACTED
		else
			redacted[lower_name] = value
		end
	end

	return redacted
end

return M
