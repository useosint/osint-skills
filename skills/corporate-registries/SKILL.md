---
name: corporate-registries
description: Look up companies, officers, and ownership in official business registries and filings. Use when researching a company's legal entity, finding directors/shareholders/beneficial owners, checking incorporation records, or reading SEC/regulatory filings.
---

# Corporate Registries

Official registries turn a brand into a legal entity with named people, dates,
and addresses — the backbone of due diligence.

## Key sources

- **OpenCorporates** — largest cross-jurisdiction aggregator; start here to find
  the entity and its home registry.
- **National registries** — Companies House (UK, free, rich), SEC EDGAR (US
  filings), state Secretary-of-State registries (US incorporation), and each
  country's equivalent.
- **Beneficial ownership** — UK PSC register, EU registers, and OpenOwnership for
  who ultimately controls an entity.
- **Sanctions/PEP** — OFAC, EU, UN lists and OpenSanctions for screening.
- **Leaks** — ICIJ Offshore Leaks database for offshore structures.

## What you extract

- Legal name(s), registration number, jurisdiction, status, incorporation date.
- Registered and business addresses (shared addresses hint at shell networks).
- **Officers and directors** → run `person-osint` on each.
- Shareholders / beneficial owners → parent and subsidiary structure.
- Filings: annual accounts, ownership changes, and (SEC) detailed financials.

## Method

1. OpenCorporates to locate the canonical entity and registry.
2. Pull the full record from the home registry (more detail than aggregators).
3. **Pivot on shared officers, addresses, and phone/email** across records to
   uncover related entities and the corporate group.
4. Screen the entity and its principals against sanctions/PEP lists.

Assemble the group into an entity chart for `company-osint` / `osint-report`.
