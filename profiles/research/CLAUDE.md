# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Research, analysis, financial modeling.

## Architecture
- calc_*.py        — calculation/simulation scripts
- data/            — input data (xlsx, json, csv)
- output/          — results, figures, generated documents
- paper/           — LaTeX source (if applicable)

## Commands
- Run model: TODO (e.g. `python3 calc_model.py`)
- Run Monte Carlo: TODO (e.g. `python3 monte_carlo.py`)
- Build paper: TODO (e.g. `latexmk -lualatex main.tex`)
- Generate figure: TODO (e.g. `python3 scripts/fig_revenue.py`)

## Testing
- After model changes: re-run and verify key metrics haven't shifted unexpectedly
- Monte Carlo: ensure convergence (run 1000+ iterations, check P10/P50/P90 stability)
- LaTeX: check for undefined references and missing citations in build log
- All figures must regenerate cleanly from scripts

## Code Style
- Reproducible: all figures generated from scripts, not manual
- One sentence per line in .tex files (for clean git diffs)
- All data sources documented in script docstrings

## Gotchas
- TODO: e.g. pandas silently coerces date types, matplotlib backend on headless server, biber vs bibtex confusion

## Rules
- NEVER hardcode data values — read from source files in data/
- NEVER modify input data files without asking — others depend on them
- NEVER commit large binary files (xlsx > 10MB, datasets) — use .gitignore
- NEVER fabricate citation data — fetch from DOI or copy from source

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
