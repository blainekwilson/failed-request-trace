# Testing

## Overview

This document provides testing procedures for validating Failed Request Trace (FRT) functionality.

### Build

Build the container:

```bash
docker build -t failed-request-trace:latest -f modules/nginx-openresty/nginx/Dockerfile modules/nginx-openresty
```

### Run

Run the container:

```bash
docker run -p 80:8080 failed-request-trace:latest
```

Verify:

```bash
curl http://localhost/
```

Expected:

```Plain text
HTTP 200
```

⸻

## Header Capture Test

Execute:

```bash
curl -i http://localhost/ \
-H "X-Request-ID: test-123" \
-H "X-Correlation-ID: corr-456"
```

Expected trace:

```JSON
{
  "x-request-id":"test-123",
  "x-correlation-id":"corr-456"
}
```

⸻

## Sensitive Header Redaction Test

Execute:

```bash
curl -i http://localhost/ \
-H "Authorization: Bearer secret" \
-H "Cookie: sessionid=secret"
```

Expected trace:

```JSON
{
  "authorization":"[REDACTED]",
  "cookie":"[REDACTED]"
}
```

⸻

## Unredacted Header Test

Configure:

```Lua
request_headers_unredacted = {
    "authorization"
}
```

Execute:

```bash
curl -i http://localhost/ \
-H "Authorization: Bearer secret"
```

Expected trace:

```JSON
{
  "authorization":"Bearer secret"
}
```

⸻

## Query String Redaction Test

Execute:

```bash
curl -i \
'http://localhost/?username=bob&password=secret'
```

Expected trace:

```JSON
{
  "username":"bob",
  "password":"[REDACTED]"
}
```

⸻

## Access Log Validation

Verify access logs do not contain query strings.

Expected:

```Plain text
GET /index.html HTTP/1.1
```

Not:

```Plain text
GET /index.html?password=secret HTTP/1.1
```

⸻

## Container Logging Validation

Verify:

* Access logs are written to stdout.
* Error logs are written to stderr.
* FRT traces are written to stdout.

Commands:

```bash
docker logs <container>
```

Review output for expected trace records.

⸻

## Non-Root Container Validation

Verify container executes successfully as a non-root user.

Expected:

```Plain text
Container starts successfully.
```

Verify:

```bash
docker exec -it <container> id
```

Expected:

```Plain text
uid != 0
```

⸻

## Regression Tests

Run all tests after:

* Configuration changes
* Redaction changes
* Serializer changes
* Logging changes
* Dockerfile changes