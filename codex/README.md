# LinkPing for Codex

Codex plugin package: `.codex-plugin/plugin.json`, the hosted MCP connection in `.mcp.json`,
and the LinkPing skills (each with Codex's `agents/openai.yaml`).

```sh
codex plugin marketplace add Elyyta/linkping-plugin@staging
codex plugin add linkping
codex mcp login linkping
```

Authentication is OAuth in the browser; no key or token lives in this repository. Start a
new conversation after logging in so Codex discovers the tools. The MCP endpoint is
`https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp`.

This package is a distribution snapshot: `skills/` is generated from the main LinkPing
repository and overwritten on every sync.
