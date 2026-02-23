# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Infrastructure and deployment.

## Tech Stack
- Containers: Docker / Docker Compose
- Nodes: TODO (e.g. Raspberry Pi 4B, Orange Pi, OVHcloud VPS)
- Services: TODO (Home Assistant, Mosquitto, IPFS, Prometheus)
- Network: TODO (WireGuard, libp2p, Zigbee2MQTT)

## Commands
- Deploy: TODO
- Status: `docker ps`
- Logs: `docker logs <service> --tail 100 -f`
- SSH: TODO (e.g. `ssh node-name`)

## Network
- TODO: VLAN map, IP addresses, topology

## Conventions
- All configs in YAML where possible
- Secrets in .env files (NEVER commit)
- One service per container
- Health checks on all critical services

## Rules
- NEVER expose services directly to internet without reverse proxy
- NEVER modify configs on nodes directly — use deployment scripts
- NEVER commit .env files, credentials, or private keys
- Test changes on staging node first, then propagate
