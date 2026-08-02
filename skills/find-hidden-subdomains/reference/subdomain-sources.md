# Subdomain source catalogue

Grouped by mechanism, because the mechanism determines what a source can and
cannot see. Coverage gaps are structural, not accidental: a CT source cannot show
you a host that never got a public certificate, and passive DNS cannot show you a
name nobody ever resolved.

Access models are described in kind — free and open, free with an account, keyed
with a quota, paid — because the specific tiers change. Assume any free tier
truncates results silently.

## Certificate Transparency

| Source | Access | Coverage and quirks |
|---|---|---|
| crt.sh | Free web UI, `output=json`, and a read-only Postgres endpoint (host `crt.sh`, port 5432, user `guest`, db `certwatch`) | The default first stop. Broad log coverage, deep history, `%` wildcard search, search by subject organization. Shared free service, so it rate-limits and occasionally times out on large queries |
| Censys certificates search | Free account with a quota; paid for volume and API depth | Strong structured cert data with parsed fields, and it joins certs to the hosts observed serving them — which crt.sh cannot do |
| SSLMate Cert Spotter | Free tier with a low rate limit, keyed for more: `https://api.certspotter.com/v1/issuances?domain=example.com&include_subdomains=true&expand=dns_names` | Clean JSON, well-suited to scripted monitoring for newly issued certs |
| CT logs directly | Free, unauthenticated | The log list Chrome trusts is published at `https://www.gstatic.com/ct/log_list/v3/log_list.json`. Each log serves the RFC 6962 endpoints (`/ct/v1/get-sth`, `/ct/v1/get-entries`). Enormous volume — only worth it if you are building your own index or need a log the aggregators miss |
| CertStream-style live feeds | Free clients; the public relay is best-effort, so self-host for anything you depend on | Real-time stream of new entries. The right tool for standing alerts on newly registered lookalike domains, not for historical lookup |

**What CT cannot see:** hosts with private-CA, self-signed, or CDN origin
certificates; plain-HTTP hosts; and any name hidden behind a wildcard cert.

## Passive DNS

Passive DNS records the answers resolvers actually observed, so it captures
hostnames that never held a certificate and IP history that DNS no longer serves.
Coverage depends entirely on the provider's sensor placement — a name only appears
if someone in their visibility resolved it.

| Source | Access | Notes |
|---|---|---|
| VirusTotal | Free account, keyed API, low free quota | Domain and IP reports include observed subdomains and resolution history. Good breadth, no depth guarantees |
| SecurityTrails | Free tier, paid for real use | Subdomain lists plus historical DNS and historical WHOIS in one place |
| DomainTools / DNSDB (Farsight) | Paid | Long-running, high-fidelity passive DNS. The reference dataset for time-ranged resolution history |
| Validin, Silent Push | Free tiers, paid for depth | Modern passive DNS with infrastructure-clustering features built for tracking adversary estates |
| Microsoft Defender Threat Intelligence | Licensed, some free surface | Passive DNS plus host pairing and tracker data |
| mnemonic and CIRCL | Public passive DNS services, account or agreement required | European sensor coverage that differs from the US-centric commercial sets; worth querying when a target is EU-based |

## Search-index and crawl derived

These find hostnames because a crawler or a user encountered a URL, which makes
them good at hosts that were once publicly linked.

| Source | Access | Notes |
|---|---|---|
| urlscan.io | Free search, keyed API: `https://urlscan.io/api/v1/search/?q=domain:example.com` | Scans submitted by users and automation. Also gives you the page's requested domains, which exposes third-party vendors and API hostnames |
| Wayback CDX API | Free: `http://web.archive.org/cdx/search/cdx?url=*.example.com&fl=original&collapse=urlkey` | Every archived URL under the domain, which yields hostnames and paths together. Pairs with `read-deleted-pages` |
| Common Crawl index | Free: query the URL index for a crawl collection with `url=*.example.com&output=json` | Huge crawl corpus, awkward to query, occasionally holds hostnames nothing else has |
| Google and Bing | Free, ToS-limited automation | `site:*.example.com -site:www.example.com` still surfaces hosts. Manual use is fine; scripted scraping breaches ToS — see `google-like-a-spy` |
| GitHub code search | Free account | Hostnames appear in configs, CI files and docs. Internal names leak here more than anywhere else. Follow up with `secrets-in-git-history` |

## Host-scan derived

Internet-wide scanners record the hostnames they see in certificates and HTTP
responses, so you can pull names out of scan data and, uniquely, get names
attached to observed open services.

Shodan, Censys, FOFA, ZoomEye, Netlas, Onyphe, BinaryEdge and LeakIX all do this
with different coverage and query languages. Use them through
`find-exposed-servers`, which covers the query syntax. The pivot that matters
here: search their data for the target's certificate subject or a distinctive
HTTP body string and you get hostnames plus the IPs serving them, which is more
than any pure-DNS source gives you.

ProjectDiscovery's Chaos dataset publishes precomputed subdomain data for
bug-bounty-scoped programs. If the target runs a public program, check it first —
it is free and already assembled.

## Aggregating tools

| Tool | What it is | Caution |
|---|---|---|
| `subfinder -d example.com -all -silent` | Queries many passive sources in parallel; the practical default | `-all` needs API keys configured for the keyed sources, or you silently get less |
| `amass enum -passive -d example.com` | Broader source mix and its own graph store | Slower. Without `-passive` it performs active resolution and brute-forcing |
| `assetfinder`, `findomain` | Lighter single-purpose passive collectors | Useful as a cross-check when you suspect truncation |
| `gau` | Pulls known URLs from archive and index sources, from which you extract hostnames | Returns URLs, not hostnames; parse them |
| `dnsx -l hosts.txt -a -resp` | Resolves a candidate list | This is DNS traffic. Use a public resolver, not the target's nameservers |
| `massdns`, `puredns`, `shuffledns` | High-throughput resolution and wordlist brute-forcing | Active and noisy. Requires scope authorization, and requires wildcard detection or every result is garbage |
| `httpx -l hosts.txt -sc -title -tech-detect` | Probes hosts over HTTP and reports status, title and detected tech | **Active.** You are connecting to the target. Out of bounds for passive-only work |

## Non-obvious sources worth remembering

- **SPF and MX records** name hostnames and netblocks directly. Pull them with
  `who-owns-this-domain` before you brute-force anything.
- **DMARC and MTA-STS** require their own hostnames (`_mta-sts.<domain>`, and the
  HTTPS policy host), so their presence confirms hosts exist.
- **Reverse DNS across the target's netblock** yields hostnames the target never
  published, if they own the block.
- **The names on certificates found on discovered IPs.** A host serving a cert
  for names you have not seen closes the loop back into CT.
- **Content Security Policy headers and JavaScript bundles** list the API and
  asset hostnames an application talks to. Read them from an archived copy or a
  urlscan result rather than by fetching the live site if you must stay passive.
- **Status pages, job ads and support documentation** name internal systems in
  plain language. Cheap, and frequently the source of the best guess at a naming
  convention.
