---
name: person-osint
description: Workflow to build a sourced profile of a named individual from public sources, pivoting across identity, contact, social, and location selectors.
disable-model-invocation: true
---

# Person OSINT

Profile a real individual from public, lawful sources. Input: a full name plus
any anchor selector (city, employer, email, photo, handle).

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Confirm this is not stalking,
harassment, or doxxing. Note the legitimate objective (due diligence, fraud,
missing person, hiring, self-audit). **Done when** written and lawful.

## Step 2 — Disambiguate

A name is a weak selector — many people share one. Anchor to something unique
before pivoting: employer, city, school, birth year, a photo, a known handle.
**Done when** you can tell your subject apart from namesakes, or you've flagged
that you can't yet.

## Step 3 — Enumerate selectors

Collect, don't conclude. Pull public data into a selector list:

- **Search & dorks** — name in quotes with each anchor; run `google-dorking`.
- **People search engines** — see `people-search-engines` (pipl-style
  aggregators, voter/court records where lawful).
- **Social** — find profiles across platforms; feed handles to `username-osint`.
- **Email / phone** — if found, branch to `email-osint` / `phone-osint`.
- **Photos** — run `reverse-image-search` and `exif-metadata-analysis` on any
  images; `geoint-photo` if location matters.
- **Professional** — LinkedIn, company bios, conference talks, patents, papers,
  registries via `corporate-registries`.
- **Historical** — `wayback-archives` for deleted bios and old profiles.

**Done when** every lead is captured as a selector with its source URL and date.

## Step 4 — Pivot and corroborate

For each new selector, loop back to Step 3. Confirm identity only where **two or
more independent sources** agree (e.g., same photo on a profile *and* a bio
naming the same employer). Track confidence per claim: confirmed / probable /
unverified. Reused usernames and profile photos are the strongest cross-platform
links.

**Done when** pivots stop yielding new corroborated selectors.

## Step 5 — Report

Run `osint-report`. Separate **confirmed facts** from **inferences**, cite every
claim, and drop anything that only serves to harm.
