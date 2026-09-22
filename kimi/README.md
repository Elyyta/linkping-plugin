# LinkPing for Kimi Work

Kimi Work package: `kimi.plugin.json` is the entry point, `.mcp.json` the compatibility copy
of the connection, `skills/` the LinkPing skills. Import the directory (or a ZIP of it,
manifest at the ZIP root) through Kimi Work's plugin installation flow, then use **Login**
on the LinkPing connector card and start a fresh conversation.

There is deliberately no `.app.json`: that file carries an app id Kimi issues on
registration, and this package has not been registered with Kimi yet.

Endpoint and OAuth resource: `https://backlink-hub-staging.zhengzhongwei888-232.workers.dev/api/mcp`. Attribution header: `x-linkping-surface: kimi_work`.

`skills/` is generated from the main LinkPing repository and overwritten on every sync.
