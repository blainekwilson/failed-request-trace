# Configuration

## Overview

Failed Request Trace (FRT) is configured during NGINX startup using the frt.init() function within the init_by_lua_block.

Example:

```Lua
frt.init({
    output_format = "json"
})
```

output_format

Controls the output serialization format.

Current supported values:

```Lua
output_format = "json"
```

Future planned values:

```Lua
output_format = "xml"
```

Default:

```Lua
output_format = "json"
```

⸻

request_headers_allowlist

Defines request headers eligible for capture.

Only headers listed here may appear in traces.

Example:

```Lua
request_headers_allowlist = {
    "host",
    "user-agent",
    "authorization",
    "cookie"
}
```

⸻

response_headers_allowlist

Defines response headers eligible for capture.

Example:

```Lua
response_headers_allowlist = {
    "content-type",
    "content-length",
    "set-cookie"
}
```

⸻

request_headers_unredacted

Overrides built-in header redaction.

By default, sensitive headers are automatically redacted.

Example:

```Lua
request_headers_unredacted = {
    "authorization"
}
```

Example output:

```JSON
{
  "authorization":"Bearer abc123"
}
```

Warning:

Unredacted sensitive values may expose credentials or session information.

⸻

query_args_allowlist

Defines query string parameters eligible for capture.

Only parameters listed here will appear in traces.

Example:

```Lua
query_args_allowlist = {
    "username",
    "email",
    "password"
}
```

Example request:

```http
/login?username=bob&password=secret
```

Example trace:

```JSON
{
  "username":"bob",
  "password":"[REDACTED]"
}
```

⸻

Built-In Sensitive Headers

The following headers are automatically redacted:

* Authorization
* Cookie
* Set-Cookie
* X-API-Key
* Proxy-Authorization

⸻

Built-In Sensitive Query Parameters

The following query string parameters are automatically redacted:

* password
* passwd
* pwd
* token
* access_token
* refresh_token
* id_token
* client_secret
* api_key
* apikey
* jwt
* sessionid
* session_id

⸻

Example Configuration

```Lua
frt.init({
    output_format = "json",
    request_headers_allowlist = {
        "host",
        "user-agent",
        "authorization",
        "cookie"
    },
    response_headers_allowlist = {
        "content-type",
        "content-length"
    },
    request_headers_unredacted = {
        "authorization"
    },
    query_args_allowlist = {
        "username",
        "password"
    }
})
```