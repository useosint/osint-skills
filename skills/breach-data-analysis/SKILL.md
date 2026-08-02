---
name: breach-data-analysis
description: Check and interpret data-breach exposure for an email, username, or phone. Use when checking Have I Been Pwned, investigating breach or leak exposure, finding which services an account used, or assessing credential compromise.
---

# Breach Data Analysis

Breach records reveal which services a selector used, what data leaked, and
sometimes reused usernames and passwords to pivot on.

## Check exposure

- **Have I Been Pwned** (`haveibeenpwned.com`) — the trusted starting point.
  Shows which breaches an email appears in and what data classes leaked. API
  (keyed) enables bulk checks and the Pwned Passwords k-anonymity endpoint.
- **DeHashed / Snusbase / IntelX** — paid, searchable across email, username,
  name, phone, IP; return actual records. Use within your authorization only.

## Interpret

- **Service list** = accounts to pivot to. An email in a forum breach reveals a
  handle → `username-osint`; a matching username elsewhere links identities.
- **Data classes** — note what leaked (passwords, addresses, DOB, security
  questions) to gauge risk, not to exploit it.
- **Timeline** — breach dates place the account's activity in time.

## Hard rules

- **Never use leaked passwords to log in** to anything. Credential stuffing is a
  crime, full stop — see [../../ETHICS.md](../../ETHICS.md).
- Treat breach data as sensitive; store minimally and encrypted.
- Corroborate — breach compilations contain errors, duplicates, and fabricated
  rows. A single record is a lead, not proof.

## Defensive use

For a self-audit or client, turn findings into action: rotate exposed passwords,
enable MFA, and check for reuse across the discovered services.
