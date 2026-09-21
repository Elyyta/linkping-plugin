---
name: verification
description: >-
  How a LinkPing listing or backlink is proven to exist, and which half of that is yours.
  Use for 验证, verify, 检查外链, "is it live yet", "did the link land", "活了吗", 收录了吗,
  check the listing, check backlinks, live vs submitted, listing status, "confirm they
  published it". Requires linkping-basics.
---

# Verification

**Your verification is not the user's proof.** One rule sits under everything here:

> `live` is written by our own crawler and by nothing else. You write at most `submitted`.

A confirmation page saying "you're listed!" is a *claim*. A link on a page is a *fact*. Only
the second one counts, and only our fetch establishes it.

## What actually promotes a listing

A daily check fetches each submission's `listingUrl` and asks one question: does the page
carry an `href` to the product's own host (its website or any of its angle landing URLs)?

- **linked** — a real `href`. A row sitting at `submitted` is promoted to `live`.
- **mentioned** — the domain appears as text, or inside a redirect URL, but nothing links
  to it. This is what a "pending review" page looks like. **Not live.**
- **missing** — neither. A listing rendered entirely in JavaScript also looks like this to a
  plain fetch, so `missing` is not proof of removal.

It never demotes. A `live` row whose link has since gone shows `missing` in its check
columns and a human decides what that means.

## The one thing you control: the listing URL

**A submission with no `listingUrl` is never fetched, so it can never become `live`.** That
is the single most common way a real listing stays invisible in the workbench.

So when you record a submission:

- pass `listingUrl` whenever the confirmation page, the badge's href, the site's search or
  the confirmation email gives you one;
- when there genuinely is none, say so in `note` — `set_submission_status` refuses
  `submitted` with 400 `listing_url_required` otherwise, on purpose;
- if you later find the URL (the moderation queue cleared, the email arrived), call
  `set_submission_status` again with it. That is the fix, not writing `live`.

## You cannot run the crawler from here

There is no LinkPing tool that triggers a listing check. Do not look for one, do not call
the app's HTTP routes to force one, and do not tell the user you have "verified" anything.
The honest sentence is: *"submitted and recorded with the listing URL; our check runs daily
and will flip it to live once the link is there."*

`get_backlinks` is the read side — every link the product has actually landed, from both
the directory half and the outreach half, with anchor text where known. A link that is not
in there has not been proven.

## The one check you can run: outreach pages

For a **prospect** (an outreach target, not a directory), `check_mention(prospectId)` fetches
their page and records whether it already links to the product, only mentions it in text, or
neither. Run it before spending a draft — a page that already links needs no pitch. A page
that will not load is a verdict (`error`), not a failure to retry.

## Verify tasks on the plan

A `verify` task on today's plan belongs to the crawler. `report_plan_task` refuses it with
400, because our own fetch already wrote down what it found and your report would overwrite
the only evidence there is. If a verify result looks wrong, go and look at the listing
again — then correct the `listingUrl` or the status with `set_submission_status`.

## Reporting

Say which state each site is in, using the workbench's words, not softer ones:

- **submitted** — the form went in. Not listed yet.
- **live** — our check found the link. Only the crawler puts a row here.
- **needs_assist / blocked** — name the reason and what would clear it.

Never summarise a run as "N backlinks built" when what you did was submit N forms.
