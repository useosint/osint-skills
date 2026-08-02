---
name: domain-osint
description: Passive reconnaissance workflow for a domain, website, or IP — maps DNS, subdomains, infrastructure, tech stack, history, and ownership without touching the target.
disable-model-invocation: true
---

# Domain OSINT

Map a domain's attack surface and ownership from public sources. Input: a
domain, hostname, or IP. Passive by default — no scanning of the target's
systems without written authorization.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Passive lookups (DNS, CT logs, archives)
are generally fine; active scanning/probing needs authorization. Note the scope
and stay on the passive side unless cleared. **Done when noted.**

## Step 2 — Ownership & records

Run `whois-dns-recon`: WHOIS/RDAP registrant and dates, nameservers, MX, SPF/
DKIM/DMARC, and full DNS record set. Note the registrar and hosting ASN. **Done
when** registration and DNS records are captured with lookup timestamps.

## Step 3 — Expand the surface

Enumerate subdomains and related assets:

- `certificate-transparency` — crt.sh and CT logs reveal subdomains and sibling
  domains sharing certs (often the strongest passive source).
- Passive DNS and subdomain sources (SecurityTrails, `amass -passive`,
  `subfinder`).
- `shodan-censys-recon` — hosts, open ports, banners, and tech stack for the
  discovered IPs, all from third-party scan data.

**Done when** subdomains and associated IPs/services are listed.

## Step 4 — Content, tech & history

- Tech stack — Wappalyzer/BuiltWith, response headers, favicon hash.
- History — `wayback-archives` for old pages, staff, and exposed paths;
  `google-dorking` for indexed sensitive files.
- Code — `github-git-recon` for repos, configs, and leaked secrets tied to the
  domain.

**Done when** the tech stack, notable historical content, and any code exposure
are documented.

## Step 5 — Pivot to owners

Pivot registrant emails/orgs to `email-osint` / `company-osint`, and reused
analytics/AdSense IDs or favicon hashes to find sibling sites. **Done when**
owner-side selectors are followed or ruled out.

## Step 6 — Report

Run `osint-report`. Include an asset inventory (domain → subdomains → IPs →
services) and note anything that looks unintentionally exposed.
