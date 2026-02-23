---
name: render-stl
description: Render CAD source to STL and check for errors
argument-hint: "<source.scad>"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Render STL from source: $ARGUMENTS

1. Run syntax check: `openscad -o /dev/null <source>`
2. If clean, render: `openscad -o build/<name>.stl <source>`
3. Report file size and any warnings
4. If errors, show them and suggest fixes
