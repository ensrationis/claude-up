---
name: diagram
description: Generate architecture diagram from codebase analysis
argument-hint: "<type: c4-context|c4-container|sequence|er|dependency> [scope]"
context: fork
allowed-tools: Read, Grep, Glob, Bash
---
Generate a diagram: $ARGUMENTS

## Supported types

**c4-context** — System context: system + external actors/systems
**c4-container** — Containers: apps, DBs, queues, APIs inside the system
**sequence** — Sequence diagram for a specific flow (auth, order, etc.)
**er** — Entity-Relationship from DB schemas/ORM models
**dependency** — Module/package dependency graph

## Steps
1. Determine diagram type from $ARGUMENTS (default: c4-container)
2. Analyze codebase:
   - For C4: scan docker-compose, k8s manifests, terraform, main configs, entry points
   - For sequence: trace the specified flow through handlers → services → repos → external calls
   - For ER: find migration files, ORM models, SQL schemas
   - For dependency: analyze import graph from source files
3. Generate Mermaid diagram source
4. Output as a fenced Mermaid block in Markdown
5. Note any assumptions made and things that need verification

## Rules
- Output ONLY Mermaid syntax — no PlantUML, no images
- Label all arrows (what data flows, what protocol)
- Keep diagrams readable: max 15 nodes for C4, max 20 steps for sequence
- If the scope is too large, suggest splitting into sub-diagrams
