# Project: claude-up

Bootstrap tool for Claude Code projects. Single bash script configures any repo with CLAUDE.md, skills, agents, settings, safety hooks.

## Architecture
- `claude-up.sh` — main script, single entry point
- `defaults/skills/` — 5 default skills (make-pr, review, commit, explore, changelog)
- `defaults/agents/` — 2 universal agents (critic, observer)
- `profiles/` — 6 domain profiles (firmware, frontend, cloud-devops, hardware-cad, docs, research)
- `global/settings.json` — machine-wide safety hooks

## Commands
- Test generic: `bash claude-up.sh /tmp/test && ls /tmp/test/.claude/`
- Test profile: `bash claude-up.sh --profile firmware /tmp/test2`
- Lint: `shellcheck claude-up.sh`

## Code Style
- Bash 4+, `set -euo pipefail`
- Variables: UPPER_CASE for globals, _prefixed for temp/internal
- Output: `echo "  OK: ..."` for success, `echo "  SKIP: ..."` for no-op

## Gotchas
- Skills/agents use merge-logic: skip if exists, `--force` overwrites
- Profile skills and default skills are additive (not exclusive)
- `.gitignore` append must handle missing trailing newline
- heredoc with `'EOF'` (quoted) to prevent variable expansion in skill/agent content

## Rules
- NEVER add external dependencies (only bash, git, jq, coreutils)
- NEVER create files outside target repo's `.claude/` and `CLAUDE.md`
- Keep CLAUDE.md templates under 50 lines (context cost)
- Skills/agents content lives in `defaults/` files, not heredocs in script
- Test idempotency: running twice must produce all SKIP

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
