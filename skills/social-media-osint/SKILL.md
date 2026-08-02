---
name: social-media-osint
description: Deep-dive a social media profile — map the account, its network and content, extract location and pattern-of-life signals, and pivot to other identities.
disable-model-invocation: true
---

# Social Media OSINT

Extract intelligence from a subject's social presence across platforms. Input: a
profile URL or handle. Observe public content only; do not befriend, message, or
deceive to gain access without authorization.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). If you'll interact rather than only
observe, use `sockpuppet-opsec` and confirm it's authorized. **Done when noted.**

## Step 2 — Profile the account

Capture the stable selectors: display name, handle (→ `username-osint` to find
the same handle elsewhere), bio, profile and banner photos (→
`reverse-image-search`), join date, linked sites, and pinned posts. **Done when**
the account's core selectors are recorded.

## Step 3 — Network

Map connections that reveal identity: frequent interactions, tagged accounts,
family/employer mentions, and mutual follows. A subject's network often exposes
what their own profile hides. **Done when** key relationships are listed.

## Step 4 — Content mining

Work the posts for signal:

- **Location** — geotags, backgrounds (→ `geoint-photo`), and check-ins build a
  map of frequented places.
- **Pattern of life** — posting times reveal timezone and routine; recurring
  places reveal home/work.
- **Media** — download images and run `exif-metadata-analysis` (some platforms
  strip EXIF, many don't).
- **History** — deleted or edited posts via `wayback-archives` and platform
  archives.

**Done when** location, routine, and notable content are documented with post
links and dates.

## Step 5 — Pivot & corroborate

Link this account to the subject's other profiles via reused handle, photo, bio,
or writing style. Confirm cross-platform identity only on corroboration. **Done
when** linked accounts are graded and pivots followed.

## Step 6 — Report

Run `osint-report`. Summarize identity, network, locations, and pattern of life,
each claim tied to a specific post.
