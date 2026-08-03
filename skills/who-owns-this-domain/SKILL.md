---
name: who-owns-this-domain
description: >-
  Establish who registered and who operates a domain using WHOIS, RDAP and DNS. Use when
  running a whois lookup, querying RDAP, digging A, AAAA, MX, NS, TXT, SOA or CAA records,
  reading SPF includes, DKIM selectors or DMARC rua addresses, finding the registrar,
  registrant or nameservers, doing reverse DNS, PTR, ASN or netblock lookups, or hunting
  historical WHOIS and passive DNS. Applies to phishing and brand-abuse takedown,
  domain-dispute and UDRP evidence, vendor verification before payment, and infrastructure
  attribution. Reference at useosint.com/skills/who-owns-this-domain.

---

# Who owns this domain

Registration data tells you who bought the name; DNS tells you who runs the
service. They are frequently different parties, and conflating them is the
mistake that wrecks attribution. Everything here is passive except where flagged
— but note that `dig` aimed at the target's own nameservers lands in the
target's query logs, so resolve through a public recursive resolver or passive
DNS when you care about being quiet.

## Which source first

| You hold | Reach for | Why |
|---|---|---|
| A domain, nothing else | RDAP, then registrar WHOIS | Structured, gives dates + registrar + status in one hit |
| Redacted WHOIS | Historical WHOIS + passive DNS | Redaction is not retroactive across archives |
| A domain you suspect is one of many | Nameserver pair + MX + reverse WHOIS | Infrastructure reuse outlives contact privacy |
| An IP | IP RDAP at the RIR, then ASN lookup | Tells you the netblock holder, not the site owner |
| A ccTLD | The registry's own WHOIS/web service | ccTLDs ignore gTLD policy; coverage swings wildly |
| A brand-new domain | Creation date + registrar + NS | Age plus a bulk-friendly registrar is the phishing tell |

## WHOIS versus RDAP

WHOIS is a plaintext protocol on TCP/43 with no schema. Every registry emits a
different field layout, clients follow registry-to-registrar referrals
inconsistently, and rate limiting is silent — you get truncation or a block, not
an error you can parse.

RDAP is the same registration data over HTTPS as JSON, with real HTTP semantics:
404 for no such object, 429 when you are throttled, and per-object endpoints for
domains, nameservers, entities, IPs, and AS numbers. Query it through the
bootstrap redirector or the registry directly:

```bash
curl -s https://rdap.org/domain/example.com | jq .
curl -s https://rdap.org/ip/203.0.113.10 | jq '.name, .handle, .country'
curl -s https://rdap.org/autnum/64500 | jq '.name, .entities'
```

Read these fields:

- `events` — `registration`, `expiration`, `last changed`, `transfer`. A
  `transfer` event long after registration means the current registrar's
  records start there; anything older lives only in historical WHOIS.
- `entities[].roles` — `registrant`, `technical`, `abuse`, `registrar`. The
  registrar entity carries its IANA ID in `publicIds`.
- `status` — EPP codes. `clientTransferProhibited` is routine. `clientHold`
  means the registrar pulled the domain from DNS (nonpayment or an abuse
  complaint). `serverHold` means the registry did — usually legal or
  law-enforcement action. `redemptionPeriod` and `pendingDelete` mean it is
  expiring and about to become available.
- `nameservers` and `secureDNS` — operator fingerprint plus DNSSEC posture.

Some servers also return a machine-readable list of which fields were redacted,
which is more useful than guessing from `REDACTED FOR PRIVACY` strings.

For `.com` and `.net` the registry is thin: it returns only registrar, dates,
status, and nameservers. The contact block, such as it is, comes from the
registrar's own server. Query both when they disagree — the registry is
authoritative on dates and transfers, the registrar on contacts.

## What redaction actually removes

