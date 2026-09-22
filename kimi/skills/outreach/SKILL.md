---
name: outreach
description: >-
  Email outreach and link exchanges in LinkPing: finding prospects, picking an address,
  drafting, and stopping before anything is sent. Use for 外联, outreach, 发邮件, cold email,
  email a site, 换链, link exchange, 互换链接, guest post, 投稿, prospects, 线索, contacts,
  找邮箱, find an email, reply to them, 回复, inbox, follow up. The hard rule it carries:
  guessed addresses are never selected automatically and you never send. Requires
  linkping-basics.
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

### 5. Queuing and sending

- `queue_outreach` returns a review link for saved drafts. It queues and sends nothing.
- Open that link for the user to review and approve delivery in the workbench.
- `send_reply` is unavailable through MCP. Do not substitute another sending route.

Report the actual outcome: “3 drafts saved — review them on the outreach board.”

### 6. Replies

`list_inbox` for who wrote back and how their reply was categorised (interested, question,
link exchange, wants payment, declined, opted out). `get_thread` for the actual text —
reading it here does **not** mark it read, because that stays a signal that a *human*
opened it. Draft the answer with `get_draft_brief(kind='reply')` and `save_draft`, and stop.

Never move a prospect out of `won`: that row carries a link already earned, and demoting it
both hides a real backlink and can trigger a "no reply yet" follow-up to the person who
gave it.

### 7. Link exchanges

`get_match_brief(siteId)` ranks exchange partners for one of your own **verified** community
sites. Ownership, DR floors and price were already applied before you saw the list — **do
not re-weigh DR or price.** The only thing asked of you is whether two audiences actually
overlap, with a one-or-two-sentence reason each, in the language the brief names. Score only
the candidate ids the brief listed; `save_match` drops the rest, because those are the only
ones whose ownership was ever checked. Nobody is contacted by this.

## Reporting

`get_funnel` is the honest summary: prospects → contacted → replied → won, reply and win
rates, and what needs attention. Report drafts as drafts and queued as queued. An email
is not outreach until a human approved it leaving.
