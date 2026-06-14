-- lua/failed_request_trace/config.lua
--
-- Default configuration for FailedRequestTrace.
-- Users can override via init(user_config).

local M = {}

-- Default configuration table
local default_config = {
	enabled = true,
	output_format = "json",

	capture_request_headers = true,
	capture_response_headers = true,
    capture_query_args = true,

	request_headers_allowlist = {
		["host"] = true,
		["user-agent"] = true,
		["accept"] = true,
		["accept-encoding"] = true,
		["accept-language"] = true,
		["content-type"] = true,
		["content-length"] = true,
		["origin"] = true,
		["referer"] = true,
		["x-forwarded-for"] = true,
		["x-forwarded-proto"] = true,
		["x-forwarded-host"] = true,
		["x-real-ip"] = true,
		["x-request-id"] = true,
		["x-correlation-id"] = true,
		["authorization"] = true,
		["cookie"] = true,
	},

	response_headers_allowlist = {
		["content-type"] = true,
		["content-length"] = true,
		["location"] = true,
		["server"] = true,
		["date"] = true,
		["cache-control"] = true,
		["etag"] = true,
		["last-modified"] = true,
		["x-request-id"] = true,
		["x-correlation-id"] = true,
		["set-cookie"] = true,
	},

	-- Explicit exceptions to built-in redaction.
	-- Dangerous: values listed here may expose tokens, cookies, or secrets in logs.
	request_headers_unredacted = {},
	response_headers_unredacted = {},

    query_args_allowlist = {
        ["username"] = true,
        ["user"] = true,
        ["userid"] = true,
        ["email"] = true,
    },

    query_args_unredacted = {},
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