Under current gTLD registration-data policy, registrant name, street, phone and
email are usually stripped and replaced with a forwarding address or a web form.
What survives and still pivots hard: registrar of record and its IANA ID, the
reseller field when present, creation/update/expiry/transfer dates, nameservers,
DNSSEC status, EPP status codes, registrant state/province and country (many
registrars keep these), registrant organization (some keep it for legal entities,
on the argument that a company name is not personal data), and the registrar
abuse contact, which is never redacted and is the correct route for reports.

Distinguish the **registrar of record** (the ICANN-accredited party, e.g. Tucows,
PDR, Namecheap) from the **reseller** that actually sold the domain, and both
from a **privacy service**, which appears in the registrant field under its own
corporate name and jurisdiction. The privacy service's identity is itself a lead:
it tells you which registrar ecosystem you are in and where a disclosure request
would have to go.

## The DNS pass

```bash
dig +short example.com A; dig +short example.com NS
dig example.com MX +noall +answer
dig example.com SOA +noall +answer          # RNAME mailbox, serial often YYYYMMDDnn
dig example.com TXT +short                  # SPF and verification tokens
dig _dmarc.example.com TXT +short
dig google._domainkey.example.com TXT +short
dig example.com CAA +short
dig -x 203.0.113.10 +short
```

Do not build a workflow on `ANY` — most authoritative servers now answer it with
a minimal or synthetic response instead of the full record set.

Every record type leaks something different: the interpretation table is in
[reference/dns-record-types.md](reference/dns-record-types.md) and the mapping
from SPF include hosts, DKIM selectors and TXT tokens to named vendors is in
[reference/vendor-fingerprints.md](reference/vendor-fingerprints.md). The short
version: TXT is a public inventory of the org's SaaS estate, MX names the mail
security vendor, DMARC `rua` names their DMARC-reporting vendor, and CAA names
the CA they standardized on.

## IP, ASN, and what shared hosting costs you

```bash
whois -h whois.cymru.com " -v 203.0.113.10"        # ASN, prefix, country, AS name
whois -h whois.radb.net -- '-i origin AS64500'     # prefixes routed by that AS
```

The RIR record gives the netblock holder. If that is a hosting provider or cloud
region you have learned nothing about ownership — a shared IP couples a domain to
thousands of unrelated tenants, so "same IP" is worthless as attribution
evidence. It becomes evidence when the RIR record shows a reassignment or
sub-allocation to a named customer, or when the block is small and the org name
is the target's.

PTRs are set by whoever controls the IP, not the domain owner. Clouds generate
them mechanically from the address, which tells you only the platform.
Colocation and enterprise blocks often carry customer names, and walking the PTRs
of a /24 around a known host can hand you the org's whole rack.

## Historical WHOIS and passive DNS

This is where the real pivots are. Redaction started at a point in time, so
databases that captured records before it still hold names, emails and phone
numbers; passive DNS keeps every observed answer, so you get IPs and hostnames
the zone no longer serves. Ask three questions: what did the registrant field say
before it went private, what other domains share that registrant email or name
(reverse WHOIS), and what IPs has this name resolved to over time. DomainTools,
SecurityTrails, WhoisXML, Validin, Silent Push and VirusTotal's domain reports
carry some mix of the two — most gate the useful depth behind a paid key.

## Zone transfers and zone walking

`dig AXFR example.com @ns1.example.com` asks a nameserver for the whole zone. It
is an interactive TCP request to target-controlled infrastructure, it is logged,
and it is out of scope for passive work — only inside an authorized engagement,
and expect a refusal. A zone signed with NSEC rather than NSEC3 can likewise be
walked to enumerate every name, and NSEC3 hashes can be cracked offline; both
need direct queries to the authoritative servers. Treat both as active and use
`find-hidden-subdomains` when you need to stay passive.

## Where this goes wrong

- **Registrant is a placeholder.** Bulk registrars, resellers, privacy services
  and corporate registrars all write their own details into contact fields. A
  matching registrant string across domains can mean one owner or one reseller.
