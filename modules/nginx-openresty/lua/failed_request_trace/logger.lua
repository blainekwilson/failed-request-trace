-- lua/failed_request_trace/logger.lua

local M = {}

local serializer = require("failed_request_trace.serializer")

function M.emit(trace, config)
    local serialized, err = serializer.serialize(trace, config)

    if not serialized then
        ngx.log(ngx.ERR, "FailedRequestTrace serialization failed: ", err or "unknown error")
        return
    end

    io.stdout:write(serialized .. "\n")
end

return M