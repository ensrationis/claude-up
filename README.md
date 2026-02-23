# claude-up

Setup Claude Code for any repository in one command. Role-based profiles for team use.

## Install

```bash
git clone <repo-url> ~/claude-up
ln -s ~/claude-up/claude-up.sh ~/.local/bin/claude-up
```

Make sure `~/.local/bin` is in your PATH.

## Usage

```bash
# Generic setup (5 default skills)
claude-up /path/to/repo

# With a role profile
claude-up --profile firmware /path/to/repo

# Current directory
claude-up .
claude-up --profile research .

# List profiles
claude-up --list

# Overwrite existing files
claude-up --force --profile frontend .
```

## What it creates

```
your-repo/
├── CLAUDE.md                        # Project description (fill in the TODOs)
├── .claude/
│   ├── settings.json                # Permissions, hooks (shared via git)
│   ├── settings.local.json          # Personal settings (gitignored)
│   ├── skills/                      # Slash commands (/commit, /review, ...)
│   └── agents/                      # Subagents (critic, observer, reviewer)
└── .gitignore                       # Protects settings.local.json
```

Plus project memory at `~/.claude/projects/<encoded-path>/memory/MEMORY.md`.

## Profiles

| Profile | Domain | Skills | Agent |
|---------|--------|--------|-------|
| `firmware` | PlatformIO, ESP-IDF, Arduino | `/flash`, `/test-native`, `/size-report` | firmware-reviewer |
| `hardware-cad` | OpenSCAD, KiCad, build123d | `/render-stl`, `/gen-bom`, `/drc` | cad-reviewer |
| `cloud-devops` | Docker, SSH, Ansible | `/check-nodes`, `/deploy`, `/logs` | security-reviewer |
| `frontend` | Vue/React, Tailwind, web3 | `/dev`, `/lint-fix`, `/build` | frontend-reviewer |
| `docs` | weasyprint, matplotlib, PDF | `/gen-pdf`, `/gen-all`, `/preview` | numbers-verifier |
| `research` | Python, LaTeX, Monte Carlo | `/run-model`, `/build-paper`, `/cite`, `/figure` | paper-reviewer |

Without `--profile`, you get 5 universal skills: `/make-pr`, `/review`, `/commit`, `/explore`, `/changelog`.

Every project also gets two universal agents: **@critic** (code quality review) and **@observer** (CLAUDE.md compliance check).

## Profiles can be layered

Skills and agents merge per-item. Existing ones are not overwritten (unless `--force`).

```bash
claude-up .                          # 5 default skills
claude-up --profile firmware .       # +3 firmware skills, +1 agent
claude-up --profile research .       # +4 research skills, +1 agent
# Result: 12 skills + 2 agents, nothing lost
```

## What each profile includes

### CLAUDE.md

Template with sections based on [Anthropic's best practices](https://code.claude.com/docs/en/best-practices). All contain `TODO` placeholders to fill in:

| Section | Purpose | Why it matters |
|---------|---------|----------------|
| **Architecture** | Key directories and their roles | Orients Claude without scanning the whole repo |
| **Commands** | Exact build, test, lint, deploy commands | Highest-impact section — Claude cannot guess these |
| **Testing** | How to verify changes, run single tests | "Single highest-leverage thing" per Anthropic docs |
| **Code Style** | Only deviations from language defaults | Claude already knows standard conventions |
| **Gotchas** | Non-obvious behaviors, known pitfalls | Impossible to infer from code, saves most time |
| **Rules** | Hard constraints with positive alternatives | "NEVER X — use Y instead" format for better adherence |
| **Workflow** | When to run @critic and @observer agents | Automated quality gate after every implementation task |

Profiles add domain-specific sections where needed (Hardware for firmware, Design Guide for docs, etc.).

### settings.json

- **Permissions**: auto-allow domain tools (`pio *`, `docker *`, `yarn *`, etc.)
- **PostToolUse hook**: auto-format on save (clang-format, prettier, or ruff depending on profile)
- **SessionStart hook**: after context compaction, injects `git log -10` and `git diff --stat` so Claude retains history

### Skills

Slash commands invoked via `/skill-name` in Claude Code. Each skill has `argument-hint` for autocomplete and `disable-model-invocation: true` (manual-only).

### Agents

Two types:

- **Universal** (all projects): `@critic` (reviews changes for bugs/security), `@observer` (checks CLAUDE.md compliance)
- **Profile-specific**: domain reviewer (firmware-reviewer, cad-reviewer, etc.) with maxTurns: 30

All agents use model: sonnet and read-only tools. The Workflow section in CLAUDE.md instructs Claude to run @critic and @observer after every non-trivial task.

## After setup

1. Open `CLAUDE.md` and replace all `TODO` entries — especially **Commands** and **Gotchas**
2. Keep it under 60-150 lines. Move specialized knowledge to `.claude/rules/*.md` or skills
3. Run `claude` in the repo — skills and agents are active immediately
4. Try `/review` to review changes, `/commit` to commit with a conventional message

## Global safety

Recommended addition to `~/.claude/settings.json` (protects all projects):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command') && echo \"$CMD\" | grep -qEi '(rm\\s+(-[^\\s]*)?[rf].*-[rf]|git\\s+push\\s+.*--force|git\\s+reset\\s+--hard|git\\s+clean\\s+-[fdx]|git\\s+checkout\\s+\\.$|git\\s+restore\\s+\\.$|chmod\\s+-R\\s+777|mkfs\\.|dd\\s+if=)' && echo \"Blocked: destructive command detected\" >&2 && exit 2 || exit 0"
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.tool_input.file_path // empty') && echo \"$FILE\" | grep -qEi '(\\.env$|\\.env\\.|credentials|secrets|\\.pem$|\\.key$|id_rsa|id_ed25519|\\.git/)' && echo \"Blocked: $FILE is a protected file\" >&2 && exit 2 || exit 0"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [{"type": "command", "command": "notify-send 'Claude Code' 'Permission needed' --urgency=critical"}]
      },
      {
        "matcher": "idle_prompt",
        "hooks": [{"type": "command", "command": "notify-send 'Claude Code' 'Waiting for input'"}]
      }
    ]
  }
}
```

This blocks destructive commands (`rm -rf`, `git push --force`, `git reset --hard`), prevents editing secrets (`.env`, `.pem`, `.key`), and sends desktop notifications when Claude needs input.

## File structure

```
claude-up/
├── claude-up.sh          # Main script
├── PRACTICES.md          # Best practices reference (ru)
└── profiles/
    ├── firmware/
    │   ├── CLAUDE.md
    │   ├── settings.json
    │   ├── agents/firmware-reviewer.md
    │   └── skills/{flash,test-native,size-report}/SKILL.md
    ├── hardware-cad/
    ├── cloud-devops/
    ├── frontend/
    ├── docs/
    └── research/
```

## Creating a custom profile

```bash
mkdir -p profiles/my-profile/{skills,agents}
# Copy and edit from an existing profile:
cp profiles/firmware/CLAUDE.md profiles/my-profile/CLAUDE.md
cp profiles/firmware/settings.json profiles/my-profile/settings.json
# Add skills and agents as needed
# Use: claude-up --profile my-profile /path/to/repo
```
