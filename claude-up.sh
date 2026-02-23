#!/usr/bin/env bash
set -euo pipefail

# claude-up — setup Claude Code for a repository
# Usage: claude-up [--profile <name>] [path]
# Profiles: firmware, hardware-cad, cloud-devops, frontend, docs, research

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
PROFILES_DIR="$SCRIPT_DIR/profiles"
PROFILE=""
FORCE=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile|-p)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                echo "Error: --profile requires a name argument"
                echo "Run: claude-up --list"
                exit 1
            fi
            PROFILE="$2"
            shift 2
            ;;
        --force|-f)
            FORCE=1
            shift
            ;;
        --list|-l)
            echo "Available profiles:"
            for d in "$PROFILES_DIR"/*/; do
                name="$(basename "$d")"
                echo "  $name"
            done
            exit 0
            ;;
        --help|-h)
            echo "Usage: claude-up [--profile <name>] [path]"
            echo ""
            echo "Options:"
            echo "  --profile, -p <name>  Apply role profile (firmware, hardware-cad, etc.)"
            echo "  --force, -f           Overwrite existing files"
            echo "  --list, -l            List available profiles"
            echo "  --help, -h            Show this help"
            echo ""
            echo "Without --profile: creates generic CLAUDE.md template"
            echo "With --profile: copies role-specific CLAUDE.md, settings, skills, agents"
            exit 0
            ;;
        *)
            REPO_DIR="$1"
            shift
            ;;
    esac
done

REPO_DIR="${REPO_DIR:-.}"

# Validate profile if specified
if [[ -n "$PROFILE" ]]; then
    PROFILE_DIR="$PROFILES_DIR/$PROFILE"
    if [[ ! -d "$PROFILE_DIR" ]]; then
        echo "Error: profile '$PROFILE' not found in $PROFILES_DIR"
        echo "Available: $(ls "$PROFILES_DIR" | tr '\n' ' ')"
        exit 1
    fi
fi

# Resolve to absolute path
REPO_DIR="$(cd "$REPO_DIR" 2>/dev/null && pwd)" || {
    echo "Error: directory not found"
    exit 1
}

PROJECT_NAME="$(basename "$REPO_DIR")"
SETTINGS_DIR="$REPO_DIR/.claude"

if [[ -n "$PROFILE" ]]; then
    echo "Setting up Claude Code for: $REPO_DIR (profile: $PROFILE)"
else
    echo "Setting up Claude Code for: $REPO_DIR"
fi

# 1. CLAUDE.md
CLAUDE_MD="$REPO_DIR/CLAUDE.md"
if [[ -f "$CLAUDE_MD" && $FORCE -eq 0 ]]; then
    echo "  SKIP: CLAUDE.md already exists"
else
    if [[ -n "$PROFILE" ]]; then
        # Copy profile CLAUDE.md, substitute project name
        sed "s/TODO_PROJECT_NAME/$PROJECT_NAME/g" "$PROFILE_DIR/CLAUDE.md" > "$CLAUDE_MD"
        echo "  OK: CLAUDE.md (from profile: $PROFILE)"
    else
        cat > "$CLAUDE_MD" << EOF
# Project: $PROJECT_NAME

TODO: одна строка — что делает проект и на чём написан.

## Architecture
TODO: ключевые директории и их назначение

## Commands
- Build: TODO
- Test single: TODO
- Test all: TODO
- Lint: TODO

## Testing
TODO: фреймворк, как запустить один тест, когда запускать

## Code Style
TODO: только то, что отличается от стандартов языка

## Gotchas
TODO: подводные камни проекта, неочевидное поведение

## Rules
TODO: что Claude НИКОГДА не должен делать (с альтернативами)
EOF
        echo "  OK: CLAUDE.md"
    fi
fi

# 2. .claude/settings.local.json (personal, gitignored)
SETTINGS_LOCAL="$SETTINGS_DIR/settings.local.json"
if [[ -f "$SETTINGS_LOCAL" && $FORCE -eq 0 ]]; then
    echo "  SKIP: .claude/settings.local.json already exists"
else
    mkdir -p "$SETTINGS_DIR"
    echo '{}' > "$SETTINGS_LOCAL"
    echo "  OK: .claude/settings.local.json"
fi

# 3. .claude/settings.json (team-shared, committable)
SETTINGS_SHARED="$SETTINGS_DIR/settings.json"
if [[ -f "$SETTINGS_SHARED" && $FORCE -eq 0 ]]; then
    echo "  SKIP: .claude/settings.json already exists"
else
    mkdir -p "$SETTINGS_DIR"
    if [[ -n "$PROFILE" && -f "$PROFILE_DIR/settings.json" ]]; then
        cp "$PROFILE_DIR/settings.json" "$SETTINGS_SHARED"
        echo "  OK: .claude/settings.json (from profile: $PROFILE)"
    else
        echo '{}' > "$SETTINGS_SHARED"
        echo "  OK: .claude/settings.json"
    fi
fi

# 4. .claude/skills/ (per-skill merging: only adds missing skills)
SKILLS_DIR="$SETTINGS_DIR/skills"
mkdir -p "$SKILLS_DIR"
_skills_added=()
_skills_skipped=()

if [[ -n "$PROFILE" && -d "$PROFILE_DIR/skills" ]]; then
    # Copy each profile skill individually
    for skill_src in "$PROFILE_DIR/skills"/*/; do
        [[ -d "$skill_src" ]] || continue
        skill_name="$(basename "$skill_src")"
        skill_dst="$SKILLS_DIR/$skill_name"
        if [[ -d "$skill_dst" && $FORCE -eq 0 ]]; then
            _skills_skipped+=("$skill_name")
        else
            cp -r "$skill_src" "$skill_dst"
            _skills_added+=("$skill_name")
        fi
    done
