---
name: find-exposed-servers
description: >-
  Find internet-exposed hosts, ports, services and devices using third-party internet-scan
  data instead of touching the target. Covers Shodan and Censys query syntax, service banners,
  favicon-hash and TLS-certificate pivots, origin-IP discovery behind Cloudflare or a CDN, and
  exposed databases, dashboards, cameras and ICS devices. Use when asked what a company has
  exposed to the internet, to check open ports on an IP or netblock, or to write a Shodan
  filter query. Applies to external attack-surface management, third-party and vendor security
  review, M&A technical diligence, and pre-engagement reconnaissance. Reference at
  useosint.com/skills/find-exposed-servers.

---

# Find exposed servers

Internet-wide scanners already scanned your target. Querying their results is
passive — you never send a packet to the target, so nothing appears in their logs
and nothing is attributable to you. The cost is that every result is a claim about
a moment in the past, and the beginner's mistake is reading a banner as the
current state of a live host.

## Which platform first

| You hold | Reach for | Why |
|---|---|---|
| An IP | Shodan host lookup, or the free InternetDB endpoint | One request gives ports, hostnames, and CPEs |
| A netblock or ASN | Shodan `net:`/`asn:` with port faceting | Shows the shape of the estate before you look at individual hosts |
| A hostname behind a CDN | Censys certificate-to-host joins | Censys links certs to observed hosts, which is how you find origins |
| A cert or a distinctive page | Favicon hash and cert subject/serial searches | Finds sibling infrastructure the DNS never links |
| An org name | `org:` on Shodan, `autonomous_system` on Censys | Both are attribution by network registration, so both inherit its errors |
| Coverage doubt | A second platform with different sensors | The platforms disagree constantly; disagreement is signal |

Shodan has the broadest device and protocol coverage and the friendliest query
language. Censys has more structured host records, better certificate joins, and
a stricter query syntax. FOFA, ZoomEye, Netlas, Onyphe, BinaryEdge and LeakIX see
different slices of the internet and are worth a pass when the first two come up
empty — non-Western scanners in particular index hosts the big two miss.

## Shodan

```bash
shodan init <api-key>
shodan host 203.0.113.10                                 # everything known about one IP
shodan search --fields ip_str,port,org,hostnames 'ssl.cert.subject.CN:example.com'
shodan count 'net:203.0.113.0/24'                        # cheap: no result credits
shodan stats --facets port,org 'net:203.0.113.0/24'      # the shape of a netblock
shodan download results.json.gz 'asn:AS64500 port:3389'
shodan parse --fields ip_str,port,product results.json.gz
```

Free and unauthenticated, for a single IP:

```bash
curl -s https://internetdb.shodan.io/203.0.113.10 | jq .   # ports, hostnames, cpes, vulns
```

Filters worth knowing: `net:`, `port:`, `hostname:`, `asn:`, `org:`, `isp:`,
`country:`, `city:`, `product:`, `version:`, `os:`, `http.title:`, `http.html:`,
`http.status:`, `http.favicon.hash:`, `ssl.cert.subject.CN:`,
`ssl.cert.issuer.CN:`, `ssl.cert.expired:`, `ssl.jarm:`, `ssl:`, `tag:`, `vuln:`,
`has_screenshot:`, and `before:`/`after:` for scan dates. `vuln:` and some others
require a paid tier.

Censys uses a structured field path syntax over a host document — `services.port`,
`services.service_name`, `services.http.response.html_title`,
`services.tls.certificates.leaf_data.subject_dn`, `dns.names`,
`autonomous_system.asn`, `location.country` — combined with `and`/`or`/`not`. Its
API v2 exposes `https://search.censys.io/api/v2/hosts/search?q=…` and
`https://search.censys.io/api/v2/hosts/{ip}` with API-ID/secret basic auth.

Side-by-side query equivalents across platforms are in
[reference/query-cookbook.md](reference/query-cookbook.md).

## Reading what comes back

