---
applyTo: "lua/**/*.lua"
---

# Lua/OpenResty Instructions

- Target OpenResty LuaJIT / Lua 5.1 compatibility.
- Use `local` for all variables and functions unless intentionally exporting from a module.
- Modules must return a table named `M`.
- Do not use the deprecated Lua `module()` function.
- Do not use Lua 5.3+ syntax or libraries.
- Use `ngx.var`, `ngx.req`, `ngx.header`, and `ngx.ctx` only in phase-aware code.
- Store per-request state in `ngx.ctx`.
- Do not perform blocking network calls.
- Do not read request bodies unless explicitly requested.
- Do not log raw `Authorization`, `Cookie`, `Set-Cookie`, API keys, tokens, or passwords.
- All emitted trace records must pass through `redact.lua` before serialization.
- Keep phase files thin; they should call shared modules rather than implement business logic.