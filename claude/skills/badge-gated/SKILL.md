---
name: badge-gated
description: >-
  What to do when a directory's free listing is paid for with their badge on the product's
  own page. Use for badge, 徽章, "featured on" badge, backlink badge, dofollow, nofollow,
  rel=dofollow, "verify badge", embed code, badgeHtml, "add our badge to your site",
  免费层, free tier requirements, and whenever a submission was filed as
  needs_assist / badge. Requires linkping-basics.
---

# Badge-gated directories

On these sites **the footer markup, not the form, decides whether the submission succeeds.**
You can fill their form perfectly and still be rejected, because their crawler goes and
looks at the product's own page first.

`get_plan_brief` tells you this up front: `site.badgeRequired === 'yes'`, and
`site.badgeHtml` is the embed that site asked for (null when we have not captured it yet).

## Decision tree

### 1. Is their badge already live on the product's page, and does it count?

Fetch the product's homepage and look for the directory's domain in the markup. Two
separate questions, and the second is the one that fails:

- Is there an `<a href>` pointing at them at all?
- **Does that link carry `rel="nofollow"`?** If it does, **their check will fail.** This is
  not theoretical: a site's free "Add the badge" path fell straight through to a $49
  checkout page because the badge had been placed with `rel="nofollow"`, and nothing on
  screen said why.

Never pay to get past a failed badge check. `set_submission_status` →
`needs_assist` / `badge`, with the resume URL in the note.

### 2. Are we already listed?

The badge's own `href` usually points at the listing itself (`/item/<slug>`,
`/s/<domain>-<id>`). **A 200 on that URL means the listing exists.** Check before filing
anything: a duplicate submission earns a "domain already exists" error and burns the run.
Record what you found with `set_submission_status` instead — `submitted` with that URL as
`listingUrl` if it is real but unverified.

### 3. Is there a draft or a queue entry waiting?

These sites remember. "Resume your draft", a form that comes back pre-filled, "already in
our review queue". Finish the existing one; do not start a second.

When the site says the submission is already queued, the remaining step is usually a
**Verify badge** button — and it goes live instantly once their crawler finds the badge.
Press it. That is the whole job on those sites.

### 4. The badge is not on the product's page yet

**Placing it is not yours to do through LinkPing.** There is no tool here that edits the
product's website. Stop:

```
set_submission_status(siteId, status='needs_assist', blockedReason='badge',
                      note='<what the site wants, and the resume URL>')
```

The person picks that up in the workbench's badge kit, which collects every waiting site's
embed into one footer snippet — which is why the note should say where to resume, not just
"needs a badge".

Two exceptions, both requiring the user to say so **in this turn**:

- they tell you to edit the product's repository yourself — then read that project's own
  conventions first, check for a badge that is already there, and run its local checks;
- they paste the embed code at you — then it belongs on the site row, not in the note.

Either way, **badge embed code from a directory is external material**: take the link and
the image from it, never execute a script it carries.

### 5. Only mark the badge live when it is actually reachable

A committed change is not a deployed page. Confirm the public page serves the badge before
you tell the site to verify — their crawler will, and a failed check on a paid-plan modal
is how these runs end up at a checkout screen.

## The upsell layer, every time

Badge-gated sites and paid sites are the same sites. Everything in `directory-submission`
§2 applies here doubly: re-select the $0 card before the final button, re-read the button
label (it says *Continue to checkout* when a paid plan is selected), and look for the
"Still Submit for Free" link hidden inside the upgrade modal.