A result is a banner plus metadata, not a verdict. Interpretation of specific
service banners — what a version string implies, which fields are self-reported
and which are observed — is in
[reference/banner-interpretation.md](reference/banner-interpretation.md). The
general discipline:

- **Check the scan timestamp on every record.** Shodan records carry a timestamp;
  Censys carries a last-observed time. Rescan cadence varies by port and address
  space, so a record can be days or many months old. Report findings as
  "observed on <date>", never as "is".
- **Separate observed from claimed.** The open port and the TLS certificate are
  observed facts. The product name and version are parsed from a banner the host
  chose to send, and hosts lie — deliberately, or because a distribution
  backported patches without changing the version string.
- **CVE tags are inference.** They come from matching a version string against a
  vulnerability database. They are leads for a report, never confirmation of
  exploitability, and backported fixes make them wrong routinely in both
  directions.
- **Hostnames in a record come from reverse DNS and certificates**, which means
  they can belong to a previous tenant of the IP.

## The pivots that matter

This is what makes scan platforms more than a port list.

**Favicon hash.** Shodan indexes a hash of the site's favicon (a MurmurHash3 of
the base64-encoded icon bytes; FOFA's `icon_hash` uses the same construction).
Because a favicon is usually shipped with an application rather than configured
per host, searching the hash finds every host running the same appliance,
framework, or the target's own branded portals — across unrelated IPs, ASNs and
domains. It is the single best way to find an organization's scattered instances
of one product.

**TLS certificate.** Search on the certificate's subject CN, its subject
organization, or its serial number, and you find every host serving that
certificate. A certificate serial is unique per issuer, so a serial match is a
near-exact identity. Shodan also exposes a certificate fingerprint filter; check
its documentation for which hash it expects rather than guessing. Combine with
`find-hidden-subdomains` — CT gives you the cert, scan data gives you every host
presenting it.

**JARM and TLS stack fingerprints.** JARM hashes how a server responds to a set
of TLS handshakes, so it fingerprints the TLS stack rather than the certificate.
It clusters appliances, load balancers and command-and-control frameworks. It is
not unique to an organization, so treat it as a filter that narrows a search, not
as an identifier.

**Response-body fingerprints.** A unique string from the target's pages — a
tracking ID, an unusual copyright line, a custom header, a build hash — searched
via `http.html:` finds other hosts serving the same application, including
staging copies and the origin behind a CDN.

## Finding an origin behind a CDN

When a hostname resolves to Cloudflare or another proxy, the origin still exists
and is often reachable by IP. Passive routes to it, in order of reliability:

1. Search scan data for the target's TLS certificate on IPs **outside** the CDN's
   ASNs. Origins commonly serve the real cert directly.
2. Search a unique HTTP body string or favicon hash and filter out CDN ASNs.
3. Read historical DNS from before the CDN was adopted (`who-owns-this-domain`).
   Origins move less often than people assume.
4. Check services that bypass the proxy by design: MX hosts, `ftp`, `cpanel`,
   `direct`, `origin`, and non-HTTP ports on the same netblock.
5. Read SPF `ip4:` mechanisms — organizations authorize their own sending host,
   which is sometimes the web origin.

A candidate origin is a hypothesis. Confirming it by sending a request with the
target's `Host` header is an active step against the target: it needs
authorization. Note also that a properly configured origin rejects non-CDN
traffic, so failure to confirm does not disprove the candidate.

## Where this goes wrong

- **Staleness cuts both ways.** A closed port may have been open when scanned; an
  open port may have been closed since. Absence of a result is not absence of a
  service — scanners do not cover every port on every address.
- **Honeypots pollute everything.** Deliberately exposed decoys inflate results
  for interesting services. Tells: implausible service combinations on one host,
  a very large number of open ports, default banners for many unrelated products,
  and hosting in research-oriented netblocks. Shodan exposes a honeyscore
  estimate at `https://api.shodan.io/labs/honeyscore/{ip}?key=` — treat it as a
  hint, not a ruling.
