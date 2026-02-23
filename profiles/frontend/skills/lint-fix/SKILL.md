---
name: lint-fix
description: Run linter and auto-fix issues
disable-model-invocation: true
allowed-tools: Bash, Read
---
Lint and fix: $ARGUMENTS

1. Run lint command from CLAUDE.md Commands section
2. If auto-fixable issues found, apply fixes
3. Run type check if available
4. Report remaining issues that need manual fix
