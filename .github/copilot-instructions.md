# FailedRequestTrace Copilot Instructions

This repository builds FailedRequestTrace, a cloud-native request diagnostic tool for OpenResty/NGINX, containers, and AWS infrastructure.

## Project goals

- Provide FREB-like request diagnostics for NGINX/OpenResty.
- Prioritize security, safe logging, redaction, and operational clarity.
- Emit structured JSON logs to stdout for Docker, ECS, and CloudWatch.
- Keep the project understandable for security engineers, cloud architects, and AppSec teams.

## Coding rules

- Prefer small modules with single responsibility.
- Do not create large monolithic Lua files.
- Do not add external dependencies unless explicitly requested.
- Do not log secrets, bearer tokens, session IDs, API keys, authorization headers, or full cookie values.
- Redaction must be default-deny: sensitive values are masked unless explicitly allowlisted.
- All log output must be structured JSON.
- Avoid global variables except where required by OpenResty initialization.
- Functions should return explicit values and errors where practical.
- Keep configuration centralized in `lua/failed_request_trace/config.lua`.
- Keep public entry points in `lua/failed_request_trace/init.lua`.
- Add comments only where they explain security-sensitive behavior or non-obvious NGINX/OpenResty phase behavior.

## Architecture rules

- NGINX phase handlers must live under `lua/failed_request_trace/phases/`.
- Request context and correlation ID logic must live in `context.lua`.
- Header/cookie capture logic must live in `capture.lua`.
- Redaction logic must live in `redact.lua`.
- JSON shaping must live in `serializer.lua`.
- Logging transport must live in `logger.lua`.
- Do not mix capture, redaction, serialization, and logging in the same module.

## Testing and validation

- Prefer Docker-based testing over local Mac runtime assumptions.
- Generated code must be compatible with OpenResty LuaJIT / Lua 5.1 semantics.
- Do not use Lua 5.3+ features.
- Include curl examples when adding features.
- Include sample expected JSON log output when changing trace behavior.

## Documentation

- Document deployment for Docker first, then AWS ECS/Fargate.
- Explain security tradeoffs for any captured data.
- Warn users against logging sensitive data in production.