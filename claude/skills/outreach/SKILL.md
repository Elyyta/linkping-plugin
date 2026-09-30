---
name: outreach
description: >-
  Email outreach and link exchanges in LinkPing: the keywords discovery searches from,
  finding prospects, picking an address, drafting, blocking a domain, and stopping before
  anything is sent. Use for 外联, outreach, 发邮件, cold email, email a site, 换链,
  link exchange, 互换链接, guest post, 投稿, prospects, 线索, contacts, 找邮箱, find an email,
  关键词, keywords, 竞品, competitors, 屏蔽域名, block a domain, reply to them, 回复, inbox,
  模板, templates, follow up. The hard rule it carries: guessed addresses are never selected automatically
  and you never send. Requires linkping-basics.
---

# Outreach

Load `linkping-basics` first: its execution contract binds this work too and is not
restated here.

Two rules here are absolute, and both exist because a wrong email cannot be recalled:

1. **You do not send.** Drafts are written and saved. Sending is the human's.
2. **A guessed address is never chosen for you, and never by you by default.**

## The loop

```
list_prospects → check_mention → find_contact → (a published address? select_contact)
  → get_draft_brief → you write it → save_draft → stop
```

### 0. Keywords and competitors — where the pipeline starts

Discovery searches the product's keywords and reads its competitors' round-ups. With no
keywords there is nothing to search, and `get_discovery_brief` refuses with
`400 no_keywords`.

- `list_keywords` shows the terms and when each was last searched; the stalest are the ones
  the next run picks up. `add_keyword(texts=[…])` adds more — terms the product already has
  are ignored rather than duplicated — and `delete_keyword` removes one, leaving the
  prospects it already found alone.
- `list_competitors` / `add_competitor(url)` / `delete_competitor` do the same for the
  products this one competes with. Their comparisons and "best X" round-ups are where a
  page worth pitching most often already exists.
- Propose terms from the product's own positioning and the user's words, and show them the
  list before you add twenty of them. A keyword nobody would type is a search spent for
  nothing.
- `get_outreach_settings` is the frame the rest runs in: the search country and language,
  the DR range and page types discovery filters on, the follow-up delay, and which
  automations are on. Read it before you explain why a page was or was not picked up. The
  daily send cap is deliberately not there — it belongs to the connected mailbox, which MCP
  does not expose at all.

### 1. Find who is worth writing to

`list_prospects` filters the table by pipeline status, page type, DR range, whether an
address is known, and text. `get_prospect` for one, with its contacts and current draft.

New prospects come from either:
- `get_discovery_brief` → **you search the web yourself** → `save_discovery`. This brief is
  the one that needs a tool of your own. If you cannot search, say so and stop: answering
  from memory produces URLs that do not exist, and nobody downstream can tell those from
  real finds. Copy every `url` and `title` out of the results character for character.
  Send `keywordIds` for **every** keyword you searched including the empty-handed ones, or
  they come back to you again tomorrow.
- `add_prospect` for a page the user names.
- `prospect_from_site(siteId)` for a library site there is no form to fill on:
  `list_sites(method='email')` and `list_sites(method='link_exchange')` pull those rows out
  of the directory half, and this is the bridge that turns one into a prospect with the
  site's own published address already on it. It answers with the prospect either way — 201
  when it created one, 200 when that site already had one, which is not a failure and not a
  reason to make a second. From there the loop above is the same as for any other prospect.

### 2. `check_mention` before you spend a draft

It fetches the page and records whether it already links to the product, only mentions it,
or neither. **A page that already links needs no pitch at all.** A page that will not load
is a verdict (`error`), not something to retry.

### 3. Contacts — the part that goes wrong quietly

`find_contact(prospectId)` reads the prospect's own site: the page, the homepage, the
contact/about/advertise pages, obfuscated and Cloudflare-protected addresses, schema.org
markup, the feed, the domain's DMARC record, and an archived copy when the live page shows
nothing. It selects the best **published** address and checks the domain for mail.

`list_contacts` shows all of them with `source`. Read `source` before you do anything:

- **`guessed`** — built from a person's name and the site's address pattern. **Nobody has
  ever seen it published.** It is never selected automatically and never verified
  automatically, by design. Do not "fix" that by calling `select_contact` on it. If the
  prospect has no published address, say so and let the human decide; selecting a guess is
  their call, made knowingly.
- `deliverable` means the domain accepts mail and the address is not a known role trap. It
  does **not** mean a person read it.

`select_contact` makes one address the one outreach goes to, and deselects the previous one.

### 4. Write the email

`get_draft_brief(prospectId)` hands back the template rendered with everything we hold, the
page being pitched and what it is about, plus `schema` — the shape your answer must take —
and `discipline`. **No model runs on the LinkPing side; the wording is yours, on your
tokens.** The claims are not: every fact about the product must come from the brief.

A draft that is already queued is refused. `unqueue_outreach` first, or the sender may pick
up the old version mid-edit.

`save_draft(prospectId, draft)` stores it. The same guard the workbench always used checks
it: an empty or over-long subject or body, a leftover `{{token}}`, or a body far shorter
than the rendered template is refused with 422 — read the refusal and fix it. Small edits
to an existing draft go through `update_draft` instead of a rewrite.

