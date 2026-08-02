---
name: google-dorking
description: Craft advanced search-engine queries to surface hidden or specific content. Use when building Google dorks, using search operators (site, filetype, intext, inurl), finding exposed files or documents, or narrowing searches for a name, email, or leak.
---

# Google Dorking

Search operators turn a search engine into a precision instrument for finding
specific files, exposed data, and buried mentions. Works on Google; Bing and
DuckDuckGo support similar operators (and dodge some rate limits).

## Core operators

| Operator | Finds |
|----------|-------|
| `"exact phrase"` | Exact string (names, emails, error text) |
| `site:example.com` | Only that domain/subdomain |
| `filetype:pdf` (or `ext:`) | A specific file type |
| `intext:"term"` | Term in page body |
| `intitle:` / `inurl:` | Term in title / URL |
| `-term` | Exclude |
| `OR` / `( )` | Alternatives / grouping |
| `*` | Wildcard word |
| `before:2020 after:2015` | Date range |

## Recipes

```text
# Exposed documents on a site
site:example.com filetype:pdf OR filetype:xlsx OR filetype:docx

# A person across the web, excluding a namesake's employer
"Jane Doe" "Springfield" -site:linkedin.com -"OtherCorp"

# An email or username anywhere it was posted
"jane.doe@example.com" OR "janedoe1990"

# Open directories and config leaks
intitle:"index of" "parent directory" site:example.com
site:example.com intext:"password" filetype:env
```

## Practice

- Chain operators from broad to narrow; remove one at a time when you get zero
  results.
- Repeat high-value dorks on **Bing, DuckDuckGo, Yandex** — indexes differ.
- For known dork libraries, see the Google Hacking Database (GHDB).
- Respect that finding exposed data doesn't authorize accessing it — see
  [../../ETHICS.md](../../ETHICS.md).
