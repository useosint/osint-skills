---
name: find-hidden-subdomains
description: >-
  Enumerate an organisation's subdomains and sibling domains from Certificate Transparency
  logs and passive DNS, without sending traffic to the target. Covers crt.sh and CT log
  queries, certificate SAN fields, subfinder and amass, and newly issued TLS certificates. Use
  when looking for staging, dev, admin or VPN hosts, mapping the full hostname footprint of a
  domain, or spotting infrastructure a company forgot it had. Applies to attack-surface
  mapping, vendor and supply-chain security review, brand-infringement discovery, and M&A
  technical diligence. Reference at useosint.com/skills/find-hidden-subdomains.

---

# Find hidden subdomains

The hosts an organization forgot about are the ones worth finding, and most of
them announced themselves the moment someone requested a TLS certificate.
Certificate Transparency turns that into a searchable, permanent, historical
index — free and completely passive. The beginner's mistake is treating a CT hit
as a live host: most of what you pull back does not resolve, and that is
information too, not noise.

## Which source first

| You hold | Start with | Why |
|---|---|---|
| An apex domain | crt.sh wildcard query | Broadest free coverage, includes long-dead names |
| A domain behind a wildcard cert | Passive DNS, then archives | CT will only show you `*.example.com` |
| A guess at a naming convention | CT to learn the convention, then a wordlist | Learn the pattern before brute-forcing anything |
| An org name, not a domain | Certificate search by subject organization | Finds domains you did not know they owned |
| A cert you already have | Its SANs, then its serial and issuer | SANs give siblings; serial finds the exact cert elsewhere |
| A need for *current* hosts only | Resolve the candidate list | CT is historical by nature; DNS is the liveness oracle |

## How CT actually works

CAs submit every certificate they issue to append-only, cryptographically
verifiable public logs. The log returns a Signed Certificate Timestamp, and
mainstream browsers refuse to trust a publicly-trusted certificate that does not
carry SCTs from qualified logs. So participation is not voluntary: if the
certificate works in a browser, it is in the logs.

Three consequences that matter to you:

- **Nothing is removed.** Logs are append-only. A hostname that appeared in a
  cert five years ago is still there after the host is gone.
- **You see precertificates and certificates.** CAs log a precertificate first,
  then the final cert, so most names appear at least twice. Deduplicate.
- **Only publicly-trusted certs are covered.** A private/internal CA, a
  self-signed cert, or a Cloudflare origin certificate never reaches a log. CT is
  blind to those hosts entirely.

## crt.sh

The web UI takes `?q=`, where `%` is a wildcard, and `output=json` gives you
machine-readable results.

```bash
# every name ever seen in a cert covering example.com or a subdomain
curl -s 'https://crt.sh/?q=%25.example.com&output=json' \
  | jq -r '.[].name_value' | sed 's/^\*\.//' | sort -u

# skip expired certs when you want a bias toward current infrastructure
curl -s 'https://crt.sh/?q=%25.example.com&output=json&exclude=expired' | jq -r '.[].name_value'

# an identity search on an organization string, which finds unknown domains
curl -s 'https://crt.sh/?q=Example+Corporation&output=json' | jq -r '.[].name_value'
```

The `q` parameter is an identity search: it matches domain names, and it also
matches subject fields such as the organization name, which is how you find
domains the brief never mentioned.

Useful JSON fields: `name_value` (all names on the cert, newline-separated),
`common_name`, `issuer_name`, `not_before` / `not_after`, `serial_number`,
`entry_timestamp`, and `id` (open `https://crt.sh/?id=<id>` to read the cert).

crt.sh also exposes its database read-only over Postgres — host `crt.sh`, port
5432, user `guest`, database `certwatch`. That lets you write real SQL against
the certificate index instead of paginating JSON. It is a shared free service:
keep queries bounded and expect to be cut off if you hammer it.

Alternatives and other CT front-ends, with their coverage and access models, are
in [reference/subdomain-sources.md](reference/subdomain-sources.md).

## The SAN field is the prize

Browsers ignore the Common Name; the `subjectAltName` extension holds the real
list of covered hostnames. Read it as a statement about what one team deployed
together:

- A cert with a handful of related names is an intentional grouping — those hosts
  belong to the same service and probably the same admin.
- A cert with dozens of unrelated names is a hosting provider's or CDN's bundled
  certificate. **Those names are other customers, not your target's assets.**
  This is the single biggest false-positive source in CT-based enumeration.
- Names from *different registrable domains* on one cert are the good find: it
  means one operator manages both, which surfaces acquisitions, rebrands and
  undisclosed sibling brands. Verify before concluding — see the bundling trap
  above.
- Internal names leak here constantly: `jira`, `owa`, `vpn`, `*.corp.example.com`,
  hostnames with rack or datacenter codes, and product codenames that never
  shipped publicly.

## Wildcards hide, they don't reveal

`*.example.com` covers every subdomain and names none of them. An org that
switched to a wildcard, typically alongside DNS-01 ACME automation, effectively
went dark in CT from that point. When you see a wildcard:

- Mine CT for the period *before* the wildcard, when per-host certs existed.
- Move to passive DNS, which records answers rather than certificates.
- Check archives and search indexes for hostnames (`read-deleted-pages`,
  `google-like-a-spy`).
- Look for hosts that must still have their own cert for technical reasons: a
  deeper label than the wildcard covers (`a.b.example.com` needs its own), and
  anything on a different apex.

## Combining sources, then resolving

CT gives you history. Passive DNS gives you observed reality. Wordlists give you
names nobody published. Use all three, and keep them labelled by origin, because
the confidence you can assign depends on where a name came from.

```bash
subfinder -d example.com -all -silent -o passive.txt   # aggregates many passive sources
amass enum -passive -d example.com                     # different source mix, slower
dnsx -l passive.txt -a -resp -silent                   # resolve candidates to A records
```

