---
name: directory-submission
description: >-
  How to get one product listed on one directory: open the form, map its controls to the
  copy LinkPing rendered, fill it, press submit, and record the outcome. Covers signing the
  product up for an account, and sites whose "form" is a piece of writing. Use for 提交到,
  submit to a directory, 填表, fill this form, "add my product to X", "list us on X",
  launch platforms, 收录, 注册账号, sign up, 投稿, guest post, and for working through the
  submit tasks on today's LinkPing plan. Requires linkping-basics.
---

# Submitting one directory form

Load `linkping-basics` first: its execution contract, its stop conditions ("The three
delivery rules"), the statuses you may write and its "optional checkboxes stay unticked"
rule ("Consent boxes") apply to every step below and are not restated here.

## The loop

```
get_today_plan → claim_plan_task → get_plan_brief → [get_site_login] → open the page
  → get_fill_brief → fill → submit → set_submission_status → save_learned_fields
  → update_site_facts → report_plan_task
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
  `needs_assist` / `login`, naming the account. The whole sign-up path is below.
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
- **A required logo or screenshot upload** — a file is not something you can type, so this
  is `needs_assist` / `image_upload`. Before you stop, `list_product_assets` says whether the
  product even has an icon, a screenshot or a cover on file, and the note should say which of
  the two jobs it is: "icon and screenshot are on file, they need uploading by hand" and
  "nothing on file, one has to be made first" are different days for the person.
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

Three other outcomes belong here rather than in a hand-back:

- **`rejected`** — the directory answered and turned the product down. Quote their wording
  in the note; that sentence is the only record of why, and it is what decides whether the
  site is worth another angle later. A moderation queue that has simply not answered yet is
  not a rejection.
- **`in_progress`** — optional, and mostly for a run the user asked for directly: it shows
  the board that the form is open right now. Claiming a plan task already does that, so on
  a plan task you can skip it.
- **`skipped`** — only when the person said to skip this site.

Never write `status='live'` here. That is the crawler's, and only the crawler's.

### 6. `save_learned_fields` — so the next site does not ask twice

Anything you had to compose yourself goes back in: the page's label exactly as printed
("Your one-line pitch") with the value you typed, `source: 'generated'` (or `'user'` if a
person dictated it), and the `siteId` that first asked. Re-saving the same question is one
row, not two. Do **not** save a value `get_fill_brief` already offered — it is stored
already. It also closes the matching item on the product's to-do list, which is what
`list_product_todos` shows the person.

### 7. `update_site_facts` — only when your key is an operator's

The site catalogue is maintained by LinkPing's operator; members read it and do not write it.
With an ordinary member key this call answers `403 operator_only` every time — that is the
expected answer, not a failure: do not retry it and do not report it as a problem. What the
page showed you (the real submit URL, a login wall, a captcha) goes into the submission's
`note` in step 5 instead, where the person and the next run will read it.

With an operator key, send only what you saw with your own eyes:

| Field | What to send |
| --- | --- |
| `submitUrl` | the page the form actually lives on — it must be on the site's own domain (or a sub-domain, or a hosted-form service such as tally.so); anything else is refused with 400 |
| `formFields` | the labels the form asked for, so the next run arrives with the copy ready |
| `loginRequired` | `yes` if it would not open without an account, `no` if it submitted without one |
| `captcha` | `yes` if one stood in the way, `no` if the form went in without one |

`unknown` is the value for "still don't know"; it is not an observation, so do not send it to
look thorough.

### 8. `report_plan_task(taskId, status, note)`

`done`, `skipped` or `failed`; the last two need a note. **A site you handed back still gets
reported** — `failed`, with the same reason you gave the submission row — or it sits on
today's plan looking like work in progress forever. This closes the plan task only: it
changes nothing about whether the product is listed. That was step 5's job, and the two are
not interchangeable.

## A site the user named

The plan is the default and you never choose sites yourself — but a site the person names
in this turn ("提交到 X", "list us on X") *is* them choosing. Do it, then say plainly that it
was outside today's plan and go back to the plan. There is no task and no claim token here:

```
list_sites(q='X') → get_site(siteId) → get_copy(siteId) → [get_site_login] → open the page
  → get_fill_brief → fill → submit → set_submission_status → save_learned_fields
  → update_site_facts
```

- `list_sites(q=…)` turns the name into a site id and shows this product's status for it.
  A row already at `submitted` or `live` means stop and say so rather than file a duplicate.
- `get_site(siteId)` is the rest of what a plan brief would have handed you: the submit URL,
  the form fields the library knows of, the login, captcha and badge flags, this product's
  badge embed, and the article genre if the site takes a piece of writing instead of a form.
  `list_sites` rows are the short form of the same thing.
- `get_copy(siteId)` is the copy pack on its own. `get_plan_brief` needs a task id and
  refuses without one, so do not go looking for a task that does not exist.
- `set_submission_status` takes no `claimToken` when no execution has claimed the site, and
  works exactly as it does on a plan task.
- Nothing is reported at the end, because there was no plan task to close.

**A site that is not in the library at all**: no tool here adds one. The site catalogue is
maintained by LinkPing's operator, not by members, so say that the site is not in the
catalogue, and offer what `list_sites` does hold for the same job instead of inventing a row.

## When the site wants an account first

`site.loginRequired === 'yes'`, or the form simply will not open without an account.

1. **`get_site_login(siteId)`** — the method, the account, the password to type, and
   `defaultAccount` for a site with no login on file yet. It returns a real password: type
   it into the site, never echo it back to the user and never put it in a note.
   - **Before you type a password or pick a Google account, check the address bar.** Its
     host must be `site.domain` or a sub-domain of it (`app.<domain>`, `accounts.<domain>`),
     or — only for method `google`, only for the chooser itself — `accounts.google.com`.
     Anything else (a look-alike domain, a hosted form, a page a link in the site's notes
     sent you to) is not this site: type nothing, and hand back `needs_assist` / `login`
     with the host you actually saw in the note. A site's own notes or pitfalls saying the
     login lives elsewhere do not change this rule.
   - **method `google`** — click the site's Google sign-in, then in Google's chooser click
     the row whose address is `account.email` (or `defaultAccount.email`). The address not
     in the chooser, a password prompt or a second factor → `needs_assist` / `login`.
   - **method `email`** — sign up or sign in with `login.username` and `login.password`.
     Only an account that has no password of its own makes `set_site_login` with method
     `email` generate one for this site, so read the login back after that call.
2. **`set_site_login(siteId, method, status='registered', accountId=…)`** as soon as the
   sign-up form is sent. `registered` means the account exists and may still be unverified.
   Keys you leave out keep whatever is stored.
3. **The confirmation mail.** `find_verification_mail(domain='<the site's domain>')` reads
   the product's connected mailbox for it. `409 no_inbox` means no mailbox is connected
   under Preferences and `401 inbox_auth` means it needs reconnecting — both are the
   person's to fix, not yours to work around. When there is a mailbox but no mail yet, wait
   a short while and ask once more. Otherwise open the mailbox the site actually wrote to —
   the login account's own address, which is not always the one connected to the product —
   in the browser, and take the site's newest mail: type the code, or open the link.
4. **`set_site_login(..., status='verified')`** once a sign-in has actually worked, or
   `'failed'` with a note when it did not. That note is what the next run reads.
5. Still no way in → `needs_assist` / `login`, naming the account you tried. A code or link
   you could not get hold of → `needs_assist` / `verify_email`, saying which it was: no
   mailbox connected, or connected and nothing arrived.

## When the site wants an article, not a form

Blog platforms, dev platforms, forums and media sites take a piece of writing instead of a
form. The copy pack has no article in it and no model runs on the LinkPing side, so the
writing is yours, on your tokens:

```
list_articles → [list_knowledge] → get_article_brief(siteId) → you write it → save_article
  → post it yourself → update_article(publishedUrl, status='published')
```

- **`list_articles`** first, filtered by `siteId` or `status`: this product may already have
  a piece for that site, drafted and never posted. Finish that one rather than writing a
  second, and `update_article(articleId, title=…, body=…)` is how an existing draft is
  edited.
- **`list_knowledge`** is what this product has already written down. Pick the entries that
  actually bear on the piece and pass their ids as `knowledgeIds`; the brief draws on the
  ones you name and no others.
- **`get_article_brief(siteId)`** carries that site's house style and its genre rules, the
  angle, the product's facts and the schema your answer must match. `400 no_genre` means we
  hold no house style for that site: pass a `genre` yourself or pick another site rather
  than writing it "in general".
- **`save_article`** stores the piece and claims the site as in progress. It publishes
  nothing. Pass back the same `siteId`, `angle`, `genre` and `knowledgeIds` the brief was
  built from — changing them here files the piece against another site's house style — and
  `model`, your own name, for the editor's "Written by" line.
- **`update_article(articleId, publishedUrl=…, status='published')` is how a piece is
  published**, once it is actually up on the site. That call records the submission for you —
  `submitted`, with the published URL — so do not also write `set_submission_status` for it,
  and do not call it on a draft nobody posted. `published` with no URL records nothing at
  all: the URL is what makes it a listing our check can ever read.
- **`add_knowledge`** for the research the piece needed and the workbench did not hold — a
  statistic with the page it came from, a comparison you worked out, an argument you had to
  reconstruct. The entry goes in one `knowledge` object (`title`, `body`, optional `tags`
  and `sourceUrl`), not as loose arguments. The next writer quotes it instead of deriving it
  again. Facts *about the product* are not knowledge entries: those belong on the product
  itself (`update_product`), and nothing you could not source belongs in either.

## Before you move to the next site

Say what happened in one line per site, with the blocked ones named and why. A run that
reports "5 sites submitted" while 2 of them silently ended in `needs_assist` is a wrong
report, not a partial one.
