---
name: whois-dns-recon
description: Look up domain registration and DNS records. Use when running WHOIS/RDAP, querying DNS records (A, MX, TXT, NS, SPF, DKIM, DMARC), finding a domain's registrant, nameservers, or mail setup, or resolving IPs and ASNs.
---

# WHOIS & DNS Recon

Registration and DNS records reveal ownership, infrastructure, and mail
security posture — all passive.

## WHOIS / RDAP

```bash
whois example.com          # registrar, dates, nameservers, registrant
```

RDAP is the structured successor — query `https://rdap.org/domain/example.com`.
Registrant details are often GDPR-redacted; the **registrar, creation date, and
nameservers** still pivot well. Historical WHOIS (WhoisXML, SecurityTrails) can
show pre-redaction owners and registrant email — feed those to `email-osint`.

## DNS records

```bash
dig example.com ANY +noall +answer
dig example.com MX +short           # mail servers
dig example.com TXT +short          # SPF, verification tokens
dig _dmarc.example.com TXT +short   # DMARC policy
```

- **A/AAAA** → hosting IP; look up the ASN/host for shared-hosting neighbors.
- **MX** → mail provider (Google/Microsoft/self-hosted).
- **TXT/SPF** → third-party services the org uses (marketing, SaaS senders).
- **NS** → DNS provider, and sometimes internal naming conventions.

## Pivots

- IP/ASN → `shodan-censys-recon` for exposed services.
- Subdomains → `certificate-transparency`.
- Registrant org/email → `company-osint` / `email-osint`.
- Reused nameservers or MX across domains hint at the same owner.
