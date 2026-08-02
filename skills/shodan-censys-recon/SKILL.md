---
name: shodan-censys-recon
description: Find internet-exposed hosts, services, and devices from third-party scan data. Use when searching Shodan or Censys, finding open ports and banners, identifying an IP's tech stack, or discovering exposed databases, cameras, or industrial devices — without scanning the target yourself.
---

# Shodan & Censys Recon

Shodan and Censys continuously scan the internet and expose the results. You
query *their* data, so reconnaissance stays passive — you never send a packet to
the target.

## Tools

- **Shodan** — broadest device/banner coverage. Web, API, and `shodan` CLI.
- **Censys** — strong on certificates and structured host data.
- **FOFA / ZoomEye / Netlas** — useful alternatives with different coverage.

## Query patterns (Shodan)

```text
org:"Example Corp"            # everything attributed to an org
net:203.0.113.0/24           # a CIDR range
hostname:example.com         # by hostname
ssl.cert.subject.CN:example.com
product:"MongoDB" port:27017 # exposed databases
http.title:"index of"        # open directories
http.favicon.hash:<hash>     # sites sharing a favicon (find siblings)
```

## What it reveals

- **Attack surface** — open ports, running services and versions, and known
  vulns (Shodan tags CVEs).
- **Tech stack** — server software, frameworks, and device types from banners.
- **Exposed assets** — unauthenticated databases, dashboards, cameras, and
  ICS/SCADA devices (report responsibly; do not access them).
- **Pivots** — `http.favicon.hash` and shared certs cluster an org's scattered
  infrastructure; feed IPs back to `whois-dns-recon`.

## Rules

Observing exposure via Shodan is passive and legal; **connecting to or accessing
the exposed service is not** unless authorized. See [../../ETHICS.md](../../ETHICS.md).
