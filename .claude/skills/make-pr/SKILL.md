---
name: make-pr
description: Create a PR from current branch changes
disable-model-invocation: true
---
Create a PR for current changes: $ARGUMENTS

1. Check git status, ensure working tree is clean (commit if needed)
2. Push current branch to remote
3. Create PR via `gh pr create` with descriptive title and summary
