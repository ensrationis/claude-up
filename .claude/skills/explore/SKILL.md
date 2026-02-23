---
name: explore
description: Research a topic in the codebase without polluting main context
context: fork
allowed-tools: Read, Grep, Glob
---
Research the following in this codebase: $ARGUMENTS

1. Use Glob and Grep to find all relevant files
2. Read key files to understand the implementation
3. Return a concise summary with:
   - Key files involved (paths)
   - How it works (3-5 bullet points)
   - Dependencies and side effects
   - Potential issues
4. Do NOT modify any files