Resolution turns candidates into three buckets: resolves to an address, resolves
to a CNAME (read the target — it names the vendor, and a dangling one is a
takeover candidate to report), or does not resolve at all. Dead names are still
findings: they date the infrastructure, expose naming conventions, and sometimes
resolve again later.

**Detect wildcard DNS before you trust any brute-force result.** Resolve a
random name that cannot exist, such as `zzq7x-nonexistent.example.com`. If it
answers, the zone resolves everything and your entire brute-force list is
false positives.

Draw the line clearly: querying CT, passive DNS, search engines and archives
never touches the target. Resolving candidate names through a public recursive
resolver is effectively invisible but does generate lookups. Wordlist
brute-forcing is high-volume DNS traffic, visible to the target's DNS provider
and sometimes rate-limited or blocked. HTTP-probing the results with a tool like
`httpx` **is active** — you are connecting to the target's servers. Flag
brute-forcing and probing in your scope notes, and skip them if the engagement
is passive-only.

## What a name pattern implies

Do not treat all discovered hosts as equal. `dev`, `staging`, `uat`, `vpn`,
`legacy`, `old`, and admin panels carry very different risk and follow-up than
`www`. The triage table is in
[reference/name-pattern-triage.md](reference/name-pattern-triage.md).

## Where this goes wrong

- **Bundled and multi-tenant certs.** Shared hosting and CDN certificates put
  unrelated customers on one cert. Always check whether the other names on a
  cert plausibly belong to your target before adopting them.
- **CT is not an asset inventory.** It is a record of certificate requests.
  Hosts behind internal CAs, self-signed certs, origin certificates, or plain
  HTTP are absent. Never report a CT-derived list as complete.
- **Names outlive hosts.** Most historical CT names are dead. A list of 400
  subdomains, unresolved, is a list of 400 unverified claims.
- **Names outlive ownership.** A cert issued for a hostname while the domain
  belonged to a previous owner still shows up under the current owner's query.
  Check `not_before` against the domain's registration and transfer history via
  `who-owns-this-domain`.
- **CNAME'd third parties are not the target's assets.** A hostname the target
  owns pointing at a SaaS tenant is the target's *relationship*, not its
  infrastructure. Do not treat vendor exposure as the target's exposure.
- **Aggregators disagree, and quietly.** Each tool queries a different set of
  sources; free tiers truncate results without telling you. Two tools returning
  the same 50 names may both be reading the same one source.
- **Deliberate poisoning.** Nothing stops anyone from getting a certificate for
  a name they control on a domain that looks like the target's. Typosquats show
  up in CT searches looking like the target's own hosts. Check the registrable
  domain character by character.

## Confidence grading

- **Confirmed asset** — the name resolves, and it is under a domain whose
  registration you have verified, on infrastructure consistent with the target's
  other hosts (same ASN, same cert issuer, same naming convention).
- **Probable asset** — a CT name under a verified target domain that no longer
  resolves, or a name that resolves into a vendor's shared platform. Real name,
  unproven current state.
- **Unconfirmed** — a name from a cert bundled with unrelated customers, a
  brute-force hit in a wildcard-DNS zone, a name on a different registrable
  domain with no corroborating link, or an aggregator result you have not seen
  the underlying cert or DNS answer for.

Record for every host: where the name came from, the cert `id` or passive-DNS
source, the `not_before` date, and the resolution result with a timestamp.

## Worked example

Target: `example-health.test`, scope is passive-only.

crt.sh with `%25.example-health.test` returns 61 unique names. Deduplicating
precert/cert pairs cuts it to 38. Three are interesting immediately:
`vpn-uat.example-health.test`, `jira.internal.example-health.test`, and
`billing-legacy.example-health.test`.

One cert carries 44 names across nine unrelated companies — a managed hosting
provider's bundle. Discard the 43 that are not the target's. That is the dead
end, and it would have inflated the report by more than the real findings.

Resolving the 38: 12 answer. `jira.internal` does not resolve publicly, but its
existence in a cert confirms an internal naming convention and a Jira instance —
worth noting even though there is no host to look at. `vpn-uat` resolves to an
appliance vendor's netblock, which goes to `find-exposed-servers`.

An identity search on the organization name from one of the certs returns two certs
for `examplehealth-group.test`, a domain nobody mentioned in the brief. WHOIS via
`who-owns-this-domain` shows the same registrant organization. That is the pivot
that expanded the engagement.

Grade: 12 resolving hosts **confirmed**, `jira.internal` **probable** (real name,
not publicly reachable), the sibling domain **probable** pending a corporate
filing.

## Pivots

| New selector | Goes to |
|---|---|
| Live hostnames and their IPs | `find-exposed-servers` |
| Sibling and acquired domains | `who-owns-this-domain`, `who-really-owns-it` |
| Organization name from a cert subject | `x-ray-a-company` |
| Dead hostnames with historical content | `read-deleted-pages` |
| Dev/staging hostnames, repo-looking names | `secrets-in-git-history` |
| Indexed files on newly found hosts | `google-like-a-spy` |
| A large host/domain/IP set to structure | `graph-the-network` |

## Legal and ToS notes

Reading CT logs and passive DNS is publishing-by-design: the data exists to be
read. Two limits are real. First, free services like crt.sh are shared
infrastructure — heavy automated querying gets you blocked and is discourteous;
use bounded queries and cache results. Second, DNS brute-forcing and HTTP probing
send traffic to the target and, depending on volume and jurisdiction, can be
argued as unauthorized activity; keep them inside written scope per
[../../ETHICS.md](../../ETHICS.md). Discovering a dangling CNAME or an exposed
staging host obliges you to report it, not to test it.
