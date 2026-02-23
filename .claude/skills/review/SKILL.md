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
