# Contributing to Failed Request Trace (FRT)

Thank you for your interest in contributing to Failed Request Trace.

## Project Goals

Failed Request Trace (FRT) aims to provide secure, cloud-native request diagnostics for modern infrastructure platforms.

Current focus areas include:

* NGINX
* OpenResty
* Containers
* AWS
* Kubernetes
* Observability
* Secure logging

## Ways to Contribute

Contributions are welcome in several areas:

### Bug Reports

Please include:

* Version
* Configuration
* Reproduction steps
* Expected behavior
* Actual behavior

### Feature Requests

Please describe:

* Problem statement
* Proposed solution
* Alternative approaches considered

### Documentation

Documentation improvements are highly valued.

Examples:

* Deployment guides
* Cloud examples
* AWS examples
* Kubernetes examples
* Troubleshooting guides

### Code Contributions

Contributors should:

* Follow existing project structure
* Include tests when practical
* Update documentation as needed
* Keep security and privacy considerations in mind

### Security Principles

FRT is designed to be secure by default.

Contributions should:

* Minimize sensitive data exposure
* Preserve redaction controls
* Favor allowlist approaches over denylist approaches
* Consider operational security implications

### Development Setup

Build:

```bash
docker build -t failed-request-trace:latest \
  -f modules/nginx-openresty/nginx/Dockerfile \
  modules/nginx-openresty
```

Run:

```bash
docker run -p 80:8080 failed-request-trace:latest
```

### Reporting Security Issues

Please do not open public issues for suspected security vulnerabilities.

Instead, open a private discussion or contact the maintainer directly.

### Code of Conduct

Be respectful.

Constructive feedback, technical debate, and differing opinions are welcome.

Personal attacks, harassment, or abusive behavior are not.

### License

By contributing to this project, you agree that your contributions will be licensed under the project’s existing license.