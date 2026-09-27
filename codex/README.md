# LinkPing for Codex

Codex plugin package: `.codex-plugin/plugin.json`, the hosted MCP connection in `.mcp.json`,
and the LinkPing skills (each with Codex's `agents/openai.yaml`).

## Requirements

- Codex with plugin support.
- A LinkPing account with at least one product set up.
- Network access to `https://backlink-hub-staging.zhengzhongwei888-232.workers.dev`, the only
  origin the plugin contacts. No Node installation is needed for this package.

## Install

```sh
codex plugin marketplace add Elyyta/linkping-plugin@staging
codex plugin add linkping@linkping
codex mcp login linkping
```

Authentication is OAuth in the browser; no key or token lives in this repository. Prefer
the running host's supported installation and OAuth flow when available; independent CLI
installation/login may not refresh the desktop runtime. The MCP endpoint is
`https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp`.

## Verify

```sh
codex plugin list --marketplace linkping --json
```

Installation and configuration checks do not prove that the current conversation can
call tools. Check its actual LinkPing tool catalog, read `linkping-basics`, and verify
with a read-only `list_products` call (an empty list is also success). Continue the
original request in the same conversation once verified.

If tools are missing, use the running host's available, documented refresh/reconnect
capability once, then check again. Do not repeat a successful login, reinstall, invent
a refresh command or start another app-server. Only if that refresh is unavailable or
the tools remain missing, use a new conversation as a fallback with the exact blocker
and original request. A new conversation does not fix an unresolved OAuth/server error.

## Update

```sh
codex plugin marketplace upgrade linkping
```

This package is a distribution snapshot: `skills/` is generated from the main LinkPing
repository and overwritten on every sync.

MIT licensed; see the [LICENSE](../LICENSE) at the repository root.
