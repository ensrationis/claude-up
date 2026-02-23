---
name: tech-spec
description: Draft a technical specification for a feature or change
argument-hint: "<feature or change description>"
allowed-tools: Read, Grep, Glob, Bash, Write
---
Draft a tech spec for: $ARGUMENTS

## Steps
1. Analyze the codebase to understand current architecture and patterns
2. Create a spec document with the structure below
3. Save to `docs/specs/<slug>.md`

## Spec structure

```
# Tech Spec: <Title>

**Author:** TODO  |  **Date:** YYYY-MM-DD  |  **Status:** draft

## Problem
<What problem are we solving? Why now?>

## Proposed Solution
<High-level approach, 3-5 sentences>

## Design

### Data Model Changes
<New tables/fields, schema changes, migrations>

### API Changes
<New/modified endpoints, breaking changes>

### Component Diagram
<Mermaid diagram showing affected components and data flow>

### Key Decisions
<Important design choices with brief rationale, or link to ADR>

## Impact Analysis
- **Services affected:** <list>
- **DB migrations:** yes/no, backward-compatible: yes/no
- **API breaking changes:** yes/no
- **Estimated data volume:** <if relevant>

## Rollout Plan
1. <Phase 1>
2. <Phase 2>
- **Rollback strategy:** <how to undo>

## Open Questions
- [ ] ...
```

4. Fill in what can be determined from the codebase, mark unknowns as TODO
5. List open questions that need human decision
