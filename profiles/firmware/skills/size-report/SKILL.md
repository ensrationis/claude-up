---
name: size-report
description: Analyze firmware binary size and compare with previous builds
argument-hint: "[environment]"
context: fork
disable-model-invocation: true
allowed-tools: Bash, Read, Grep
---
Analyze firmware size: $ARGUMENTS

1. Run `pio run` and capture the build output
2. Extract flash and RAM usage from the "Memory Usage" section
3. If `.size-history.csv` exists, compare with last entry:
   - Show delta for each section (text, data, bss, total)
   - Flag if any section grew by more than 5%
4. Append current measurement to `.size-history.csv`
5. If flash > 85% or RAM > 75%, print WARNING
6. List the 10 largest symbols: `pio run -t sizedata 2>/dev/null || nm -S --size-sort .pio/build/*/firmware.elf | tail -10`
