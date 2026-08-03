---
name: recon-a-domain-passively
description: >-
  End-to-end passive reconnaissance for a domain, website or IP — builds an asset inventory
  covering registration, DNS, subdomains, infrastructure, tech stack, history and ownership
  without sending a single packet to the target. Use when asked to research or profile a
  domain or website, map what an organisation runs, or investigate a suspicious site without
  alerting its operator. Applies to vendor and third-party risk assessment, attack-surface
  review, M&A technical diligence, phishing and fraud-site investigation, and pre-engagement
  scoping. Reference at useosint.com/skills/recon-a-domain-passively.
disable-model-invocation: true
---

# Recon a domain passively

Turn one domain into a defensible map of an organization's internet-facing estate
plus the owner behind it. The techniques live in other skills; what this workflow
contributes is the **order**, the **inventory**, and the **stopping rule**. Two
failure modes to avoid from the start: enumerating for hours and producing 400
hostnames with no attribution, dates or priority, which is not a map; and drifting
active without noticing, because one probe "just to check if it's up" ends the
passive claim. Decide the passive boundary before step 2, not during it.

## Ordering logic

Each stage feeds the next, and the sequence is cheapest-and-quietest first:

| Order | Stage | Why here |
|---|---|---|
| 1 | Registration and DNS | Defines the perimeter. Without the apex set and the registrant you do not know what is in scope |
| 2 | Name expansion | Archival sources only. Costs nothing, touches nothing, produces the candidate list everything else consumes |
| 3 | Resolution and inventory | Converts names to addresses, which is what infrastructure lookups take as input |
| 4 | Infrastructure and services | Needs stage 3's addresses. Third-party scan data only |
| 5 | Content, history, code, tech stack | Needs hostnames and org names from earlier stages as search terms, and reuses artifacts already collected |
| 6 | Owner attribution | The registrant, tenant and organization names surfaced above are the input |

Run stages 1–5 as a loop, not a line. Every stage produces new selectors that
belong back at stage 1 or 2. Stop looping when the stopping rule in step 7 is met.

## Step 1 — Authorized scope

State in writing: the subject (which domains and netblocks, and which adjacent ones
are explicitly excluded), the objective, the jurisdictions involved, and the
passive boundary — specifically whether DNS resolution, wordlist brute-forcing and
any HTTP contact with the target are permitted. Read
[../../ETHICS.md](../../ETHICS.md). If being noticed matters, set up attribution
hygiene with `investigate-without-getting-made` before querying anything.

**Done when** subject, objective, out-of-bounds list, jurisdiction and passive
boundary are written down, and you know which of the three grey activities you may
perform.

## Step 2 — Registration and DNS baseline

Run `who-owns-this-domain` on every in-scope apex. You want registrar, dates and
status, nameservers, the full record set, and the mail and SaaS fingerprints TXT, MX,
DKIM and CAA give up. Where registration is redacted, pull historical WHOIS in the
same pass.

**Done when** every apex has a registration record with a retrieval timestamp,
a complete record set, and a list of named third-party vendors extracted from its
DNS.

## Step 3 — Expand the name space

Run `find-hidden-subdomains`. Certificate Transparency and passive DNS first, because
they are free, historical and invisible. Feed it the organization names from step 2 as
well as the domains — a certificate-subject search finds sibling and acquired domains
nobody put in the brief.

**Done when** you have a deduplicated candidate hostname list with the source and
first-seen date recorded per name, and any newly discovered apex domains have been
pushed back through step 2.

## Step 4 — Resolve and start the inventory

Classify each candidate: resolves to an address, resolves to a third-party CNAME, or
does not resolve. Build the inventory now rather than at the end — retrofitting
provenance onto a list you already collected is how findings lose their timestamps.
The schema and per-row fields are in
[reference/asset-inventory.md](reference/asset-inventory.md).

**Done when** every candidate is in one of the three buckets with a resolution
timestamp, every resolving host has an IP and an ASN, and every third-party CNAME
is attributed to a named vendor.

