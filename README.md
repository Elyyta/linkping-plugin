# LinkPing plugin for Claude Code

LinkPing is a backlink and directory-submission workbench. This repository is only the
packaging: a marketplace manifest, a plugin manifest pointing at LinkPing's remote MCP
server, and the skills that tell an agent how to use it. No application source, no data.

```sh
claude plugin marketplace add <this repository>
claude plugin install linkping@linkping
```

Installing does not sign you in. The server authenticates over OAuth in the browser; the
`linkping-basics` skill carries the login helper and the recovery ladder. Plugin tools are
loaded when a conversation starts, so authorize first, then open a new conversation.

## Branches

`staging` points at the staging deployment
(`https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp`). There is no
production deployment yet, so there is deliberately no `main` branch and no production URL
anywhere in this repository. Install with `…#staging` until one exists.

## Skills are generated

`claude/skills/` is generated from `cli/skills/` in the main LinkPing repository by
`scripts/sync-plugin-skills.ts`, which is the single source of truth. Edits made here are
overwritten on the next sync; change the skill in the main repository instead.

`claude/skills/linkping-basics/login-linkping.sh` is not generated and is edited here.
