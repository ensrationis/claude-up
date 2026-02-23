---
name: deploy
description: Deploy service update to target node
argument-hint: "<service> [node]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Deploy: $ARGUMENTS

1. Verify target node is reachable
2. Run deployment script or `docker-compose up -d` on target
3. Wait for health check to pass (30s timeout)
4. Show service status after deploy
5. If deploy fails, show logs and suggest rollback