## Step 5 — Infrastructure and services

Run `find-exposed-servers` over the addresses and netblocks from step 4. Query scan
platforms only — no port scanning, no service probing. Use the certificate and
favicon pivots to catch hosts that share the target's infrastructure without sharing
its DNS, and note anything that looks unintentionally exposed.

**Done when** each in-scope IP has its observed ports and services with scan
dates, each netblock has an owner from its RIR record, and any infrastructure
found only through cert or favicon pivots has been added to the inventory and
attribution-graded.

## Step 6 — Content, history, code and tech stack

Three sources, in this order:

- `read-deleted-pages` for the estate as it used to be: retired hostnames, old
  staff pages, exposed paths, pre-CDN infrastructure references.
- `google-like-a-spy` for what is indexed now on the hosts you found — documents,
  directory listings, configs, forgotten portals.
- `secrets-in-git-history` for the org names, GitHub organization slugs, cloud
  tenant labels and project IDs surfaced in steps 2 to 5.

If imagery matters — a logo reused across a network of sites, a stock photo posing as
an office — run `find-the-original-image`. Shared images tie sites together when DNS
and registration do not.

Then assemble the tech stack from what you now hold: headers and cookies in archived
copies and scan records, certificate issuers, CNAME targets, JavaScript and asset
paths, CSP directives, favicon hashes, and the SaaS fingerprints from step 2. Where
you need a live page, read a third-party scan of it instead of fetching it.

**Done when** archived and indexed content is reviewed for the top-priority
hostnames, code exposure is documented or ruled out, new hostnames have gone back
through step 4, and the stack is documented per host with the artifact each
conclusion rests on and versions marked claimed rather than verified.

## Step 7 — Decide whether the map is done

Completeness is a judgement, so make it against criteria:

- Two consecutive new sources produced no new assets. Saturation, not exhaustion, is
  the signal.
- Every discovered name is resolved or classified, and every resolving host has an
  owner and an attribution grade.
- Naming conventions have no unexplained gaps: if `web01` and `web03` are in the
  inventory, you have accounted for `web02`.
- Every named vendor and tenant from step 2 has yielded assets or been ruled out.
- The objective from step 1 can be answered from the inventory.

A failing criterion tells you exactly which stage to re-enter.

**Done when** all five pass, or the remaining gaps are written up as stated
limitations rather than left implicit.

## Step 8 — Hand off the owner

If the registrant, certificate subject, RIR reassignment or tenant label resolves
to a legal entity rather than an individual, the domain work is finished and a
corporate investigation starts: hand the entity name and jurisdiction to
`x-ray-a-company`, take registry and beneficial-ownership questions to
`who-really-owns-it`, and send recovered emails to `what-an-email-reveals`. Do not
attempt corporate structure from DNS artifacts — DNS shows operators, not
shareholders.

**Done when** every owner-side selector is routed to the right skill or recorded as
a dead end with the reason.

## Step 9 — Report

Run `write-the-intel-brief`. Lead with the asset inventory, then the attribution
chain, then anything that appears unintentionally exposed, then the limitations
from step 7. **Done when** every claim traces to an inventory row with a source and
timestamp, and every finding carries a confidence grade.

## Where this goes wrong

- **Scope creep through pivots.** Enumeration produces sibling domains endlessly and
  each looks like the next target. If it is not in the step 1 subject list it is a
  finding to report, not a workstream to start.
- **Silent drift into active.** Resolution, brute-forcing and HTTP probing sit on a
  spectrum, and tools blur it — passive collectors have active modes one flag away,
  and one careless flag ends the passive claim for the engagement.
- **Inventory without attribution.** Shared hosting, CDN addresses and bundled certs
  attach assets to your target that are not the target's, and an ungraded inventory
  row is a liability. Relatedly, a vulnerable SaaS tenant the target merely uses is
  a supply-chain finding and must be phrased as one.
