#!/bin/sh
# `claude mcp login` wants a terminal, so run it under a pty in the background and let the
# caller read the log. Success is the line `Authenticated with`, not `Connected`.
log="${1:-${TMPDIR:-/tmp}/linkping-login.log}"
python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' claude mcp login plugin:linkping:linkping > "$log" 2>&1 &
echo "$log"
