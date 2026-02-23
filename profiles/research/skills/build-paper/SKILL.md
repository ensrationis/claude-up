---
name: build-paper
description: Build LaTeX paper to PDF
argument-hint: "[main.tex]"
context: fork
disable-model-invocation: true
allowed-tools: Bash, Read
---
Build paper: $ARGUMENTS

1. Generate figures: run all scripts in scripts/ or figures/
2. Build: `latexmk -lualatex -interaction=nonstopmode main.tex`
3. If errors, parse log and fix LaTeX issues
4. Report: page count, warnings, undefined references
