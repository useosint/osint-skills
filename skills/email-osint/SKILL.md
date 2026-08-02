---
name: email-osint
description: Investigate an email address — validate it, find linked accounts and breaches, and pivot to the owner's identity, usernames, and other contact selectors.
disable-model-invocation: true
---

# Email OSINT

An email is a high-value selector: it links accounts, appears in breaches, and
often encodes a name. Input: one or more email addresses. Never send email to
the target as a research technique.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Note the objective. **Done when noted.**

## Step 2 — Validate & parse

Confirm the address is real without messaging it: MX records for the domain,
SMTP/API validation services, and Gravatar (`https://gravatar.com/avatar/<md5>`
— an existing avatar confirms use and often shows a photo/name). Parse the
local-part for a likely name pattern (`first.last`, `flast`). **Done when** the
address is graded valid/invalid/unknown and the name guess is noted.

## Step 3 — Find linked accounts

Discover where the email is registered:

- Account-existence and enrichment tools (Holehe, `maigret`), which check
  password-reset/signup responses without logging in.
- Reverse the local-part as a username via `username-osint`.
- `google-dorking` the full address in quotes (resumes, leaks, forum posts).

**Done when** platforms tied to the address are listed.

## Step 4 — Breach exposure

Run `breach-data-analysis`: Have I Been Pwned and breach datasets reveal which
services the address used, sometimes exposing reused passwords, usernames, and
personal fields to pivot from. **Done when** breach appearances are recorded (or
none found).

## Step 5 — Pivot

- Owner name/photo → `person-osint`
- Recovered handles → `username-osint`
- Email domain (if corporate/custom) → `domain-osint` / `company-osint`

**Done when** all recovered selectors are followed or ruled out.

## Step 6 — Report

Run `osint-report`. Note validity, linked services, breach exposure, and the
identity the address maps to, each with a source.
