# LinkPing agent plugins

LinkPing is a backlink and directory-submission workbench. This repository is only the
packaging that connects an agent host to LinkPing's remote MCP server, plus the skills that
tell the agent how to work a backlink plan. No application source, no data, no credentials.

| Host | Package | Install |
| --- | --- | --- |
| Claude Code | `claude/` | `claude plugin marketplace add https://github.com/Elyyta/linkping-plugin.git#staging` then `claude plugin install linkping@linkping` |
| Codex | `codex/` | `codex plugin marketplace add Elyyta/linkping-plugin@staging` then `codex plugin add linkping@linkping`, `codex mcp login linkping` |
| Cursor, Grok Bot | `cursor/` | Plugins screen → Add → Authorize ([details](./cursor/README.md)) |
| Kimi Work | `kimi/` | Import the package, Login on the connector card ([details](./kimi/README.md)) |

Every package points at the same endpoint and authenticates over OAuth in the browser:

```text
https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp
```

Installing does not sign you in; the host handles that on install or first use. Plugin tools
are loaded when a conversation starts, so authorize first, then open a new conversation.

## Branches

`staging` points at the staging deployment. There is no production deployment yet, so there
is deliberately no `main` branch and no production URL anywhere in this repository. Install
with `…#staging` until one exists.

## Skills are generated

Every `<host>/skills/` directory is generated from `cli/skills/` in the main LinkPing
repository by `scripts/sync-plugin-skills.ts`, the single source of truth. Edits made here
are overwritten on the next sync; change the skill in the main repository instead. Only the
Codex package carries `agents/openai.yaml`, Codex's own skill front matter.

Hand-maintained here: the manifests, the READMEs, the icons, and
`claude/skills/linkping-basics/login-linkping.sh`.
