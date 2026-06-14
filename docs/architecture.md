# Architecture

## Overview

Failed Request Trace (FRT) is implemented as a Lua-based request tracing framework for OpenResty and NGINX.

The project uses multiple NGINX execution phases to capture request and response information throughout the request lifecycle.

## Request Flow

Client
    ↓
Rewrite Phase
    ↓
Access Phase
    ↓
Application Processing
    ↓
Header Filter Phase
    ↓
Log Phase
    ↓
JSON Trace

## Rewrite Phase

### Purpose:

* Initialize request context
* Generate request identifiers
* Preserve correlation identifiers

### Responsibilities:

* Create request ID if missing
* Store request context

## Access Phase

### Purpose:

Capture inbound request information.

### Responsibilities:

* HTTP method
* URI
* Host
* Request headers
* Query string parameters

## Header Filter Phase

### Purpose:

Capture outbound response information.

### Responsibilities:

* HTTP status code
* Response headers
* Upstream status information

## Log Phase

### Purpose:

Generate final trace output.

### Responsibilities:

* Timing information
* Redaction processing
* JSON serialization
* Trace emission

## Components

### capture.lua

Responsible for collecting request and response data.

### redact.lua

Responsible for masking sensitive information.

### serializer.lua

Responsible for generating structured output.

### logger.lua

Responsible for emitting traces.

### config.lua

Responsible for managing runtime configuration.

## Output

FRT emits structured JSON traces.

Example:

```JSON
{
  "request_id": "test-123",
  "request": {
    "method": "GET",
    "uri": "/index.html"
  },
  "response": {
    "status": 200
  }
}
```

## Future Architecture

Planned future implementations include:

* AWS Lambda
* AWS API Gateway
* Envoy Proxy
* Cloudflare Workers
* Kubernetes Ingress Controllers

Each implementation will follow the same model:

Capture
    ↓
Redact
    ↓
Serialize
    ↓
Emit