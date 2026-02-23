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
