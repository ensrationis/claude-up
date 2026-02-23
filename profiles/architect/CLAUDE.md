# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Software architecture and technical leadership.

## Architecture
- docs/adr/         — Architecture Decision Records (MADR format)
- docs/diagrams/    — C4, sequence, ER diagrams (Mermaid)
- docs/specs/       — technical specifications
- contracts/        — API contracts (OpenAPI, AsyncAPI, protobuf)

## Commands
- Lint API: TODO (e.g. `npx @stoplight/spectral-cli lint contracts/openapi.yaml`)
- Validate proto: TODO (e.g. `buf lint && buf breaking --against .git#branch=main`)
- Dep graph: TODO (e.g. `npx madge --circular --extensions ts src/`)
- Build diagrams: TODO (e.g. `mmdc -i docs/diagrams/context.mmd -o docs/diagrams/context.svg`)

## ADR Conventions
- Format: MADR v3 (docs/adr/NNNN-title.md)
- Status lifecycle: proposed → accepted → deprecated/superseded
- Every ADR must have: Context, Decision, Consequences
- Link related ADRs (supersedes, amends, relates-to)

## API Conventions
- REST: OpenAPI 3.x, naming snake_case, errors RFC 7807
- Events: AsyncAPI 2.x, CloudEvents envelope
- gRPC: protobuf v3, buf lint rules
- Schema changes must be backward-compatible (additive only)

## Code Style
- Diagrams: Mermaid (renders in GitHub/GitLab natively)
- Specs: Markdown with Mermaid blocks, no external binary files
- All numbers and metrics must reference source (link or command)

## Gotchas
- TODO: e.g. OpenAPI circular $ref breaks codegen, Mermaid classDiagram doesn't support generics well

## Rules
- NEVER approve breaking API changes without migration plan in ADR
- NEVER create diagrams as images — use Mermaid source (text, diffable)
- NEVER add a new dependency without documenting the decision (ADR or inline rationale)
- NEVER skip Consequences section in ADR — it's the most valuable part

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
