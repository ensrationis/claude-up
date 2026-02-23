---
name: gen-pdf
description: Generate PDF document from source script
argument-hint: "<document-name>"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Generate PDF: $ARGUMENTS

1. Identify the generator script (gen_*.py matching the argument)
2. Run the script: `python3 <script>`
3. Report success/failure and output file path
4. If error, show traceback and suggest fix
