# LinkPing for Cursor and Grok Bot

Plugin package for hosts that read `.cursor-plugin/plugin.json`: the manifest, the hosted
MCP connection in `mcp.json`, and the LinkPing skills.

1. Open **Plugins** in Cursor or Grok Bot, find **LinkPing** and select **Add**.
2. Select **Authorize** (or **Authenticate**) and finish LinkPing sign-in in the browser.
   If the host shows **Waiting for authorization**, select **Reopen** and finish the flow.
3. Start a fresh conversation.

The plugin connects to `https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp` over OAuth. No API key or token is stored here. Remove
LinkPing from the host's Plugins settings to stop future access.

`skills/` is generated from the main LinkPing repository and overwritten on every sync.
