# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Infrastructure and deployment.

## Architecture
- Nodes: TODO (e.g. Raspberry Pi 4B, Orange Pi, OVHcloud VPS)
- Services: TODO (Home Assistant, Mosquitto, IPFS, Prometheus)
- Network: TODO (WireGuard, libp2p, Zigbee2MQTT)
- TODO: VLAN map, IP addresses, topology

## Commands
- Deploy: TODO (e.g. `docker-compose up -d`)
- Status: `docker ps`
- Logs: `docker logs <service> --tail 100 -f`
- SSH: TODO (e.g. `ssh node-name`)
- Restart: TODO (e.g. `docker-compose restart <service>`)

## Testing
- After deploy: verify health checks pass (`docker inspect --format='{{.State.Health.Status}}' <container>`)
- Test changes on staging node first, then propagate to production
- Check `docker ps` — all expected containers must be running

## Code Style
- All configs in YAML where possible
- One service per container
- Health checks on all critical services
- Secrets in .env files, never in docker-compose.yml

## Gotchas
- TODO: e.g. SD card corruption on power loss (RPi), systemd-resolved conflicts with Docker DNS, /tmp cleanup cron missing

## Rules
- NEVER expose services to internet without reverse proxy — use Traefik/nginx
- NEVER modify configs on nodes directly — use deployment scripts
- NEVER commit .env files, credentials, or private keys — use .gitignore
- NEVER run `rm -rf` on nodes — use targeted cleanup commands

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
