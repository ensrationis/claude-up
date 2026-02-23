---
name: gen-bom
description: Generate bill of materials from KiCad schematic
argument-hint: "[schematic.kicad_sch]"
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---
Generate BOM: $ARGUMENTS

1. Find .kicad_sch file in project
2. Parse schematic for component references (R, C, U, J, etc.)
3. Extract: reference, value, footprint, manufacturer part number
4. Output as markdown table sorted by reference designator
5. Flag any components missing values or footprints
