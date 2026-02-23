---
name: gen-all
description: Regenerate all PDF documents
disable-model-invocation: true
allowed-tools: Bash, Read, Glob
---
Regenerate all documents.

1. Find all gen_*.py scripts in project root
2. Run each one sequentially
3. Report results: success/failure per script
4. List all generated PDF files with sizes
