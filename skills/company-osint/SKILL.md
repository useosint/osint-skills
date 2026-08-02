---
name: company-osint
description: Corporate intelligence and due-diligence workflow — map a company's legal structure, people, infrastructure, footprint, and risk from public records.
disable-model-invocation: true
---

# Company OSINT

Profile an organization for due diligence, M&A, vendor risk, fraud, or
competitive intelligence. Input: a company or brand name, or a domain.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Corporate research on public records is
broadly lawful; stay passive toward the company's private systems. **Done when
scope is noted.**

## Step 2 — Establish the legal entity

Resolve the brand to registered entities — the primary selector. Use
`corporate-registries` (Companies House, SEC EDGAR, OpenCorporates, state
registries) to get: legal name(s), registration number, incorporation date and
jurisdiction, status, addresses, officers, and shareholders. **Done when** at
least one canonical legal entity is identified with its registry ID.

## Step 3 — People

Pivot from officers, directors, and key staff to individuals. Run `person-osint`
on decision-makers; map staff and roles from LinkedIn, the team page (via
`wayback-archives` for departed staff), and conference/press mentions. **Done
when** leadership and relevant staff are listed with sources.

## Step 4 — Digital infrastructure

Pivot from the primary domain: run `domain-osint`, `whois-dns-recon`,
`certificate-transparency` (subdomains/acquired brands), and `shodan-censys-recon`
(exposed hosts and tech stack). Check `github-git-recon` for org repos and
leaked secrets. **Done when** domains, subdomains, and exposed services are
enumerated.

## Step 5 — Footprint & risk

- **Financials/filings** — SEC/regulatory filings, annual reports.
- **Litigation & sanctions** — court records, OFAC/sanctions and PEP lists,
  adverse-media screening.
- **Reputation** — news, reviews, breach exposure via `breach-data-analysis`.
- **Relationships** — subsidiaries, parents, and shared officers across
  registries reveal group structure.

**Done when** legal, financial, infrastructure, and reputational dimensions each
have sourced findings or a documented gap.

## Step 6 — Report

Run `osint-report`. Present an entity chart (parent → subsidiaries → key
people), then findings by dimension, each claim cited and dated.