**`save_draft` sends nothing and queues nothing. There is no `send` argument on it and
there will not be one.** This is where you stop by default.

`list_templates` is where a `templateId` comes from: this product's templates with their ids
and their subjects, the default one first. Without one the brief renders the default, which
is right most of the time — name a template when the person asked for that kind of mail
("the guest-post one"), not because you preferred its wording.

Research you did while writing an email is not a knowledge entry. `add_knowledge` is the
article writer's store (`directory-submission` › "When the site wants an article, not a
form"); an email's homework does not go in it.

### 5. Queuing and sending

- `queue_outreach` returns a review link for saved drafts. It queues and sends nothing.
- Open that link for the user to review and approve delivery in the workbench.
- `send_reply` is unavailable through MCP. Do not substitute another sending route.

Report the actual outcome: “3 drafts saved — review them on the outreach board.”

### 6. Replies

**`sync_replies` before you answer "有人回复吗".** The workbench pulls the connected mailbox
once a day, so `list_inbox` on its own answers from whenever that last ran. `sync_replies`
fetches what has arrived since, attaches each reply to its prospect and categorises it; it
reads the member's own mailbox and sends nothing. `409 no_inbox` means no mailbox is
connected under Preferences — the person's to fix, and say so rather than retrying. Say what
the sweep found ("2 new replies since this morning") before you list anything.

`list_inbox` for who wrote back and how their reply was categorised (interested, question,
link exchange, wants payment, declined, opted out). `get_thread` for the actual text —
reading it here does **not** mark it read, because that stays a signal that a *human*
opened it. Draft the answer with `get_draft_brief(kind='reply')` and `save_draft`, and stop.

**An "opted out" reply ends in `block_domain`**, not merely in a status. That is the one
thing that actually stops us reaching that person again: it adds the domain to this
product's blocklist so discovery never surfaces it, and it settles the prospects already on
that domain in one pass — the ones nobody ever wrote to are **deleted**, the ones we had
already emailed are kept and marked `lost` so the sent mail and the replies still count
toward the rates, and a `won` row is left exactly as it is, link and all. The deletions
cannot be undone, which is the point — say plainly in your report that you did it.

`list_blocked_domains` shows every blocked domain with its reason and the row id
`unblock_domain` needs. Read that reason before unblocking anything: the deleted prospects
do not come back, and **a domain blocked because someone asked not to be contacted stays
blocked**. Unblocking it puts that person back within reach of outreach, which is not a
tidy-up an agent gets to decide on.

### 7. What you may write on a prospect

`set_prospect_status` records an outcome a human knows about: `sent`, `replied`, `won`,
`lost`, `skipped`. The pipeline owns the rest — `new`, `ready` and `queued` say where the
machinery has got to, and the route refuses them with `422 status_not_settable`.

Never move a prospect out of `won`: that row carries a link already earned, and demoting it
both hides a real backlink and can trigger a "no reply yet" follow-up to the person who
gave it.

`delete_prospect` removes the row with its contacts and its whole message history, for
good. When the point is only to get something out of the way, that is
`set_prospect_status(status='skipped')`, which keeps the history.

### 8. An `outreach` task on today's plan

`get_plan_brief` answers for submit tasks alone and refuses this one with 400. The loop is:

```
claim_plan_task → get_draft_brief(prospectId = task.refId) → you write it
  → save_draft → queue_outreach for the review link → report_plan_task done
```

The task's `refId` **is** the prospect id. Check the contact first — no selected address is
worth saying out loud before you draft — and `report_plan_task failed` with a note when you
could not write one, rather than leaving the row looking claimed.

### 9. Link exchanges, and the `community` task

A `community` task's `refId` is a candidate exchange site: another member's site that might
swap links with one of ours.

```
claim_plan_task → list_community_sites → get_match_brief(siteId = one of your own
  verified sites) → save_match → tell the person which candidates to reveal
  → report_plan_task done
```

- `list_community_sites` is the member's own exchange sites. **Only a verified one is a
  valid `get_match_brief.siteId`** — an unverified row has had no ownership check, so no
  candidate list was ever built for it. None verified is an answer: say so and stop.
- `get_match_brief(siteId)` ranks exchange partners for that site. Ownership, DR floors and
  price were already applied before you saw the list — **do not re-weigh DR or price.** The
  only thing asked of you is whether two audiences actually overlap, with a one-or-two
  sentence reason each, in the language the brief names. Score only the candidate ids the
  brief listed; `save_match` drops the rest, because those are the only ones whose
  ownership was ever checked.
- `get_match_results(siteId)` reads the last run back: the relevance and the reason that were
  saved for each candidate, and which of them are still listed. That is the answer to "what
  did we decide about X" and to picking a task back up — re-briefing and re-scoring writes a
  new run over a judgement that was already made.
- **Revealing a candidate's contact is the person's own click in the workbench**, and there
  is no tool for it here. So the end of this task is telling them which candidates are worth
  revealing and why, in their words. Nobody is contacted by any of it, and the task only
  counts as done once they have looked.

## Reporting

`get_funnel` is the honest summary: prospects → contacted → replied → won, reply and win
rates, and what needs attention. Report drafts as drafts and queued as queued. An email
is not outreach until a human approved it leaving.
