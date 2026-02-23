# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Document generation and technical writing.

## Tech Stack
- PDF: weasyprint (HTML → PDF)
- Charts: matplotlib
- Data: openpyxl, pandas
- Language: Python 3.10+

## Commands
- Generate all PDFs: TODO (e.g. `python3 gen_all.py`)
- Generate single: TODO (e.g. `python3 gen_pitch_deck.py`)
- Preview HTML: TODO

## Structure
- gen_*.py         — PDF generator scripts
- templates/       — HTML/CSS templates (if separated)
- data/            — source data (xlsx, json, csv)
- output/          — generated PDFs

## Style Guide
- Colors: NAVY=#003366, ACCENT=#0066CC
- Font: DejaVu Sans 9pt, DejaVu Sans Mono for numbers
- Tables: navy header, alternating #f5f7fa rows
- Footer: "Confidential" left, "Page X of Y" right
- All charts: matplotlib with consistent color palette

## Conventions
- One sentence per paragraph for easy editing
- All numbers from data source, never hardcoded in generators
- EN + RU versions: separate generator scripts per language
- Brand terminology: follow brand guide (TODO: link)

## Rules
- NEVER hardcode financial numbers in generator scripts — read from data source
- NEVER change color scheme without updating all generators consistently
- NEVER commit generated PDFs to git (add to .gitignore)
- Verify all numbers match source data after generation
