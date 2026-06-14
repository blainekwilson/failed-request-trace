# Running FRT as a Non-Root Container

## Overview

Failed Request Trace (FRT) is designed to run as a non-root container.

Running applications as root inside containers increases risk and is commonly flagged by container security tools and static analysis platforms.

Examples:

* Semgrep
* Trivy
* Grype
* Docker Bench
* Kubernetes Security Benchmarks

## Initial Issue

The original container executed OpenResty as root.

Example:

```dockerfile
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
```

without switching users.

Security tools identified this as a container hardening issue.

## Non-Root Requirements

To run successfully as a non-root user:

### Remove User Directive

Remove:

```Nginx
user nginx;
```

from nginx.conf.

The directive is unnecessary once the container already executes as a non-root user.

### Use High Ports

Non-root processes cannot bind to privileged ports.

Updated:

```Nginx
listen 8080;
```

instead of:

```Nginx
listen 80;
```

Docker port mapping provides external access:

```bash
docker run -p 80:8080 failed-request-trace:latest
```

## Writable Directories

OpenResty requires write access to runtime directories.

Examples:

* client_body_temp
* proxy_temp
* fastcgi_temp
* uwsgi_temp
* scgi_temp

These directories must be created and assigned to the container user.

PID File

The default PID location may require elevated privileges.

Use:

```Nginx
pid /tmp/nginx.pid;
```

instead of privileged locations.

## Logging

Container-native logging is recommended.

### Error logs:

```Nginx
error_log /dev/stderr warn;
```

### Access logs:

```Nginx
access_log /dev/stdout main;
```

### FRT traces:

```Plain text
stdout
```

## Benefits

Running as a non-root user provides:

* Reduced attack surface
* Improved compliance posture
* Better Kubernetes compatibility
* Better OpenShift compatibility
* Improved container security scanning results

## Verification

Confirm container user:

```bash
docker exec -it <container> id
```

Expected:

```Plain text
uid != 0
```

Confirm listener:

```bash
netstat -tln
```

Expected:

```Plain text
0.0.0.0:8080
```

Future Enhancements

Future releases may include:

* Read-only filesystem support
* Distroless container images
* OpenShift-specific deployment examples
* Kubernetes Pod Security Standards validation
* AWS ECS/Fargate deployment guidance