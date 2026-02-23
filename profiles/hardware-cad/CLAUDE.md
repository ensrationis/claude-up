# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Parametric CAD for hardware enclosures/parts.

## Tech Stack
- CAD: build123d / OpenSCAD
- PCB: KiCad 8.x (if applicable)
- Slicer: OrcaSlicer
- Printer: TODO (e.g. Bambu Lab X1 Carbon, 256x256x256mm)

## Commands
- Syntax check: `openscad -o /dev/null src/main.scad`
- Render STL: `openscad -o build/output.stl src/main.scad`
- Python CAD: `python3 src/main.py`

## Structure
- src/          — CAD source files (.scad, .py)
- src/lib/      — reusable modules
- build/        — generated STL/STEP files
- docs/         — reference drawings, datasheets

## Conventions
- All dimensions in millimeters
- Wall thickness: 2mm default (parametric)
- FDM tolerances: 0.2mm press-fit, 0.4mm sliding fit
- M3 screw hole: 3.2mm, M3 heat insert: 4.0mm
- Modules: `part_<name>()`, assemblies: `asm_<name>()`
- OpenSCAD: `$fn=60` final, `$fn=30` preview

## Rules
- NEVER use magic numbers — extract to named parameters
- NEVER modify mounting hole positions without asking
- All holes must account for printer tolerance (+0.2mm radius)
- Keep parts within printer build volume
