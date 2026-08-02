---
name: certificate-transparency
description: Discover subdomains and related domains from public TLS certificate logs. Use when enumerating subdomains, finding hidden or staging hosts, mapping an org's domains via crt.sh or Certificate Transparency, or spotting newly issued certificates.
---

# Certificate Transparency

Every publicly-trusted TLS certificate is logged to public CT logs. Those logs
are a goldmine for subdomains that never appear in DNS brute-forcing — passive
and complete.

## Query

```bash
# crt.sh JSON — all certs (and subdomains) for a domain
curl -s 'https://crt.sh/?q=%25.example.com&output=json' \
  | jq -r '.[].name_value' | sed 's/\*\.//' | sort -u
```

Web UI: `https://crt.sh/?q=example.com`. Alternatives: Censys certificates
search, and `subfinder`/`amass` which query CT among other sources.

## What it reveals

- **Subdomains** — including `dev`, `staging`, `vpn`, `internal-*` hosts an org
  never meant to publicize.
- **Sibling / acquired domains** — SANs on one cert list other domains the same
  entity controls.
- **Timeline** — issuance dates show when infrastructure went live; a burst of
  new certs can signal a launch or migration.
- **Internal naming** — hostnames leak conventions and product codenames.

## Method

1. Pull all `name_value` entries for the apex domain.
2. Dedupe and strip wildcards.
3. Resolve each with `whois-dns-recon` to find which are live and their IPs.
4. Feed live hosts to `shodan-censys-recon`.

Certs for a wildcard (`*.example.com`) hide specific subdomains — combine CT with
passive DNS to fill gaps.