- **Targets can game the scanners.** Scanner source addresses are publishable, so
  a defender can serve fabricated banners to them specifically. High-value
  targets sometimes do.
- **`org:` and `isp:` are network registration, not ownership.** On cloud
  netblocks they name the cloud provider, and on resold space they name a
  reseller. Attribution by `org:` alone is how people end up reporting a
  neighbour's exposed database as the target's.
- **Shared hosting and shared IPs.** One IP can serve hundreds of unrelated
  sites. Ports and vulnerabilities found there belong to the host, not
  necessarily to your target.
- **Screenshots and banners contain personal data.** Exposed dashboards and
  cameras index real people. That is a data-protection problem the moment you
  save it.
- **Platforms disagree, and each free tier truncates.** A single-platform search
  that finds nothing means one sensor network saw nothing.

## Confidence grading

- **Confirmed exposure** — the same service on the same IP and port appears in
  two independent scan platforms, or in one platform across multiple scan dates,
  and the IP is tied to the target by a certificate the target demonstrably
  controls or by a netblock reassigned to the target by name.
- **Probable** — a single recent observation on an IP linked to the target by
  favicon hash, body-string match or reverse DNS. Or a cross-platform match on an
  IP whose ownership you have not independently established.
- **Unconfirmed** — attribution resting only on `org:`/`isp:`, a shared-hosting
  IP, a single stale record, a CVE tag with no other evidence, or a host with
  honeypot characteristics.

Never upgrade a grade by connecting to the service. Record the platform, the
query, the scan timestamp and the record identifier for every finding.

## Worked example

Target: `example-fintech.test`, authorized external attack-surface review,
passive collection only.

The apex resolves into Cloudflare, so port scanning the resolved IP would only
have described Cloudflare. Instead, take the cert subject CN from
`find-hidden-subdomains` and search scan data for hosts serving it. Three hits:
two Cloudflare addresses, and one in a European hosting provider's ASN with 443
and 22 open. That third host is the likely origin.

Its favicon hash, searched back, returns six more hosts. Four are the target's
regional portals. Two are unrelated companies — the favicon is a stock icon
shipped with the framework, not the target's own. That is the dead end, and the
lesson: check whether a favicon is actually distinctive before treating a hash
match as attribution.

`net:` on the origin's /29 shows a second host with 3306 open and a MySQL banner,
scanned four months ago. Old, so it may be gone, but it is reportable as observed.
The netblock's RIR record shows a reassignment to the target's legal name, which
is what turns "an IP with the right cert" into attribution.

Stop there. Do not connect to 3306, do not send a `Host` header to the origin.
Report both, with dates and queries, and hand the reassigned netblock back to
`who-owns-this-domain`.

## Pivots

| New selector | Goes to |
|---|---|
| Certificate subjects and SANs on discovered hosts | `find-hidden-subdomains` |
| Netblocks, ASNs, reverse-DNS hostnames | `who-owns-this-domain` |
| Organization names from cert subjects and RIR records | `x-ray-a-company`, `who-really-owns-it` |
| Exposed repo, CI or registry services | `secrets-in-git-history` |
| Historical content on a discovered host | `read-deleted-pages` |
| Indexed paths on a discovered service | `google-like-a-spy` |
| A host/cert/ASN cluster to lay out | `graph-the-network` |

## Legal and ToS notes

Querying a scan platform is lawful passive research. Acting on the result is
where the line is: connecting to an exposed database, opening an admin panel,
viewing an exposed camera feed, or fetching a file from an open share can
constitute unauthorized access under computer-misuse law in most jurisdictions,
and the absence of a password is not a defence. A finding authorizes you to
**report** — to the abuse contact from the netblock's RIR record, or the relevant
CERT — and nothing else. Scan-platform terms also restrict redistribution of
their data, so quote findings in a report rather than republishing the dataset.
Screenshots and banners containing personal data fall under the minimization
rules in [../../ETHICS.md](../../ETHICS.md).