else
    # Default skills: make-pr, review, commit, explore, changelog
    for default_skill in make-pr review commit explore changelog; do
        if [[ -d "$SKILLS_DIR/$default_skill" && $FORCE -eq 0 ]]; then
            _skills_skipped+=("$default_skill")
            continue
        fi
        mkdir -p "$SKILLS_DIR/$default_skill"
        case "$default_skill" in
            make-pr)
                cat > "$SKILLS_DIR/make-pr/SKILL.md" << 'SKILL_EOF'
---
name: make-pr
description: Create a PR from current branch changes
disable-model-invocation: true
---
Create a PR for current changes: $ARGUMENTS

1. Check git status, ensure working tree is clean (commit if needed)
2. Push current branch to remote
3. Create PR via `gh pr create` with descriptive title and summary
SKILL_EOF
                ;;
            review)
                cat > "$SKILLS_DIR/review/SKILL.md" << 'SKILL_EOF'
---
name: review
description: Review current changes for issues
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash
context: fork
---
Review all uncommitted and staged changes in this repository.

1. Run `git diff` and `git diff --cached` to see all changes
2. Check for: bugs, security issues, style violations, missing error handling
3. Report findings with file:line references
SKILL_EOF
                ;;
            commit)
                cat > "$SKILLS_DIR/commit/SKILL.md" << 'SKILL_EOF'
---
name: commit
description: Stage and commit changes with a conventional commit message
argument-hint: "[message hint]"
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---
Commit current changes: $ARGUMENTS

1. If nothing staged, identify changed files and stage them
2. Review the diff of staged changes
3. Generate a conventional commit message: `type(scope): description`
4. Types: feat, fix, refactor, docs, test, chore, build, ci, perf
5. Body: explain WHY, not WHAT
6. If $ARGUMENTS contains a hint, incorporate it
7. Create the commit, show result
8. NEVER amend previous commits unless explicitly asked
9. NEVER commit: .env, credentials*, secrets*, *.key, *.pem
SKILL_EOF
                ;;
            explore)
                cat > "$SKILLS_DIR/explore/SKILL.md" << 'SKILL_EOF'
---
name: explore
description: Research a topic in the codebase without polluting main context
context: fork
agent: Explore
---
Research the following in this codebase: $ARGUMENTS

1. Use Glob and Grep to find all relevant files
2. Read key files to understand the implementation
3. Return a concise summary with:
   - Key files involved (paths)
   - How it works (3-5 bullet points)
   - Dependencies and side effects
   - Potential issues
