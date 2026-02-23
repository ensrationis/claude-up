---
name: run-model
description: Run calculation model and show key results
argument-hint: "[script.py] [--monte-carlo]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Run model: $ARGUMENTS

1. Run the main calculation script (calc_model.py or as specified)
2. Show key output metrics (revenue, costs, margins, breakeven)
3. If Monte Carlo available, run it and show P10/P50/P90 ranges
4. Flag any warnings or anomalies in results
