# Asset inventory schema and passive tech fingerprinting

The inventory is the deliverable. Everything else in the workflow is a means of
filling it in. Build it from the first lookup, because provenance and timestamps
cannot be reconstructed later — and a row without them cannot be defended in a
report.

## Row schema

One row per **asset**, where an asset is a hostname, an IP, or a netblock. Keep
these fields:

| Field | Contents | Why it matters |
|---|---|---|
| `asset` | The hostname, IP, or CIDR | The key |
| `type` | hostname / IP / netblock / third-party tenant | Determines what can be concluded about it |
| `parent` | The apex domain or netblock it belongs under | Lets you group by owner |
| `discovered_via` | CT, passive DNS, aggregator name, archive, scan platform, code repo, brute force | Sets the ceiling on confidence |
| `source_ref` | Cert ID, scan record ID, archive URL, query string | Someone else must be able to re-derive the finding |
| `first_seen` | Earliest date any source shows it existing | Dates the infrastructure |
| `observed_at` | When *you* looked | Every claim is a claim about a moment |
| `resolves` | address / CNAME target / no | The liveness fact |
| `ip` / `asn` / `netblock_owner` | Resolution and RIR data | Attribution backbone |
| `services` | Observed ports with the scan date each came from | Never merge scan dates into one column |
| `tech` | Stack conclusions with the artifact each rests on | Separates evidence from inference |
| `attribution` | confirmed / probable / unconfirmed, plus the reason | The grade a reader will challenge first |
| `priority` | From the name-pattern triage | Turns a list into a report |
| `notes` | Anomalies, contradictions, exposure concerns | Where the actual analysis lives |

Two rules that save reports:

- **Never overwrite. Append.** If a host resolved last week and does not today,
  that change is a finding. Overwriting destroys it.
- **Grade liveness and ownership separately.** "The service is up" and "the
  service belongs to our target" are different claims with different evidence.

## Companion lists

Keep four small side tables next to the inventory. They are where pivots come
from, and they stay useful after the engagement:

1. **Domains** — apex, registrar, creation date, registrant state, nameserver
   pair, whether historical WHOIS was pulled, and the reason it is in scope.
2. **Vendors and tenants** — vendor name, evidence (SPF include, TXT token, MX
   target, CNAME, DKIM selector), tenant label if visible, and whether it has been
   chased for assets yet. This list is your step-7 checklist.
3. **Entities and people** — organization names, registrant names, staff names,
   emails, phone numbers, each with the source and a note on whether it is
   personal data subject to minimization.
4. **Dead ends** — what you checked, why it produced nothing, and when. This
   prevents a second investigator repeating the work and is the difference between
   "we found nothing" and "we did not look".

## Passive tech-stack fingerprinting

Fingerprint from artifacts you already collected, not from fresh requests to the
target. Ranked by how much you can conclude:

| Artifact | Where you get it passively | What it establishes |
|---|---|---|
| TLS certificate issuer and validity | Certificate Transparency, scan platforms | CA relationship, whether issuance is automated, how well maintained the host is |
| CNAME targets | DNS records collected in step 2, passive DNS | The vendor, often with the region and tenant name in the label |
| SPF, DKIM, MX, TXT tokens | Step 2 | The SaaS estate: mail platform, security gateway, CRM, support desk, identity provider, code host |
| HTTP response headers | Scan-platform records, urlscan-style scan results, archived captures | Server software, framework, and sometimes exact build |
| Cookie names | Same sources | Framework family with no version string needed |
| HTML meta generator tags and asset paths | Archived captures | CMS and theme identification; bundle filenames often carry build hashes |
| CSP directives | Headers in scan or archive data | An explicit list of the third-party and internal hostnames the app talks to |
| Favicon hash | Scan platforms | Application or appliance identity, and a cross-host pivot |
| JARM / TLS stack fingerprint | Scan platforms | Appliance and load-balancer families |
| Page titles and login-page text | Scan platforms | Product identification for portals and appliances |
| Job ads, engineering blog posts, status pages, public repos | `google-like-a-spy`, `secrets-in-git-history` | The internal stack in the org's own words, including tools with no network signature |
| Wappalyzer- or BuiltWith-style profilers | Their own datasets | Convenient aggregation, but treat as third-party inference, and note that some profilers fetch the page live when you query interactively |

Two discipline points. Mark every version as **claimed** unless a non-banner
artifact corroborates it — banners are self-reported and distributions backport
patches without changing version strings. And record the artifact next to the
conclusion: "PHP, from a `PHPSESSID` cookie in a scan record dated <date>" is
reviewable; "PHP" is not.

## Completeness worksheet

Before declaring the map done, answer each of these in writing:

- Which sources did I query, and which returned nothing? A source that returned
  nothing is coverage; a source I never tried is a gap.
- Did the last two new sources add any assets?
- Is every candidate name classified as resolving, third-party, or dead?
- Does every resolving host have an ASN and a netblock owner?
- Does every vendor and tenant in the vendor list have a resolution?
- Are there gaps in numbered or regional naming conventions I have not accounted
  for?
- Which apexes discovered mid-engagement did *not* get the full step 2 treatment?
- Is there a wildcard certificate or a wildcard DNS record anywhere in scope? If
  so, say so in the limitations — it caps what enumeration could have found.
- Can the step 1 objective be answered from the inventory alone?

## Reporting shape

Order the brief so a reader who stops after one page still gets the point:

1. Scope and the passive boundary actually observed.
2. The inventory, sorted by priority, not alphabetically.
3. Attribution: which assets are the target's, at what confidence, on what
   evidence.
4. Apparent unintentional exposure, each with the observation date and the
   platform that observed it.
5. Third-party and supply-chain observations, clearly separated from the target's
   own assets.
6. Limitations: wildcard certs, redaction, single-source findings, sources that
   were unavailable, and anything the passive boundary prevented.
7. Recommended next steps, split into passive follow-ups and anything that would
   require authorization.
