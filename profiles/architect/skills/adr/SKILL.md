---
name: adr
description: Create or update an Architecture Decision Record
argument-hint: "<decision title or topic>"
allowed-tools: Read, Grep, Glob, Bash, Write
---
Create an ADR for: $ARGUMENTS

## Steps
1. Read existing ADRs in `docs/adr/` to determine next number and check for conflicts
2. Create `docs/adr/NNNN-<slug>.md` in MADR v3 format:

```
# NNNN. <Title>

**Date:** YYYY-MM-DD
**Status:** proposed
**Deciders:** TODO

## Context
<What forces are at play? What is the problem?>

## Decision
<What is the change we're proposing/doing?>

## Consequences
### Positive
- ...
### Negative
- ...
### Risks
- ...

## Alternatives Considered
### <Alternative 1>
- Pro: ...
- Con: ...

## Related
- Supersedes: (if applicable)
- Related to: (if applicable)
```

3. If this decision relates to or supersedes existing ADRs, update their status
4. Show the result and remind to review Consequences carefully
