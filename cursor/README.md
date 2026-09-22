# LinkPing for Cursor and Grok Bot

LinkPing is a backlink and directory-submission workbench, connected to Cursor and Grok Bot
through a hosted Model Context Protocol (MCP) server. With the plugin installed, the agent can
read today's backlink plan in the order the workbench put it in, pull the exact copy a directory
form needs, fill and submit that form in your browser, record what happened on the submission
row, draft outreach and link-exchange email, and check which listings have gone live.

The workbench stays the source of truth. The agent reports what it did; it never decides that a
listing is live, and it never sends email.

## Requirements

- A Cursor or Grok Bot account with plugin access.
- A LinkPing account with at least one product set up, so the directory copy exists.
- Network access to `https://backlink-hub-staging.zhengzhongwei888-232.workers.dev`. That origin
  is the only one the plugin contacts.
- A browser the host can drive, if you want the agent to submit forms rather than only prepare
  them. No Node installation is required: this package is manifests and Markdown.

## Install and connect

1. Open **Plugins** in Cursor or Grok Bot.
2. Find **LinkPing** and select **Add**.
3. Select **Authorize** (or **Authenticate**) and finish LinkPing sign-in in the browser.
4. If the host shows **Waiting for authorization**, select **Reopen** and finish the browser flow.
5. Confirm LinkPing appears under installed plugins, then start a fresh conversation — plugin
   tools are loaded when a conversation starts, so an older conversation will not see them.
6. Verify with a read-only request such as `列出我的产品` (`list_products`).

The plugin connects to:

```text
https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp
```

Authentication is OAuth in the browser, with dynamic client registration and PKCE; the server
derives your member from the token. No API key or access token is stored in this repository.

This package has not been submitted to Cursor's plugin marketplace, and it has not yet been
installed on a real Cursor or Grok Bot build. ChatCut's comparable package documents a submission
path at `cursor.com/marketplace/publish`; that is their process, not a step we have run.

## Example requests

- `准备今天的外链计划`
- `把 <产品> 提交到 <目录站>`
- `检查上周提交的收录`
- `给 <站点> 起草一封换链邮件`
- `今天计划里被卡住的任务，说清楚卡在哪`

## Data handling — what the agent reads and writes

- **Products.** It reads the product profile and the directory copy you saved: name, taglines,
  descriptions at several lengths, category, contact and company fields. It writes back only when
  you ask it to, for example after a directory demands a length you do not have yet.
- **Directory sites.** It reads the shared site library and the per-site fill brief. When a
  directory needs an account, it can read the sign-in details you stored in the workbench for
  that site, in order to type them into that site's own form.
- **Submissions.** One row per (product, site) is the only authority on whether you are listed
  somewhere. The agent moves that row and writes a note saying exactly where it got to.
- **Outreach.** It reads prospects, contacts and drafts, and saves drafts. Saving returns a review
  link into the workbench. The plugin has no send tool.
- **Listing checks.** It reads the backlinks and the funnel the workbench's crawler produced.
- Data goes to your LinkPing workbench and to the directory site you asked it to submit to.
  Nothing is sent to any other third party without your approval in the workbench.

## Safety and user control

- The agent fills directory forms with the copy stored for your product and presses submit
  itself. It hands the task back — with the resume URL and the field or modal that stopped it —
  on a captcha, a sign-in wall it cannot clear, a paid listing, a required file or logo upload, a
  badge the directory wants on your site first, or a required field nothing in the brief answers.
- It ticks the consent boxes a form requires in order to submit, and says which ones. It ticks
  none of the optional ones: no newsletters, no partner offers, no "feature me in your roundup".
- Email is drafted, never sent. Sending is approved by you in the workbench.
- Only the workbench's own crawler marks a listing live. The most the agent may record is
  submitted, however confident a "thanks, you're listed" page sounds.
- Remove LinkPing from the host's **Plugins** settings to stop future access, and revoke that
  machine under **已连接的机器** on the workbench's `/agent` page to invalidate the token.

## Plugin structure

```text
.cursor-plugin/plugin.json   Cursor and Grok Bot plugin manifest
mcp.json                     Hosted LinkPing MCP connection
skills/                      LinkPing workflow skills (generated; see the root README)
assets/logo.png              Plugin logo
LICENSE                      MIT License
README.md                    This file
```

`skills/` is generated from the main LinkPing repository and overwritten on every sync; change
the skill there, not here.

## Support

Open an issue at
[github.com/Elyyta/linkping-plugin/issues](https://github.com/Elyyta/linkping-plugin/issues) with
the host, the package and the exact error text. Never paste tokens, OAuth URLs or workbench data.

## License

MIT. See [LICENSE](./LICENSE).
