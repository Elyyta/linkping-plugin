# LinkPing agent plugins

LinkPing is a backlink and directory-submission workbench: it holds your product's copy, the
directory library, one submission row per (product, site), outreach drafts, and the crawler that
decides whether a listing actually went live. This repository is only the packaging that connects
an agent host to LinkPing's remote MCP server, plus the skills that tell the agent how to work a
backlink plan — the plan the workbench has already ordered for today, the copy each form needs,
outreach that stays a draft until you approve it, and listing checks. No application source, no
data, no credentials.

## What is included

| Host | Package | Install |
| --- | --- | --- |
| Claude Code | `claude/` | `claude plugin marketplace add https://github.com/Elyyta/linkping-plugin.git#staging` then `claude plugin install linkping@linkping` |
| Codex | `codex/` | `codex plugin marketplace add Elyyta/linkping-plugin@staging` then `codex plugin add linkping@linkping`, `codex mcp login linkping` |
| Cursor, Grok Bot | `cursor/` | Plugins screen → Add → Authorize ([details](./cursor/README.md)) |
| Kimi Work | `kimi/` | Import the package, Login on the connector card ([details](./kimi/README.md)) |

Each package carries its host's manifest (`claude/.claude-plugin/plugin.json`,
`codex/.codex-plugin/plugin.json` + `.mcp.json`, `cursor/.cursor-plugin/plugin.json` + `mcp.json`,
`kimi/kimi.plugin.json` + `.mcp.json`), its own copy of the six LinkPing skills, and the logo.
The two marketplace entries at the root are `.claude-plugin/marketplace.json` for Claude Code and
`.agents/plugins/marketplace.json` for Codex.

## Requirements

- An account on the LinkPing workbench, with at least one product set up.
- A supported host: Claude Code, Codex, Cursor or Grok Bot, or Kimi Work.
- Network access from the host to the workbench origin below. Nothing else is contacted.
- No Node installation is needed for the plugin hosts — these packages are manifests, Markdown and
  one shell helper. Only the separate `npx linkping` CLI needs Node.

## Authentication

Every package points at the same endpoint and authenticates over OAuth in the browser:

```text
https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp
```

Dynamic client registration and PKCE; the server derives the member from the token. No API key,
token or secret is stored in this repository. Installing does not sign you in — the host runs the
authorization flow on install or first use, and plugin tools are loaded when a conversation
starts, so authorize first, then open a new conversation.

To revoke: open the workbench's `/agent` page and revoke that machine under **已连接的机器**, and
remove the plugin or log out in the host itself (`claude mcp remove linkping`,
`codex mcp logout linkping`, or the Plugins screen in Cursor, Grok Bot and Kimi Work).

## Install per host

The workbench serves an agent-executable runbook per host. Give the agent the URL for your host
and ask it to install LinkPing; it reads the whole guide before running anything.

- Claude Code — [`/agent/setup?agent=claude-code`](https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/agent/setup?agent=claude-code)
- Codex — [`/agent/setup?agent=codex`](https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/agent/setup?agent=codex)
- Cursor, Grok Bot — [`/agent/setup?agent=cursor`](https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/agent/setup?agent=cursor)
- Kimi Work — [`/agent/setup?agent=kimi`](https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/agent/setup?agent=kimi)

On Cursor, Grok Bot and Kimi Work the agent cannot install anything itself; those guides have it
walk you through the host's Plugins screen and then verify the connection from its side.

## Branches

`staging` points at the staging deployment. There is no production deployment yet, so there is
deliberately no `main` branch and no production URL anywhere in this repository — `homepage` in
every manifest is the staging origin. Install with `…#staging` until one exists.

## Example prompts

After installing and authorizing, in a fresh conversation:

- `准备今天的外链计划`
- `把 <产品> 提交到 <目录站>`
- `检查上周提交的收录`
- `给 <站点> 起草一封换链邮件`
- `今天的计划里还剩什么`

## Skills are generated

Every `<host>/skills/` directory is generated from `cli/skills/` in the main LinkPing
repository by `scripts/sync-plugin-skills.ts`, the single source of truth. Edits made here
are overwritten on the next sync; change the skill in the main repository instead. Only the
Codex package carries `agents/openai.yaml`, Codex's own skill front matter.

Hand-maintained here: the manifests, the READMEs, the icons, the licences, and
`claude/skills/linkping-basics/login-linkping.sh`.

## Support

Open an issue at [github.com/Elyyta/linkping-plugin/issues](https://github.com/Elyyta/linkping-plugin/issues)
with the host, the package and the exact error text. Never paste tokens, OAuth URLs or workbench
data into an issue.

## License

MIT — see [LICENSE](./LICENSE). `cursor/` and `kimi/` carry their own copy, because those hosts
install a single package directory.
