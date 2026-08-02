# DNS record types: what each one leaks

Read this as an intelligence table, not a protocol reference. The question is
always "what does the presence, absence, or exact content of this record tell me
about the organization?"

## Address and delegation

| Record | Query | What it tells you | Traps |
|---|---|---|---|
| `A` / `AAAA` | `dig +short d A` | Hosting IP. Feed to ASN lookup and `find-exposed-servers`. | CDN/proxy IPs hide the origin. Multiple As can be round-robin, GeoDNS, or a shared load balancer. IPv6 is often less carefully firewalled than IPv4 — and sometimes points at the real origin when the A record points at a CDN. |
| `CNAME` | `dig d CNAME` | The alias target names the vendor outright: `*.cloudfront.net`, `*.azurewebsites.net`, `*.herokudns.com`, `*.github.io`, `*.myshopify.com`, `*.zendesk.com`, `*.hubspot.net`, `*.pages.dev`. Chains reveal layered vendors. | A CNAME to a deprovisioned SaaS tenant is a subdomain-takeover candidate. Note it, report it, do not claim it. |
| `NS` | `dig +short d NS` | DNS operator, and often the hosting provider by association. Naming conventions leak: `ns1.corp.<company>.net` implies self-hosted DNS on a named network. | Records at the parent (delegation) can disagree with what the child zone itself serves. `dig +trace` shows the delegation path. |
| `SOA` | `dig d SOA +noall +answer` | The `MNAME` is the primary/master nameserver — sometimes an internal or non-advertised host that is not in the NS set. The `RNAME` contact is often a real mailbox (`hostmaster.example.com`) or the provider's. Serials formatted `YYYYMMDDnn` date the last zone edit and the `nn` counts edits that day. | Serial may be a Unix timestamp or an arbitrary counter instead. Provider-managed zones have provider boilerplate in `RNAME`. |
| `PTR` | `dig -x IP +short` | Set by the IP holder. Enterprise and colo blocks carry customer or hostname conventions; cloud PTRs are generated from the address and identify only the platform. | No PTR at all is common and means nothing. PTR and forward record need not agree — verify both directions before treating a PTR as identity. |
| `DNAME` | rare | Whole-subtree aliasing, usually a migration artifact. Points at the old or new estate. | Rarely seen; do not go hunting for it. |

## Mail

| Record | Query | What it tells you |
|---|---|---|
| `MX` | `dig d MX +noall +answer` | The mail path, and therefore the mail-security vendor. Absent MX on a domain that sends mail means send-only or spoof-only. Priorities show primary vs backup, and a low-priority backup at a different vendor is often the older, less-monitored path. |
| `SPF` (in `TXT`) | `dig +short d TXT` | Every `include:` is a third party authorized to send as the org — a public list of SaaS vendors. `ip4:`/`ip6:` mechanisms expose owned netblocks and sometimes the origin server behind a CDN. `-all` vs `~all` vs `?all` shows enforcement maturity. Counting DNS-lookup mechanisms tells you if they are near the 10-lookup limit, a sign of accumulated vendor sprawl. |
| `DKIM` (in `TXT`) | `dig +short sel._domainkey.d TXT` | Requires guessing the selector; see vendor-fingerprints. A `CNAME` at the selector name rather than a `TXT` reveals the vendor even before you read the key. Key length (`p=` value size) is a hygiene signal. An identical public key on two domains means one signer, and is strong same-operator evidence. |
| `DMARC` (in `TXT`) | `dig +short _dmarc.d TXT` | `p=` shows policy (`none` = monitoring only, `reject` = mature). `rua=`/`ruf=` addresses name the DMARC-reporting vendor, and where they are `mailto:` at a third-party domain that vendor is a live relationship. `pct=` below 100 means a staged rollout in progress. A `rua` pointing at a security vendor tells you who to expect on the other side of an incident. |
| `MTA-STS` / `TLS-RPT` | `dig +short _mta-sts.d TXT`, `dig +short _smtp._tls.d TXT` | Presence signals a mature mail team. The policy is fetched over HTTPS from a `mta-sts.<domain>` host — one more hostname for the inventory. `TLS-RPT` `rua` names another reporting vendor. |
| `BIMI` | `dig +short default._bimi.d TXT` | Points at a hosted SVG logo and a verified mark certificate — a brand-controlled URL, and a strong indicator of a serious marketing/mail operation. |

## Certificates, discovery, and service records

| Record | Query | What it tells you |
|---|---|---|
| `CAA` | `dig +short d CAA` | Which CAs are authorized: `issue "letsencrypt.org"` means ACME automation; `digicert.com`, `sectigo.com`, `globalsign.com` mean a commercial procurement relationship; `amazon.com`/`amazontrust.com` means AWS Certificate Manager; `pki.goog` means Google. The `iodef` tag publishes a security contact mailbox or URL. RFC 8657 parameters go further: `accounturi` pins a specific ACME account, and the same `accounturi` on two unrelated domains is strong evidence of one operator; `validationmethods` shows whether they validate by DNS or HTTP. |
| `TXT` (non-mail) | `dig +short d TXT` | Domain-ownership verification tokens for SaaS products. Each one proves the org has (or had) a tenant with that vendor. See vendor-fingerprints. Also occasionally leaks internal notes, ACME `_acme-challenge` leftovers, and hosted-service IDs. |
| `SRV` | `dig d SRV` for `_sip._tls`, `_sipfederationtls._tcp`, `_autodiscover._tcp`, `_xmpp-client._tcp`, `_ldap._tcp` | Names collaboration and directory infrastructure. `_sipfederationtls._tcp` and `_autodiscover._tcp` pointing at Microsoft mean a Microsoft 365 tenant; pointing at self-hosted names give you internal hostnames for free. |
| `_acme-challenge` | `dig +short _acme-challenge.d TXT` | A stale token means DNS-01 ACME automation and, in wildcard setups, tells you the certificate covers names you cannot enumerate from CT. |
| `DS` / `DNSKEY` | `dig d DS`, `dig d DNSKEY` | DNSSEC posture. A signed zone with NSEC (not NSEC3) is enumerable by zone walking — active, so treat accordingly. |
| `HTTPS` / `SVCB` | `dig d HTTPS` | ALPN and, where present, `ipv4hint`/`ipv6hint` and ECH config. Hints can name addresses the A record does not. |
| `NAPTR` | rare | Telephony/ENUM integration. Presence suggests a voice platform worth naming. |

## Absence is data

- No `MX`, but SPF present: the domain sends and does not receive. Common for
  marketing and phishing domains alike.
- No `DMARC`: no visibility into spoofing of the domain. Predicts a
  brand-impersonation problem.
- No `CAA`: any public CA can issue. Also means no `accounturi` pivot.
- No `TXT` at all on an established corporate domain: unusual. Suggests either a
  freshly rebuilt zone or a domain that is not the operational one — look for the
  real one.

## Cross-domain matching, ranked

Strongest to weakest evidence that two domains share an operator:

1. Identical DKIM public key, or identical CAA `accounturi`.
2. Same Microsoft 365 tenant label in the MX target, or same
   provider-assigned nameserver pair.
3. Same unusual TXT verification token value (tokens are per-tenant, so an
   identical token means the same vendor account).
4. Same self-hosted `SOA` `MNAME` or `RNAME` mailbox.
5. Same combination of SPF includes — weak alone, meaningful if the combination
   is unusual.
6. Same dedicated IP or small netblock.
7. Same registrar, same public DNS provider, same shared-hosting IP — near
   worthless on their own.
