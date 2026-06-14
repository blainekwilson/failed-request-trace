# WAF Troubleshooting Example

## Problem Statement

Application teams frequently report:

The WAF is deleting our cookies.

or

The WAF is removing authentication headers.

In many environments, these claims are difficult to verify because there is insufficient visibility into the request as it moves through the infrastructure.

## Typical Architecture

Client
 ↓
CDN
 ↓
WAF
 ↓
API Gateway
 ↓
Load Balancer
 ↓
NGINX
 ↓
Application

```Plain text
GET /login HTTP/1.1
Host: example.com
Authorization: Bearer abc123
Cookie: sessionid=xyz789
```

Failed Request Trace Output

```JSON
{
  "request": {
    "headers": {
      "authorization": "[REDACTED]",
      "cookie": "[REDACTED]"
    }
  }
}
```

## Analysis

The trace confirms:

* The Authorization header reached NGINX.
* The Cookie header reached NGINX.
* The WAF did not remove either header.

The issue must therefore exist elsewhere in the request path.

Potential causes include:

* Load balancer configuration
* Reverse proxy configuration
* Application logic
* Authentication middleware
* Identity provider configuration

OpenID Connect Example

A common scenario involves OpenID Connect deployments.

The application may incorrectly trust the origin server instead of the WAF.

Symptoms include:

* Redirect loops
* Authentication failures
* Missing state values
* Invalid callback URLs

In these situations, FRT can confirm that headers, cookies, and correlation identifiers are arriving correctly.

## Benefits

FRT provides:

* Objective evidence
* Reduced troubleshooting time
* Faster escalation resolution
* Improved collaboration between teams

### Recommended Process

1. Verify request reaches NGINX.
2. Verify expected headers are present.
3. Verify expected query parameters are present.
4. Verify response status.
5. Verify response headers.
6. Compare trace output with application logs.

This process eliminates guesswork and provides evidence-based troubleshooting.