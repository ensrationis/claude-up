---
name: preview
description: Generate HTML preview of a document (skip PDF rendering)
argument-hint: "<document-name>"
disable-model-invocation: true
allowed-tools: Bash, Read, Glob
---
Preview document: $ARGUMENTS

1. Find the generator script matching $ARGUMENTS
2. If weasyprint-based: generate HTML but skip PDF rendering
3. Save to output/preview.html
4. Open: `xdg-open output/preview.html 2>/dev/null || echo "Preview: output/preview.html"`
5. If no preview mode: run the full generator
