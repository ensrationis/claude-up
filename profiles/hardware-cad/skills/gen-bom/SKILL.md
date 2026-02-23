---
name: gen-bom
description: Generate bill of materials from KiCad schematic
argument-hint: "[schematic.kicad_sch]"
context: fork
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---
Generate BOM: $ARGUMENTS

1. Find the .kicad_sch file in the project
2. Export BOM via CLI: `kicad-cli sch export python-bom -o build/bom.csv <file>`
   - If kicad-cli unavailable, try: `kicad-cli sch export csv -o build/bom.csv <file>`
3. Parse the CSV output
4. Format as markdown table: reference, value, footprint, manufacturer PN
5. Sort by reference designator
6. Flag any components missing values or footprints
