-- .luacheckrc
-- Luacheck configuration for FailedRequestTrace

-- Recognize OpenResty/NGINX globals
globals = {
  "ngx",
}

-- Standard Lua + OpenResty environment
std = "lua51"

-- Allow unused arguments/variables when prefixed with underscore
unused_args = true
unused_secondaries = true
