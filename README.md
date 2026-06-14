Failed Request Trace (FRT)

Failed Request Trace (FRT) is a cloud-native request tracing and diagnostics framework for NGINX and OpenResty.

The project was inspired by Microsoft IIS Failed Request Event Buffering (FREB) and provides detailed request and response visibility for modern architectures that use reverse proxies, load balancers, WAFs, containers, and cloud-native infrastructure.

FRT is designed to help engineers answer questions such as:

* Did the request reach NGINX?
* Did the request contain the expected headers?
* Were cookies received by the application?
* What response headers were returned?
* Did a WAF, proxy, or load balancer modify the request?
* Why is authentication failing?
* What happened between the client and the application?

FRT captures request and response metadata and emits structured traces suitable for troubleshooting modern web applications.

Features

* Request and response header tracing
* Request correlation IDs
* Configurable header capture allowlists
* Secure redaction of sensitive values
* Optional unredacted troubleshooting mode
* Structured JSON output
* OpenResty and NGINX support
* Container-friendly logging
* Cloud-native deployment model

Security

FRT is designed to be secure by default.

Sensitive values such as Authorization headers, Cookies, Set-Cookie headers, API keys, and authentication tokens are redacted automatically.

Sensitive headers may be explicitly unredacted for troubleshooting purposes when required by adding the headers in the nginx.conf file.

Quick Start

Build the container:

``` bash
docker build -t failed-request-trace:latest -f nginx/Dockerfile .
```

Run the container:

``` bash
docker run -p 80:8080 failed-request-trace:latest
```

Open a browser:

http://localhost

Generate Test Traffic

The following example sends several commonly used troubleshooting headers:

``` bash
curl -i http://localhost/ \
  -H "X-Request-ID: test-123" \
  -H "X-Correlation-ID: corr-456" \
  -H "Referer: http://example.com/" \
  -H "Accept-Language: en-US" \
  -H "Authorization: Bearer secret" \
  -H "Cookie: sessionid=secret"
```

Example Trace

``` JSON
{
  "request_id": "test-123",
  "request": {
    "method": "GET",
    "uri": "/index.html",
    "headers": {
      "authorization": "[REDACTED]",
      "cookie": "[REDACTED]",
      "referer": "http://example.com/"
    }
  },
  "response": {
    "status": 200
  }
}
```

Project Goals

* Provide FREB-like diagnostics for NGINX and OpenResty
* Simplify troubleshooting of WAF and reverse proxy issues
* Support containerized and cloud-native deployments
* Provide structured traces suitable for operational analysis
* Remain secure by default

Roadmap

* FREB-compatible XML output
* AWS ECS/Fargate deployment examples
* CloudWatch integration
* OpenSearch integration
* WAF troubleshooting playbooks
* Additional proxy and ingress support