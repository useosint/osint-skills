---
name: osint-report
description: Compile OSINT findings into a professional, sourced, and timestamped intelligence report that separates confirmed facts from inference.
disable-model-invocation: true
---

# OSINT Report

Turn raw findings into a defensible intelligence product. Run it at the end of
any workflow. A report is trustworthy only if every claim is sourced and
confidence is explicit.

## Step 1 — Grade every claim

For each finding, assign a confidence level and attach its source (URL,
tool+query, or file) and the date collected:

- **Confirmed** — two or more independent corroborating sources.
- **Probable** — one strong source, or weak corroboration.
- **Unverified** — a single lead, uncorroborated.

Discard claims with no source. Never present inference as fact. **Done when**
every retained claim has a confidence grade and a citation.

## Step 2 — Fill the template

```markdown
# OSINT Report — <subject>

**Analyst:** <name/handle>   **Date:** <YYYY-MM-DD>
**Objective:** <the question this answers>
**Authorization / scope:** <basis and bounds>
**Confidence key:** Confirmed · Probable · Unverified

## Executive summary
<3–5 sentences: what was asked, what was found, the bottom line.>

## Key findings
- [Confirmed] <finding> — source, date
- [Probable] <finding> — source, date

## Selectors & pivots
| Selector | Type | Confidence | Source | Date |
|----------|------|-----------|--------|------|

## Identity / entity map
<how the selectors connect — people, accounts, infrastructure.>

## Detailed findings
<by theme; every claim cited inline.>

## Gaps & limitations
<what could not be established and why.>

## Recommendations / next steps
<actionable, proportionate to the objective.>

## Appendix — sources
<full list of URLs, tools, and queries used.>
```

**Done when** each section is filled or marked N/A.

## Step 3 — Sanitize & handle

Remove data irrelevant to the objective, especially bystanders' personal
information. Store per [../../ETHICS.md](../../ETHICS.md): minimize, encrypt,
share need-to-know. **Done when** the report is scoped to the objective and
handling is set.
