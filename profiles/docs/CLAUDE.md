# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Document generation and technical writing.

## Architecture
- gen_*.py         — PDF generator scripts
- templates/       — HTML/CSS templates (if separated)
- data/            — source data (xlsx, json, csv)
- output/          — generated PDFs

## Commands
- Generate all: TODO (e.g. `python3 gen_all.py`)
- Generate single: TODO (e.g. `python3 gen_pitch_deck.py`)
- Preview HTML: TODO

## Testing
- After every generator change: run the script, open output PDF, verify layout
- Verify all numbers match source data — use `/gen-all` then spot-check
- Check page count hasn't changed unexpectedly

## Design Guide
- Colors: NAVY=#003366, ACCENT=#0066CC
- Font: DejaVu Sans 9pt, DejaVu Sans Mono for numbers
- Tables: navy header, alternating #f5f7fa rows
- Footer: "Confidential" left, "Page X of Y" right
- All charts: matplotlib with consistent color palette

## Code Style
- One sentence per paragraph for easy editing
- EN + RU versions: separate generator scripts per language
- Brand terminology: follow brand guide (TODO: link)

## Gotchas
- TODO: e.g. DejaVu font missing on some systems, weasyprint page breaks shift with content changes, matplotlib figure DPI affects PDF layout

## Rules
- NEVER hardcode financial numbers in generators — read from data source files
- NEVER change color scheme without updating all generators consistently
- NEVER commit generated PDFs to git — add output/ to .gitignore
- After generation, verify numbers match source — discrepancies are critical bugs

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
