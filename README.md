# claude-up

Setup Claude Code for any repository in one command. Role-based profiles for team use.

## Install

```bash
git clone <repo-url> ~/claude-up
ln -s ~/claude-up/claude-up.sh ~/.local/bin/claude-up
```

Make sure `~/.local/bin` is in your PATH.

## Quick start: new project

```bash
cd ~/sources/my-new-project
git init
claude-up --profile firmware .
```

What happens:
1. `CLAUDE.md` appears in the project root — open it and fill in the `TODO` entries
2. `.claude/` directory is created with settings, skills, agents
3. `.gitignore` is updated to protect local files
4. Project memory is initialized at `~/.claude/projects/...`

Run `claude` — everything works immediately. Try `/flash`, `/review`, `/commit`.

## Applying to an existing project

If Claude Code is already running and there's no `CLAUDE.md` yet:

```bash
# From a separate terminal (not inside Claude Code):
claude-up --profile firmware /path/to/project

# If CLAUDE.md or settings already exist and you want to replace them:
claude-up --force --profile firmware /path/to/project
```

Without `--force`, existing files are skipped:

```
  SKIP: CLAUDE.md already exists
  SKIP: .claude/settings.json already exists
  OK: skills added: flash size-report test-native     # new skills are still added
  OK: agents added: firmware-reviewer critic observer  # new agents are still added
```

This is safe to run multiple times — skills and agents merge per-item, nothing is lost.

### Layering profiles

You can apply several profiles to the same project. Each one adds its own skills and agents:

```bash
claude-up --profile firmware .       # +3 skills, +1 reviewer
claude-up --profile research .       # +4 skills, +1 reviewer
# Result: 7 profile skills + 2 universal agents + 2 reviewers
```

## Updating active Claude sessions

After running `claude-up` on a project where Claude is already running:

### Changes that take effect immediately

- **CLAUDE.md** — Claude re-reads it on every message. Edit and save — next message uses the new rules.
- **Skills** (`.claude/skills/`) — new slash commands are available right away. Type `/` to see them.
- **Agents** (`.claude/agents/`) — available immediately for spawning.

### Changes that require session restart

- **settings.json** — permissions and hooks are loaded at session start. Exit Claude (`/exit` or Ctrl+C) and start a new session.

### Recommended migration sequence

For a project where Claude sessions are already active:

```bash
# 1. Run claude-up from a separate terminal
claude-up --profile firmware /path/to/project

# 2. Fill in CLAUDE.md (especially Commands, Gotchas, Rules)
$EDITOR /path/to/project/CLAUDE.md

# 3. In the active Claude session — restart to pick up settings.json
/exit
cd /path/to/project && claude

# 4. Verify everything loaded
/flash --help        # skill works?
# Give Claude a task — @critic and @observer should run after it completes
```

If you don't want to restart, the minimum is: edit `CLAUDE.md`, add skills/agents. Claude will see `CLAUDE.md` changes and new agents immediately. Only hooks and permissions need a restart.

### Context compaction

When a long session runs out of context, Claude compacts the conversation. The SessionStart hook (from `settings.json`) automatically injects `git log -10` and `git diff --stat` so Claude retains project history after compaction.

## What it creates

```
your-repo/
├── CLAUDE.md                        # Project description (fill in TODOs)
├── .claude/
│   ├── settings.json                # Permissions, hooks (shared via git)
│   ├── settings.local.json          # Personal settings (gitignored)
│   ├── skills/                      # Slash commands (/commit, /review, ...)
│   └── agents/                      # critic, observer + profile reviewer
└── .gitignore                       # Protects settings.local.json
```

Plus project memory at `~/.claude/projects/<encoded-path>/memory/MEMORY.md`.

## Profiles

| Profile | Domain | Skills | Reviewer |
|---------|--------|--------|----------|
| `firmware` | PlatformIO, ESP-IDF, Arduino | `/flash`, `/test-native`, `/size-report` | firmware-reviewer |
| `hardware-cad` | OpenSCAD, KiCad, build123d | `/render-stl`, `/gen-bom`, `/drc` | cad-reviewer |
| `cloud-devops` | Docker, SSH, Ansible | `/check-nodes`, `/deploy`, `/logs` | security-reviewer |
| `frontend` | Vue/React, Tailwind, web3 | `/dev`, `/lint-fix`, `/build` | frontend-reviewer |
| `docs` | weasyprint, matplotlib, PDF | `/gen-pdf`, `/gen-all`, `/preview` | numbers-verifier |
| `research` | Python, LaTeX, Monte Carlo | `/run-model`, `/build-paper`, `/cite`, `/figure` | paper-reviewer |

