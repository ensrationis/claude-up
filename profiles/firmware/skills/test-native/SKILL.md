---
name: test-native
description: Run native (host) unit tests
argument-hint: "[test filter]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Run native tests: $ARGUMENTS

1. Run `pio test -e native`
2. If tests fail, analyze output and suggest fixes
3. Show test summary (passed/failed/skipped)