- **Stale data presented as current.** Archives, CT and scan records are all
  historical, and undated findings are not findings.
- **Stopping at the first quiet moment.** No new results usually means one source
  saturated, not the estate mapped — which is what step 7 catches.
- **Over-collection.** Staff names from archived pages and SNMP contacts are personal
  data. Collect what the objective needs, nothing more.

## Confidence grading

Grade the **inventory** and the **attribution** separately. A host can be a
confirmed live service and an unconfirmed asset of your target at once, and
conflating the two is the most common reporting error in domain recon.

- **Confirmed asset** — under a domain whose registration you verified, or on a
  netblock reassigned to the target by name, or serving a certificate the target
  demonstrably controls, and corroborated by a second independent source.
- **Probable asset** — one strong infrastructure fingerprint (shared DKIM key,
  same mail tenant label, same provider-assigned nameserver pair, distinctive
  favicon or body string) with nothing contradicting it.
- **Unconfirmed** — shared-hosting or CDN addresses, bundled-certificate names,
  `org:`-only attribution, or an aggregator result whose underlying record you
  have not seen.

Per-technique criteria in the technique skills override these where more specific.

## Worked example

Engagement: a client is acquiring `meridian-freight.test` and wants its
internet-facing estate before signing. Scope: the apex plus any domain the
registrant demonstrably controls. Boundary: resolution allowed, no brute-forcing,
no HTTP contact.

Step 2: five-year-old registration, registrant redacted but country `NL`, a
Microsoft 365 tenant, and TXT tokens for a support desk, an identity provider and
a GitHub organization. That GitHub org name is the highest-value item in the entire
record set and it cost one lookup.

Step 3 returns 74 candidates, and a certificate-subject search surfaces
`meridian-logistics-group.test`, which is not in the brief. Back through step 2:
same M365 tenant label in its MX, so same operator. Included, client notified.

Step 4: 31 resolve, nine of those to third-party CNAMEs — relationships, not
assets. `uat-portal` sits in a small Dutch hosting netblock distinct from
everything else, which makes it the lead of the engagement.

Step 5: that UAT host had 443 and 3306 observed open five weeks earlier. Also
eleven hosts sharing a favicon hash, which looked like a hidden estate until the
hash turned out to belong to a stock CMS theme — the dead end, and exactly the
kind that inflates a report if you skip the check.

Step 6: a public repo in the GitHub org holds a CI config naming two internal
hostnames absent from DNS. They do not resolve; they still matter, because the
acquirer inherits those systems.

Step 7: third consecutive source adds nothing, `web02` accounted for, every vendor
chased. Complete, with one stated gap — the apex wildcard cert means subdomains
issued after it are invisible to CT. Step 8: Dutch registrant country plus the
sibling domain plus the group name in the cert subject point at a holding
structure, so it goes to `x-ray-a-company`.

## Pivots out

| Selector | Goes to |
|---|---|
| Legal entity, group name, jurisdiction | `x-ray-a-company`, `who-really-owns-it` |
| Emails and phone numbers | `what-an-email-reveals`, `whose-number-is-this` |
| Named employees from archives or metadata | `find-anyone` |
| Developer handles from repositories | `hunt-a-handle` |
| Documents pulled from the estate | `secrets-in-file-metadata` |
| Breach exposure for the domain's mailboxes | `what-leaked-about-you` |
| The whole asset and entity set, for structure | `graph-the-network` |

## Legal and ToS notes

Passive collection from third-party datasets is lawful research in most
jurisdictions; the boundary is traffic to the target and access to non-public
systems. Registrant data recovered from historical WHOIS is personal data under
GDPR even though it was once public, so you need a lawful basis and must minimize.
Scan-platform and archive terms restrict bulk redistribution — cite findings, do
not republish datasets. A discovered exposure authorizes a report to the operator
or the relevant CERT and nothing else. And in due diligence, confirm you hold the
client's written authority for the scope you are running: "our client is buying
them" is not authorization from the target.
