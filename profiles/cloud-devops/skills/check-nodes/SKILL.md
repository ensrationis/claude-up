---
name: check-nodes
description: Check status of infrastructure nodes
argument-hint: "[node-name]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Check node status: $ARGUMENTS

1. For each node defined in CLAUDE.md Network section:
   - Ping the node
   - SSH and check: `uptime`, `df -h`, `docker ps`, `free -h`
2. Report any nodes that are unreachable or have issues
3. Flag: disk > 80%, RAM > 90%, containers not running
