---
name: username-osint
description: Enumerate a username or handle across hundreds of platforms and pivot from matched accounts to real-identity, contact, and content selectors.
disable-model-invocation: true
---

# Username OSINT

Track a handle across the internet. A reused username is one of the strongest
cross-platform links in OSINT. Input: one or more usernames.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Note the objective. **Done when noted.**

## Step 2 — Enumerate accounts

Check the handle across platforms. Tools:

```bash
sherlock <username>                 # hundreds of sites
maigret <username> --html           # richer, extracts profile data
```

Also try WhatsMyName (web) and manual checks on high-value platforms. Treat hits
as **candidates**, not confirmations — many sites false-positive.

**Done when** every candidate account is listed with its URL and live/dead
status.

## Step 3 — Generate variants

People reuse patterns. Pivot to variants and re-run Step 2: add/remove
separators (`john.doe`, `john_doe`, `johndoe`), numbers, and common suffixes;
try the local-part of any known email as a handle, and vice versa. **Done when**
plausible variants are checked.

## Step 4 — Confirm & pivot

For each candidate, confirm it's the same person via corroboration: matching
profile photo (run `reverse-image-search`), bio text, linked accounts, writing
style, join date, or a cross-link the user posted themselves. From confirmed
profiles, pivot to new selectors:

- Display name → `person-osint`
- Linked/So exposed email → `email-osint`
- Posted photos → `exif-metadata-analysis`, `geoint-photo`
- Code hosting handle → `github-git-recon`

**Done when** each account is graded confirmed/probable/rejected with its
corroborating evidence.

## Step 5 — Report

Run `osint-report`. Give a table of platform, URL, confidence, and evidence, and
call out the real-identity and contact selectors the handles revealed.
