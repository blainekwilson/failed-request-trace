# Security Model

## Overview

Failed Request Trace (FRT) is designed to provide detailed request diagnostics while minimizing the risk of exposing sensitive data.

Traditional troubleshooting tools often capture complete requests and responses, including credentials, session identifiers, authentication tokens, and sensitive query string parameters. While useful for troubleshooting, these traces can introduce significant security risks when stored in centralized logging systems.

FRT follows a security-first design:

Request
    ↓
Capture
    ↓
Allowlist
    ↓
Redaction
    ↓
Serialization
    ↓
stdout

## Header Capture

Headers are not captured automatically.

Only headers listed in the configured allowlist are eligible for capture.

Example:

```Lua
request_headers_allowlist = {
    "host",
    "user-agent",
    "authorization",
    "cookie"
}
```

### Sensitive Header Protection

FRT contains a built-in list of sensitive headers that are automatically redacted.

Examples include:

* Authorization
* Cookie
* Set-Cookie
* X-API-Key
* Proxy-Authorization

Example output:

```JSON
{
  "authorization": "[REDACTED]",
  "cookie": "[REDACTED]"
}
```

Administrators may explicitly override redaction for troubleshooting purposes.

## Query String Capture

Query string parameters must be explicitly allowlisted before they are captured.

Example:

```Lua
query_args_allowlist = {
    "username",
    "email",
    "password"
}
```

Parameters not listed are ignored.

### Sensitive Query Parameters

FRT automatically redacts known sensitive query string parameters.

Examples include:

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
* sessionid
* session_id

Example output:

```JSON
{
  "username": "jsmith",
  "password": "[REDACTED]"
}
```

## Access Log Considerations

FRT only controls its own trace output.

NGINX access logs may expose sensitive data if the following variables are logged:

* $request
* $request_uri
* $args
* $query_string

FRT recommends logging:

```Nginx
"$request_method $uri $server_protocol"
```

instead of:

```Nginx
"$request"
```

to prevent accidental query string disclosure.

## Container Logging

FRT emits traces to stdout.

NGINX access logs are directed to stdout.

NGINX error logs are directed to stderr.

This approach aligns with modern container platforms including:

* Docker
* Kubernetes
* AWS ECS
* AWS Fargate
* OpenShift

## Design Goals

* Secure by default
* Explicit capture
* Explicit disclosure
* Cloud-native logging
* Minimal operational risk
* Maximum troubleshooting value