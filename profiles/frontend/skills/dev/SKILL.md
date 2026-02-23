---
name: dev
description: Install deps and start dev server in background
argument-hint: "[port]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Start development: $ARGUMENTS

1. Check if node_modules/ exists; if not, install dependencies
2. Start dev server in background (append ` &` to the command from CLAUDE.md)
3. Wait 3 seconds, then check if the process is running
4. Report the URL (usually http://localhost:5173 or as configured)
5. IMPORTANT: dev server is a long-running process — always run it in background
