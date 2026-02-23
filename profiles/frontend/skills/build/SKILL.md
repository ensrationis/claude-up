---
name: build
description: Run production build and report bundle sizes
argument-hint: "[--analyze]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Build for production: $ARGUMENTS

1. Run the build command from CLAUDE.md Commands section
2. If success:
   - List output files in dist/ or build/ with sizes
   - Show total bundle size
   - Flag any asset > 500KB as WARNING
   - Flag total JS > 1MB as WARNING
3. If failure:
   - Show the error output
   - Identify the failing module
   - Suggest fix
