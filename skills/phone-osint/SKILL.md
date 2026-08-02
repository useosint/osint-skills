---
name: phone-osint
description: Investigate a phone number — normalize and classify it, identify carrier and line type, and pivot to owner identity, messaging apps, and linked accounts.
disable-model-invocation: true
---

# Phone OSINT

A phone number links messaging apps, account recoveries, and public listings.
Input: one or more phone numbers. Do not call or text the target as a technique.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Note the objective. **Done when noted.**

## Step 2 — Normalize & classify

Put the number in E.164 (`+<country><number>`). Identify country, region,
carrier, and line type (mobile / landline / VoIP):

```bash
phoneinfoga scan -n "+15551234567"
```

VoIP numbers (Google Voice, TextNow) signal a possible burner/sockpuppet.
**Done when** country, carrier, and line type are recorded.

## Step 3 — Messaging & app presence

Check whether the number is registered on messaging platforms via their own
"add contact" surfaces — WhatsApp, Telegram, Signal, Viber — which may expose a
display name or profile photo. Run `reverse-image-search` on any avatar. **Done
when** app presence and any exposed name/photo are noted.

## Step 4 — Linked accounts & listings

- Reverse-lookup and caller-ID services (Truecaller-style), business directories,
  and classified listings.
- `google-dorking` the number in multiple formats (with/without country code,
  spaces, dashes).
- `breach-data-analysis` — numbers appear in breach dumps tied to accounts.

**Done when** public listings and linked accounts are captured.

## Step 5 — Pivot

- Owner name → `person-osint`
- Recovered email/handle → `email-osint` / `username-osint`
- Business number → `company-osint`

**Done when** recovered selectors are followed or ruled out.

## Step 6 — Report

Run `osint-report`. State line type, carrier, app presence, and owner
attribution with confidence and sources.
