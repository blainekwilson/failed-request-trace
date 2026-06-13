-- lua/failed_request_trace/init.lua
--
-- FailedRequestTrace public API.
-- Main entry point for initialization and phase handlers.

local M = {}

-- Module-level config (persists across requests at init time)
local module_config

-- Initialize FailedRequestTrace
-- Called once at startup in init_by_lua_block
-- user_config is optional and merges with defaults
function M.init(user_config)
  local config = require("failed_request_trace.config")
  module_config = config.merge(user_config)
end

-- Rewrite phase handler
function M.rewrite()
  if not module_config then
    local config = require("failed_request_trace.config")
    module_config = config.get()
  end
  
  if module_config.enabled then
    local rewrite_phase = require("failed_request_trace.phases.rewrite")
    rewrite_phase.run(module_config)
  end
end

-- Access phase handler
function M.access()
  if module_config and module_config.enabled then
    local access_phase = require("failed_request_trace.phases.access")
    access_phase.run(module_config)
  end
end

-- Header filter phase handler
function M.header_filter()
  if module_config and module_config.enabled then
    local header_filter_phase = require("failed_request_trace.phases.header_filter")
    header_filter_phase.run(module_config)
  end
end

-- Log phase handler
function M.log()
  if module_config and module_config.enabled then
    local log_phase = require("failed_request_trace.phases.log")
    log_phase.run(module_config)
  end
end

return M