Without `--profile`, you get 5 universal skills: `/make-pr`, `/review`, `/commit`, `/explore`, `/changelog`.

```bash
claude-up --list    # show available profiles
```

## Agents

Every project gets three agents:

| Agent | Purpose | When it runs |
|-------|---------|--------------|
| **@critic** | Reviews changes for bugs, security, performance | After every non-trivial task (automatic via Workflow) |
| **@observer** | Checks compliance with CLAUDE.md rules | After every non-trivial task (automatic via Workflow) |
| **profile reviewer** | Deep domain review (embedded, CAD, security...) | On demand via `/review` or agent delegation |

The Workflow section in CLAUDE.md instructs Claude to spawn @critic and @observer in background after completing implementation tasks. Trivial tasks (typos, questions) are excluded.

All agents use model: sonnet, read-only tools, and report without modifying files.

## CLAUDE.md structure

Template with sections based on [Anthropic's best practices](https://docs.anthropic.com/en/docs/claude-code/memory#claudemd). Fill in `TODO` placeholders:

| Section | Purpose | Priority |
|---------|---------|----------|
| **Architecture** | Key directories and their roles | High — orients Claude without scanning |
| **Commands** | Exact build, test, lint, deploy commands | Critical — Claude cannot guess these |
| **Testing** | How to verify changes, run single tests | Critical — prevents broken commits |
| **Code Style** | Only deviations from language defaults | Medium — Claude knows standard conventions |
| **Gotchas** | Non-obvious behaviors, known pitfalls | High — impossible to infer from code |
| **Rules** | Hard constraints with alternatives | High — "NEVER X — use Y instead" |
| **Workflow** | When to run @critic and @observer | Pre-filled — no TODO needed |

Profiles add domain-specific sections (Hardware for firmware, Design Guide for docs, etc.).

Tips:
- Keep under 60-150 lines. Move deep knowledge to `.claude/rules/*.md` or skills.
- Commands and Gotchas have the highest ROI — fill these first.
- Rules work better with positive alternatives: "NEVER hardcode credentials — use config header" vs just "NEVER hardcode credentials".

## settings.json

Each profile includes:

- **Permissions**: auto-allow domain tools (`pio *`, `docker *`, `yarn *`, etc.)
- **PostToolUse hook**: auto-format on save (clang-format, prettier, or ruff depending on profile)
- **SessionStart hook**: after context compaction, injects git log and diff so Claude retains history

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
            "command": "CMD=$(jq -r '.tool_input.command') && echo \"$CMD\" | grep -qEi '(rm\\s+(-\\w*r\\w*\\s+)*-\\w*f|rm\\s+(-\\w*f\\w*\\s+)*-\\w*r|rm\\s+-\\w*rf|rm\\s+-\\w*fr|rm\\s+--recursive|rm\\s+--force|git\\s+push\\s+.*(-f|--force)\\b|git\\s+reset\\s+--hard|git\\s+clean\\s+-[fdx]|git\\s+checkout\\s+\\.$|git\\s+restore\\s+\\.$|chmod\\s+-R\\s+777|mkfs\\.|dd\\s+(if|of)=)' && echo \"Blocked: destructive command detected\" >&2 && exit 2 || exit 0"
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.tool_input.file_path // empty') && echo \"$FILE\" | grep -qEi '(\\.env$|\\.env\\.|credentials|secrets|\\.pem$|\\.key$|id_rsa($|[^.])|\\.git/)' && echo \"Blocked: $FILE is a protected file\" >&2 && exit 2 || exit 0"
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

## Creating a custom profile

```bash
mkdir -p profiles/my-profile/{skills,agents}
# Copy and edit from an existing profile:
cp profiles/firmware/CLAUDE.md profiles/my-profile/CLAUDE.md
cp profiles/firmware/settings.json profiles/my-profile/settings.json
# Add skills and agents as needed
# Use: claude-up --profile my-profile /path/to/repo
```

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

## Reference

```bash
claude-up [options] [path]

Options:
  --profile, -p <name>   Apply role profile
  --force, -f            Overwrite existing files
  --list, -l             List available profiles
  --help, -h             Show help

# Default: current directory, no profile (5 universal skills + 2 agents)
```
