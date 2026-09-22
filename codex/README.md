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

Authentication is OAuth in the browser; no key or token lives in this repository. Start a
new conversation after logging in so Codex discovers the tools. The MCP endpoint is
`https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp`.

## Verify

```sh
codex plugin list --marketplace linkping --json
```

Then ask for something read-only, such as `列出我的产品` (`list_products`).

## Update

```sh
codex plugin marketplace upgrade linkping
```

This package is a distribution snapshot: `skills/` is generated from the main LinkPing
repository and overwritten on every sync.

MIT licensed; see the [LICENSE](../LICENSE) at the repository root.
