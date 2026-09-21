---
name: known-errors
description: >-
  Diagnosing LinkPing failures — refused tool calls, blocked directory pages, forms that
  will not accept input, and pages that never load. Use for 报错, error, 打不开, 被拦, blocked,
  Cloudflare, captcha, 验证码, 登录墙, sign-in wall, 403, 429, 500, "the tool failed",
  "it won't let me submit", "not_implemented_yet", "listing_url_required", "the form did
  nothing". Says what to retry, what to hand back, and in which words. Requires
  linkping-basics.
---

# Known errors

Two questions, in order: **is this retryable, or is it a stop?** and **what exactly do I
write down?** Never a third one — do not open the workbench's source to find out why a
route answered the way it did.

## Directory pages that stop you

| What you see | Do | Record |
| --- | --- | --- |
| "Performing security verification" (Cloudflare) that does not clear in ~10s | do not solve it, do not retry | `needs_assist` / `captcha` |
| An arithmetic challenge ("2+3=?") or any captcha | do not solve it | `needs_assist` / `captcha` |
| A sign-in wall, and `get_site_login` has no usable account, or Google asks for a password or a second factor, or the address is not in the chooser | stop | `needs_assist` / `login`, naming the account |
| A required logo or screenshot upload | stop | `needs_assist` / `image_upload` |
| Payment is the only path | never enter card details | `needs_assist` / `paid` |
| Their badge must be on the product's page first | see `badge-gated` | `needs_assist` / `badge` |
| A required field nothing can answer; or no single unambiguous submit button | stop | `needs_assist` / `manual` |
| The form rejects what it was given and the message is not actionable | stop | `blocked` / `form_error` |
| The form went in and the site never answered | park it | `blocked` / `no_response` |

`needs_assist` = a human can clear it in one step. `blocked` = parked, nobody acting.
Both are refused without a `blockedReason`.

**Every one of these needs a `note` that lets a person resume without re-deriving the
problem**: the resume URL, the exact field label, the modal's wording, which account was
tried. "Blocked by captcha" alone costs the human the whole investigation again.

## Forms that accept nothing

These look like bugs in your browser tool and are not. Do not burn four retries on them.

- **Cross-origin iframe forms, and fully custom inputs** — typed text never arrives at all.
  `needs_assist` / `manual`, first time.
- **A native `<select>` inside a React form** — the value is set, React never hears about
  it, and Submit just scrolls back to the select. Redo as click → type-ahead → Enter.
- **A custom React dropdown** — ignores value-setting *and* ref clicks. Full-resolution
  screenshot, click the option's real coordinates. Coordinates computed from a scaled
  screenshot land one row off.
- **A markdown editor** — auto-continues `- ` list markers into your text. Type plain
  paragraphs.
- Drive the page with real clicks and real typing. Synthetic click events are how these
  failures started.

## Tool errors from LinkPing itself

| Error | What it means | Do |
| --- | --- | --- |
| tools missing / not connected | the connection was never finished — almost never a broken install | tell the user to run `npx linkping init` (or `linkping status`), and stop |
| `not_implemented_yet` | that route is not in this build of the workbench | say which tool, do not work around it |
| `501 discovery_unavailable` | needs the local Claude Code login; only works on a workbench running on the user's own machine | say so; the deployed app cannot do it |
| `400 listing_url_required` | `submitted` without a listing URL or a note | supply the URL, or a note saying why there is none |
| `400` on `report_plan_task` for a verify task | that task is the crawler's; a report would overwrite the only evidence | re-check the listing instead |
| `400 no_angles` on a brief | the product has no angles to pitch | the human fixes that; name it |
| `400 no_keywords` on `get_discovery_brief` | nothing to search | `add_keyword` first |
| `400 no_genre` on `get_article_brief` | no house style for that site | pass a genre or pick another site |
| `409` on `save_product_profile` | that product already exists | patch it, never create a second |
| `422` on `save_draft` | empty or over-long subject or body, a leftover `{{token}}`, or a body far shorter than the rendered email | read the refusal, fix it, save again |
| a draft already queued, refused by `get_draft_brief` | the sender may pick up the old one mid-edit | `unqueue_outreach` first |
| `404` on a task id | it is gone or belongs to another product | re-read `get_today_plan` |

**5xx and network timeouts are worth one retry**, then report. A refusal with a code
(`4xx`) is an answer — it will say the same thing the second time.

## Two silences that are worse than an error

- **A skipped site that is never recorded.** If anything stopped you, a row must say so
  before you move on. A run that reports only its successes is a wrong report.
- **A field filled with "something close".** Nothing fits is a legitimate answer; leave the
  control alone and say which one. A plausible invented value gets published on someone
  else's site and the human has to go and retract it.
