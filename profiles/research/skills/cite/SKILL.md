---
name: cite
description: Fetch BibTeX entry from a DOI and add to bibliography
argument-hint: "<DOI or URL>"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Fetch citation: $ARGUMENTS

1. Extract DOI from $ARGUMENTS (handle full URL or bare DOI)
2. Fetch BibTeX: `curl -sLH "Accept: application/x-bibtex" https://doi.org/<DOI>`
3. Clean up: ensure AuthorYear citation key, remove abstract/keywords fields
4. Find the .bib file in the project
5. Check if DOI already exists in the bib file
6. If not duplicate, append the entry
7. Print the citation key for use in \cite{}
8. NEVER fabricate citation data — only use what the DOI resolves to
