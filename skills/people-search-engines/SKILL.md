---
name: people-search-engines
description: Use people-search aggregators and public records to find a person's contact and background data. Use when looking up someone in people-search sites, finding addresses/relatives/phone from public records, or aggregating identity data across data brokers.
---

# People Search Engines

Data brokers aggregate public records, marketing data, and scraped profiles into
searchable people profiles. Fast leads, but noisy and error-prone.

## Sources

- **Aggregators** — Spokeo, BeenVerified, Whitepages, TruePeopleSearch,
  FastPeopleSearch, Pipl (business/investigator tier), That'sThem. Coverage is
  strongest in the US.
- **Public records** — voter files (where lawful), county court and property
  records, business filings (→ `corporate-registries`), obituaries, and alumni
  directories.
- **Region-specific** — most countries have their own registries and phone
  directories; the US-centric brokers won't cover them.

## Method

1. Start from the richest selector (full name + city, or a phone/email the
   brokers reverse-lookup).
2. Cross-read **several** brokers — each buys different data; the overlap is your
   most reliable signal.
3. Use relatives/associates listings to disambiguate namesakes and map a
   family/network graph.
4. Pivot found emails/phones/handles into `email-osint`, `phone-osint`,
   `username-osint`.

## Cautions

- Broker data is frequently **stale or wrong** (old addresses, merged people).
  Treat every field as unverified until corroborated.
- These sites are the raw material of doxxing — see [../../ETHICS.md](../../ETHICS.md).
  Use only for a lawful objective, and note that many jurisdictions (and the
  brokers' own opt-outs) restrict use of this data.
