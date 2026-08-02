---
name: osint-investigation
description: Start-here router for any OSINT investigation. Names the workflow and knowledge skills and picks the right one for a given starting selector.
disable-model-invocation: true
---

# OSINT Investigation — Router

The front door for an open-source intelligence investigation. Use it when you
have a starting point but aren't sure which workflow to run.

## Core vocabulary

- **Selector** — one identifiable data point: a name, username, email, phone,
  domain, photo, wallet, company, IP.
- **Pivot** — turning one selector into new selectors (email → breach → reused
  password → forum handle → real name). Investigation *is* a chain of pivots.

Every workflow below takes starting selectors, pivots to new ones, and hands
findings to `osint-report`.

## Step 1 — Set authorized scope

Before anything, confirm the work is lawful and authorized. Read
[../../ETHICS.md](../../ETHICS.md). Write down: who is the subject, what is the
objective, what is in and out of bounds, and what jurisdiction applies. If you
cannot state authorization, stop.

**Done when** scope and objective are written and passive-first is the default.

## Step 2 — Route by starting selector

Invoke the matching workflow skill (type its name):

| You have… | Run |
|-----------|-----|
| A person's name / real identity | `person-osint` |
| A company or brand | `company-osint` |
| A domain, website, or IP | `domain-osint` |
| A username / handle | `username-osint` |
| An email address | `email-osint` |
| A phone number | `phone-osint` |
| A photo or video to locate/verify | `geoint-photo` |
| A social media profile | `social-media-osint` |

No clear starting selector? Start with whatever is richest (usually email or
username) and pivot outward.

## Step 3 — Pivot with knowledge skills

The workflows pull in auto-triggered knowledge skills as needed:
reverse-image-search, exif-metadata-analysis, whois-dns-recon,
certificate-transparency, wayback-archives, google-dorking, github-git-recon,
chronolocation, breach-data-analysis, crypto-blockchain-tracing,
shodan-censys-recon, paste-forum-monitoring, media-verification,
people-search-engines, corporate-registries, flight-vessel-tracking,
sockpuppet-opsec, link-analysis-graphing. Just describe what you're doing and
the relevant one loads.

## Step 4 — Report

When enough selectors corroborate the objective, run `osint-report` to compile
a sourced, timestamped intelligence product.

**Investigation done when** the objective question is answered with at least two
independent corroborating sources, or you've documented that it can't be.
