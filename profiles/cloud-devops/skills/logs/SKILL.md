---
name: logs
description: Fetch and analyze logs from a Docker service
argument-hint: "<service> [--tail N]"
disable-model-invocation: true
context: fork
allowed-tools: Bash, Read, Grep
---
Analyze logs: $ARGUMENTS

1. Determine the target service from $ARGUMENTS
2. Fetch recent logs: `docker logs $ARGUMENTS --tail 500 --timestamps 2>&1`
3. If remote node, use SSH: `ssh <node> docker logs <service> --tail 500`
4. Analyze for:
   - ERROR/WARN/FATAL patterns with timestamps
   - Repeated error patterns (group and count)
   - Connection failures (database, MQTT, network)
   - Resource exhaustion (OOM, disk full)
5. Summary: health status, top 3 issues, recommended actions
