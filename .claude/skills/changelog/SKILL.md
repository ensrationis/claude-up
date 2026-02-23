---
name: changelog
description: Generate a changelog from git commits since the last tag
argument-hint: "[version]"
context: fork
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
