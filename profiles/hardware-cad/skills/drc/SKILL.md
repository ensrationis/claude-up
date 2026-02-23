---
name: drc
description: Run KiCad Design Rule Check on PCB
argument-hint: "[file.kicad_pcb]"
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---
Run DRC check: $ARGUMENTS

1. Find the .kicad_pcb file in the project
2. Run: `kicad-cli pcb drc --output build/drc-report.json --format json <pcb-file>`
3. Parse the JSON report
4. Summarize violations by severity:
   - **Errors**: clearance violations, unconnected nets, short circuits
   - **Warnings**: silkscreen overlap, courtyard violations
5. For each violation: type, location, affected nets/components
6. If no violations: confirm clean DRC pass
