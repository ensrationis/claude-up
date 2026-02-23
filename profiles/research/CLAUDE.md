# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Research, analysis, financial modeling.

## Tech Stack
- Python 3.10+ (pandas, numpy, matplotlib, openpyxl)
- Monte Carlo simulation
- LaTeX (if papers): lualatex + BibLaTeX
- PDF: reportlab or weasyprint

## Commands
- Run model: TODO (e.g. `python3 calc_model.py`)
- Run Monte Carlo: TODO (e.g. `python3 monte_carlo.py`)
- Build paper: TODO (e.g. `latexmk -lualatex main.tex`)

## Structure
- calc_*.py        — calculation/simulation scripts
- data/            — input data (xlsx, json, csv)
- output/          — results, figures, generated documents
- paper/           — LaTeX source (if applicable)

## Conventions
- Type hints in all Python code
- Reproducible: all figures generated from scripts, not manual
- One sentence per line in .tex files (for clean git diffs)
- All data sources documented in script docstrings

## Rules
- NEVER hardcode data values — read from source files
- NEVER modify input data files without asking
- NEVER commit large binary files (xlsx > 10MB, datasets)
- Verify Monte Carlo outputs are statistically stable (run 1000+ iterations)