4. Do NOT modify any files
SKILL_EOF
                ;;
            changelog)
                cat > "$SKILLS_DIR/changelog/SKILL.md" << 'SKILL_EOF'
---
name: changelog
description: Generate a changelog from git commits since the last tag
argument-hint: "[version]"
context: fork
agent: Explore
disable-model-invocation: true
allowed-tools: Bash, Read
---
Generate a changelog: $ARGUMENTS

## Context
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "none"`
- Commits since tag: !`git log $(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD --oneline 2>/dev/null | head -50`

## Instructions
1. Read all commits from last tag to HEAD
2. Categorize: Added, Changed, Fixed, Removed, Security
3. Rewrite into user-facing language
4. Skip merge/wip/fixup commits
5. Output in Keep a Changelog format
SKILL_EOF
                ;;
        esac
        _skills_added+=("$default_skill")
    done
fi

[[ ${#_skills_added[@]} -gt 0 ]] && echo "  OK: skills added: ${_skills_added[*]}"
[[ ${#_skills_skipped[@]} -gt 0 ]] && echo "  SKIP: skills exist: ${_skills_skipped[*]}"
[[ ${#_skills_added[@]} -eq 0 && ${#_skills_skipped[@]} -eq 0 ]] && echo "  OK: .claude/skills/"

# 5. .claude/agents/ (per-agent merging: only adds missing agents)
AGENTS_DIR="$SETTINGS_DIR/agents"
mkdir -p "$AGENTS_DIR"
_agents_added=()
_agents_skipped=()

if [[ -n "$PROFILE" && -d "$PROFILE_DIR/agents" ]]; then
    for agent_src in "$PROFILE_DIR/agents/"*.md; do
        [[ -f "$agent_src" ]] || continue
        agent_name="$(basename "$agent_src")"
        agent_dst="$AGENTS_DIR/$agent_name"
        if [[ -f "$agent_dst" && $FORCE -eq 0 ]]; then
            _agents_skipped+=("${agent_name%.md}")
        else
            cp "$agent_src" "$agent_dst"
            _agents_added+=("${agent_name%.md}")
        fi
    done
fi

[[ ${#_agents_added[@]} -gt 0 ]] && echo "  OK: agents added: ${_agents_added[*]}"
[[ ${#_agents_skipped[@]} -gt 0 ]] && echo "  SKIP: agents exist: ${_agents_skipped[*]}"
[[ ${#_agents_added[@]} -eq 0 && ${#_agents_skipped[@]} -eq 0 ]] && echo "  OK: .claude/agents/"

# 6. .gitignore (granular: protect local files, allow shared ones)
GITIGNORE="$REPO_DIR/.gitignore"
if [[ -f "$GITIGNORE" ]] && grep -qF 'settings.local.json' "$GITIGNORE"; then
    echo "  SKIP: .gitignore already configured for Claude Code"
else
    if [[ -f "$GITIGNORE" ]]; then
        # Remove old blanket .claude/ rule if present
        if grep -qxF '.claude/' "$GITIGNORE"; then
            sed -i '/^# Claude Code$/d; /^\.claude\/$/d' "$GITIGNORE"
        fi
        [[ -s "$GITIGNORE" && "$(tail -c1 "$GITIGNORE")" != "" ]] && echo >> "$GITIGNORE"
        echo "" >> "$GITIGNORE"
    fi
    cat >> "$GITIGNORE" << 'EOF'
# Claude Code (local only)
.claude/settings.local.json
.claude/hookify.*.local.md
EOF
    echo "  OK: .gitignore"
fi

# 7. Project memory
ENCODED_PATH="${REPO_DIR//\//-}"
ENCODED_PATH="${ENCODED_PATH#-}"  # strip leading dash
MEMORY_DIR="$HOME/.claude/projects/-$ENCODED_PATH/memory"
MEMORY_FILE="$MEMORY_DIR/MEMORY.md"
if [[ -f "$MEMORY_FILE" ]]; then
    echo "  SKIP: project memory already exists"
else
    mkdir -p "$MEMORY_DIR"
    echo "# $PROJECT_NAME Memory" > "$MEMORY_FILE"
    echo "  OK: project memory at $MEMORY_DIR"
fi

echo "Done."