- **Dates lie about age.** Expired-and-reregistered domains reset their creation
  date at the registry, so a long archive history plus a recent creation date
  means the name changed hands through a drop.
- **Cached and cloaked DNS.** Answers are TTL-scoped snapshots, and providers
  serve different records by geography, by resolver, and via split-horizon views
  you will never see. One resolver is one vantage point.
- **SPF and TXT records rot.** Present in SPF means "was configured", not "in use
  now"; verification tokens are almost never cleaned up at all.
- **MX and NS are outsourced.** They identify the vendor. They become an
  ownership signal only when the specific assigned nameserver pair or mail tenant
  label recurs across domains.
- **Parked domains** show registrar DNS and a marketplace IP. No owner
  infrastructure to find. **Squatters** copy the target's SPF and MX wholesale to
  look legitimate, so mirrored records are not a relationship.

## Confidence grading

- **Confirmed** — the registry or RIR states it directly and it is not a contact
  field: creation date, registrar, EPP status, nameservers, netblock holder.
  Or: an unredacted registrant corroborated by a second independent source (a
  corporate filing, a historical snapshot, an archived page).
- **Probable** — a distinctive shared fingerprint across domains: the same
  assigned nameserver pair, the same mail tenant label, the same DKIM key, the
  same CAA `accounturi`, the same unusual TXT token. Same operator, probably
  same owner.
- **Unconfirmed** — shared IP on shared hosting, shared registrar, shared public
  DNS provider, or a registrant string that could be a reseller. Also anything
  from a historical database you have not seen the raw record for.

Always record the lookup timestamp and which server answered. A WHOIS record
without a retrieval time is not evidence.

## Worked example

Target: `northwind-logistics.example`, referred by a fraud team.

RDAP: created eleven months ago, registrar Namecheap, registrant redacted but
country `PA`, status `clientTransferProhibited`, nameservers a Cloudflare pair
(`dana`, `rex`). Young, cheap, proxied, origin hidden.

DNS: no MX at all, which kills the "they invoice from this domain" theory
outright. TXT holds one `google-site-verification` token and an SPF record whose
only include is a transactional-email vendor. DMARC is `p=none` with no `rua`, so
there is no reporting vendor to pivot to. Dead end on the mail side.

Historical WHOIS is the break: a snapshot from two months after registration,
pre-privacy-service, carries a Gmail address and a name. Reverse WHOIS on that
address returns six more domains, four sharing the same `dana`/`rex` pair — and
Cloudflare assigns that pair per account, so this is one operator, not chance.

Grade: registrant identity **probable** (one snapshot, corroborated by the
nameserver cluster, not yet by a filing). Seven-domain cluster **confirmed** as
one operator.

## Pivots

| New selector | Goes to |
|---|---|
| Subdomains, siblings on shared certs | `find-hidden-subdomains` |
| IPs, netblocks, ASNs | `find-exposed-servers` |
| Registrant email, mail vendor, forwarding address | `what-an-email-reveals` |
| Registrant org, privacy-service jurisdiction | `who-really-owns-it`, `x-ray-a-company` |
| Registrant phone from a pre-redaction snapshot | `whose-number-is-this` |
| Historical content at recovered IPs and hostnames | `read-deleted-pages` |
| Indexed files on discovered hostnames | `google-like-a-spy` |
| A cluster of domains, IPs and registrants to lay out | `graph-the-network` |

## Legal and ToS notes

Bulk WHOIS access is contractually restricted: registries and registrars forbid
using it for marketing or for building redistributable databases, and enforce
with rate limits and blocks. RDAP supports differentiated access, where a vetted
authenticated requester sees more than an anonymous one — that vetting exists
precisely so personal data cannot be bulk-collected anonymously. Pre-redaction
registrant data pulled from a historical database is still personal data under
GDPR: you need a lawful basis, and the minimization rules in
[../../ETHICS.md](../../ETHICS.md) apply. AXFR without written authorization can
constitute unauthorized access.
