---
name: product-help
description: >-
  Questions about LinkPing itself rather than the user's rows: how it works, what a status
  means, how to install, update or revoke it, what is in this build. Use for 怎么用, 怎么安装, 怎么更新, 怎么取消授权, 什么意思, 有没有, 多少钱, 有套餐吗,
  "how do I…", "what does submitted mean", "is X supported", "do I need to update", pricing
  and plans, and questions about a host other than this one. Answers are read from the
  workbench's own docs at `<origin>/docs` in this conversation, never from memory. NOT for
  live rows — a product, today's plan, a submission, a draft: use the matching read tool.
  Requires linkping-basics.
user-invocable: false
---

# Product help

Load `linkping-basics` first. This skill carries no product facts of its own, on purpose: it
is generated once and shipped inside a plugin, while the workbench it describes is deployed
continuously. It gives you the routing and the retrieval discipline; every changeable fact
comes from the workbench's own docs, read in this conversation.

So the first substantive move on a product question is to open the owning docs page — not to
answer from this file, not from a remembered version of the app, and not from a link title
you did not open.

## Route the question

| The question is about | Answer from |
| --- | --- |
| a row this workbench holds — a product, today's plan, one submission, a draft, a prospect, a backlink | the matching read tool (`list_products`, `get_today_plan`, `list_sites`, `get_draft`, `get_backlinks`, …). No docs lookup at all |
| what LinkPing is, the model, who writes which status | `/docs/overview` |
| today's plan: how it is built, what a task kind means | `/docs/plan` |
| directory forms, hand-backs, consent boxes, badge-gated sites | `/docs/submissions` |
| prospects, contacts, drafts, replies, link exchanges | `/docs/outreach` |
| "is it live yet", listing checks, `live` vs `submitted` | `/docs/verification` |
| installing, updating, revoking, another host, current versions | `/docs/install` |
| tools missing, a refusal, an error string, 401 vs 503 | `/docs/troubleshooting` |
| "is X in this build", "when did that change", "must I update" | `/docs/changelog`, plus the **Current versions** table in `/docs/install` |
| a mix of both | tools for the state, docs for what that state means and what to do next |

A mixed question is the common one: "did Product Hunt go through?" is a tool call, and
"what does `needs_assist` mean for me" is a docs page. Answer the first with the row and the
second with the page; do not let the page speak for the row or the row for the page.

Two skills sit next to this one and are not replaced by it: `known-errors` is what to *do*
about a failure inside a run, and `verification` is how a listing is proven. Use those while
working; use `/docs` when the user is asking about the product.

## Find the docs

The docs live on the workbench this conversation is connected to. This file does not name its
origin — a generated skill that hard-coded one deployment's domain would send every other
reader to somebody else's workbench. Get it, in this order:

1. The LinkPing server's own instructions in this conversation name `<origin>/docs/llms.txt`
   outright. Use that.
2. Otherwise take the origin of the registered MCP server URL, the one ending in `/api/mcp`.
   The host prints it when it lists the server; `linkping-basics` names that command for this
   host.

Then:

- Read `<origin>/docs/llms.txt` first. It is an index — one line per page, with the page's
  one-line description — and it is never itself the answer.
- Open at most two pages for one question: the owning page, then one more if the first sent
  you somewhere. If neither establishes the answer, stop and say what you could not verify.
- Cite the page you read for every consequential claim — a status transition, what a button
  does, a version requirement, what the plugin does or does not include.
- An unknown slug answers 404 with the list of valid ones. Read that list rather than
  guessing a third URL.

Reading `/docs` does not breach the no-source clause in `linkping-basics`. That clause is
about the workbench's *implementation* — `src/`, the database, the migrations — and about
calling its HTTP API instead of using a tool. `/docs` is neither: it is documentation the
workbench publishes for exactly this purpose, it is public, and it is written to survive a
deployment. `/api/**` stays off-limits; the tools are the only way to touch state.

## Establish the host

Four hosts carry this plugin: Claude Code, Codex, Cursor · Grok Bot, Kimi Work. Read which
one you are in off your own tool namespace (Claude Code namespaces the server
`plugin:linkping:linkping`) or off what the user says.

- Installing, updating, logging in, revoking and "why are the tools missing" all change with
  the host. Establish it before answering those.
- What a status means, how the plan is built, what the crawler checks — none of that changes
  with the host. Do not ask an unnecessary question.
- The user may be asking *about* a host they are not sitting in ("can my colleague use this
  in Cursor?"). Answer for the host they named, and say which one you answered for.

## Decide whether the user must update

- **The workbench is deployed server-side.** Whatever changed there is already live for them.
  Never tell someone to update anything for a web-side change.
- **A plugin update matters only when a changelog entry says so.** `/docs/changelog` gives
  each entry a minimum plugin version; the user needs to update only when the entry they care
  about names a version above the one they have. In Claude Code, `claude plugin list` prints
  the installed version; on the other hosts, ask what their plugin entry shows rather than
  assuming.
- **After any install or update, the tools load only in a new conversation.** Plugin tools are
  read once, when a conversation starts. Saying "restart the conversation" is part of the
  answer, not an afterthought.
- The skills ship inside the plugin, so this file only changes when the plugin does — which is
  exactly why it defers to the docs for facts.
- "How do I disconnect this?" has two halves on `/docs/install` — the workbench side and the
  host side — and doing one does not do the other. Read both before you answer.

## Answering rules

- **This build has no plans, credits, quotas, payments or billing.** Nothing is metered and
  there is no tier to buy. The model tokens are the user's own agent subscription — LinkPing
  never runs a model and never charges for one. Say that plainly. Do not describe a pricing
  page, a free tier or an upgrade that does not exist, and do not treat a question about
  money as evidence that one does.
- Never invent a route, a button label, a price, a date or a version number. If the docs do
  not have it, it is not established.
- Do not claim access to state no tool returned in this conversation, and do not read it out
  of the docs: the docs say what a status means, never which one a row is in.
- If the docs cannot be reached — a 404, a network failure, a page that does not cover it —
  say which page you tried and what stays unverified, offer the closest page you did read,
  and stop. A remembered answer and a verified one look identical to the user, which is why
  the remembered one is not allowed here.
- Give manual UI steps only when the user asked for them or when no tool can do the job; if a
  tool can, use the tool.
- Answering a question never loosens a delivery rule. "Can I just mark it live?" is answered
  with what `live` is, not with a way around it.
