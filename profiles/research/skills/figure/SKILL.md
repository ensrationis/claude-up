---
name: figure
description: Generate or regenerate a specific matplotlib figure
argument-hint: "<figure-name or 'all'>"
disable-model-invocation: true
allowed-tools: Bash, Read, Glob
---
Generate figure: $ARGUMENTS

1. Find the figure script:
   - If $ARGUMENTS is a filename, use it directly
   - Otherwise search: `scripts/fig_*.py`, `figures/fig_*.py`, `scripts/plot_*.py`
2. Run: `python3 <script>`
3. Verify output file exists (PNG/PDF/SVG in output/ or figures/)
4. Report file size
5. If "all": find and run all figure scripts in order
