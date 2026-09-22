---
name: directory-submission
description: >-
  How to get one product listed on one directory: open the form, map its controls to the
  copy LinkPing rendered, fill it, press submit, and record the outcome. Use for 提交到,
  submit to a directory, 填表, fill this form, "add my product to X", "list us on X",
  launch platforms, 收录, and for working through the submit tasks on today's LinkPing plan.
  Requires linkping-basics.
---

## Execution contract

Inference uses this user's agent session. Never ask the hosted workbench to run a model.
First check actual browser access (open and inspect a page) and search access. Report the
result with `check_agent`, including host, interactive/scheduled mode, and an actionable
message if blocked. Renew the check-in while working. Authorization alone is not readiness.

When running today's plan, use `prepare_today_plan` if it does not exist. Claim each task
with `claim_plan_task`, retain its `claimToken`, and renew it every few minutes using
`checkpoint_plan_task`. A conflict or expired claim means stop that task. Before an external
submission, checkpoint `phase: submitting` with the destination URL. Include the claim token
in `set_submission_status` and `report_plan_task`. Never retry a submission whose outcome is
uncertain: the human must check the destination and release it from the workbench first.
Only the listing checker can promote a backlink to `live`.

Email delivery is approved in the workbench. Save drafts, then use `queue_outreach` only to
get a review link. It sends and queues nothing. `send_reply` is not available through MCP.



# Submitting one directory form

Load `linkping-basics` first. The seven stop conditions and the "optional checkboxes stay
unticked" rule in §4–5 there apply to every step below.

## The loop

```
get_today_plan → claim_plan_task → get_plan_brief → [get_site_login] → open the page
  → get_fill_brief → fill → submit → set_submission_status → save_learned_fields
  → report_plan_task
```

### 1. `get_plan_brief(taskId)` — before you open anything

One answer carries the whole job: the site row, the copy pack our templates rendered for
*this* site, the product's contact and company fields, what earlier forms already taught
this product, and `pitfalls` — plain sentences about this specific site, ordered in the
order you will meet them. Read the pitfalls first; they are the reason this site failed
last time.

Two things it deliberately does not carry:

- **the login**, because it holds a password. `site.loginRequired === 'yes'` → call
  `get_site_login(siteId)`, which tells you the method, the account and how to handle the
  verification mail. If your browser tool refuses to type passwords, stop:
  `needs_assist` / `login`, naming the account.
- **any freshly written copy.** No model runs on the LinkPing side. Text the templates
  cannot produce is yours to write, on your tokens — and only from facts you were given.

If `site.submitUrl` is null, find the "submit", "add your product" or "suggest a site" link
from the homepage yourself. If neither URL is on file, hand back rather than searching the
web for one.

### 2. Open the page and read it before typing

Directories bury the free path. Before you fill anything:

- **Re-select the $0 plan.** Paid tiers come pre-selected (a $9 "priority", a $29
  "premium"), and the final button silently changes to *Continue to checkout*. Re-read the
  button's label right before you press it.
- **Look for the free escape hatch inside upsell modals** — "Still Submit for Free" and
  friends. If there is no free path at all: `needs_assist` / `paid`. Never enter payment
  details.
- **Check for an existing draft or listing.** Many sites keep one ("resume your draft", a
  pre-filled form, "already in our review queue"). Finish that one. A duplicate is how a
  directory decides you are spam, and "domain already exists" wastes the run.

### 3. `get_fill_brief` — for the controls you cannot place yourself

Send the site id, the page URL and the controls you read off the page (id, tag, type,
label, placeholder, name, context, required, maxLength, select options), plus `resolved`
for the ones you already matched so the same value is not offered twice.

It hands back every value the product actually has: rendered copy, contact and company
fields, and what other forms taught it. **Deciding which candidate goes in which control is
yours.** Two rules the answer repeats and that matter more than anything else here:

- **Only ever take a value from `candidates`. Never invent one.**
- **When nothing fits, leave the control alone and ask.** Not "something close".

A required field with no candidate and no answer from the human is a stop:
`needs_assist` / `manual`, naming the field label in the note.

### 4. Typing into controls that fight back

These are the shapes that have actually cost runs here:

- **A form inside a cross-origin iframe, or a fully custom input** — typed text never
  arrives. Do not retry it four times; `needs_assist` / `manual` immediately.
- **A native `<select>` in a React form** — setting the value does not update React state,
  and Submit just scrolls back to the select. Redo it as click → type-ahead → Enter.
- **A custom React dropdown** — ignores both value-setting and ref clicks. Take a
  **full-resolution** screenshot and click the option's real coordinates; arithmetic on a
  scaled screenshot lands one row off.
- **A markdown editor** — auto-continues `- ` lists. Type plain paragraphs, no list markers.
- **Drive the browser with real clicks and typing**, not synthetic click events.

### 5. Submit, then record — in that order, and record honestly

Press submit yourself. Then read the confirmation page and write down what it said.

```
set_submission_status(siteId, status='submitted', listingUrl=…, note=…)
```

`submitted` is **refused with 400 `listing_url_required`** unless you pass the listing URL
*or* a note saying why the site gave none ("queued for review, no URL shown"). That is not
red tape: a submission with no listing URL is one our crawler can never check, so it can
never become `live`. Give the URL whenever the confirmation page shows one.

Also record `angleKey` if the brief pitched a specific angle, and put the *evidence* in the
note — the confirmation wording, which required consent box you ticked, the moderation
queue's stated turnaround.

Never write `status='live'` here. That is the crawler's, and only the crawler's.

### 6. `save_learned_fields` — so the next site does not ask twice

Anything you had to compose yourself goes back in: the page's label exactly as printed
("Your one-line pitch") with the value you typed, `source: 'generated'` (or `'user'` if a
person dictated it), and the `siteId` that first asked. Re-saving the same question is one
row, not two. Do **not** save a value `get_fill_brief` already offered — it is stored
already.

### 7. `report_plan_task(taskId, status, note)`

`done`, `skipped` or `failed`; the last two need a note. **A site you handed back still gets
reported** — `failed`, with the same reason you gave the submission row — or it sits on
today's plan looking like work in progress forever. This closes the plan task only: it
changes nothing about whether the product is listed. That was step 5's job, and the two are
not interchangeable.

## Before you move to the next site

Say what happened in one line per site, with the blocked ones named and why. A run that
reports "5 sites submitted" while 2 of them silently ended in `needs_assist` is a wrong
report, not a partial one.
