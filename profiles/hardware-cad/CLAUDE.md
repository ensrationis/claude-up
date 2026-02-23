# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Parametric CAD for hardware enclosures/parts.

## Hardware
- CAD: build123d / OpenSCAD
- PCB: KiCad 8.x (if applicable)
- Slicer: OrcaSlicer
- Printer: TODO (e.g. Bambu Lab X1 Carbon, 256x256x256mm)

## Architecture
- src/          — CAD source files (.scad, .py)
- src/lib/      — reusable modules
- build/        — generated STL/STEP files
- docs/         — reference drawings, datasheets

## Commands
- Syntax check: `openscad -o /dev/null src/main.scad`
- Render STL: `openscad -o build/output.stl src/main.scad`
- Python CAD: `python3 src/main.py`
- DRC (if KiCad): `kicad-cli pcb drc --output build/drc.json <file>.kicad_pcb`

## Testing
- Verify STL renders without warnings after every .scad change
- Check bounding box fits printer build volume
- For KiCad: run DRC before committing PCB changes

## Code Style
- All dimensions in millimeters
- Wall thickness: 2mm default (parametric)
- FDM tolerances: 0.2mm press-fit, 0.4mm sliding fit
- M3 screw hole: 3.2mm, M3 heat insert: 4.0mm
- Modules: `part_<name>()`, assemblies: `asm_<name>()`
- OpenSCAD: `$fn=60` final, `$fn=30` preview

## Gotchas
- TODO: project-specific pitfalls (e.g. specific part interference, print orientation issues)

## Rules
- NEVER use magic numbers — extract to named parameters at top of file
- NEVER modify mounting hole positions without asking — other parts depend on them
- All holes must account for printer tolerance (+0.2mm radius)
- Keep parts within printer build volume (check CLAUDE.md Hardware section)
