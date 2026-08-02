# Reading service banners and scan records

A scan record mixes two kinds of data, and confusing them is the root of most bad
findings.

**Observed:** the port answered, the TLS certificate presented, the response
timing, the address. These are facts about the scan.

**Claimed:** product names, version strings, hostnames in banners, OS
identification. These are what the host said about itself, and they can be
default, edited, backported, or deliberately false.

Everything below is about extracting intelligence from the claimed data while
respecting that it is claimed.

## HTTP

| Field | What to take from it |
|---|---|
| `Server` header | Software family, and often the exact distribution build. `nginx/1.18.0 (Ubuntu)` names the OS as well as the server. Absent or rewritten headers indicate a proxy or deliberate hardening |
| `X-Powered-By`, `X-AspNet-Version`, `X-Generator` | Application stack and version. Frequently left on by accident and more specific than the `Server` header |
| `Set-Cookie` names | Framework identification without any version string: `PHPSESSID` (PHP), `JSESSIONID` (Java), `ASP.NET_SessionId` (.NET), `laravel_session`, `wp-settings-*` (WordPress), `csrftoken` plus `sessionid` (Django) |
| Page title | The fastest appliance identifier. Vendor login portals have distinctive titles, and they are indexed and searchable across the whole internet |
| Default pages | "Welcome to nginx!", the Apache distribution default page, an IIS splash, or a framework setup wizard mean an unconfigured or forgotten host. Setup wizards mean uninitialized, which is a serious finding |
| Redirect `Location` | Redirects routinely leak internal hostnames, load-balancer names, and SSO tenant names |
| `WWW-Authenticate` realm | Device models and hostnames appear in Basic-auth realms |
| Status code | 401 or 403 means something is there and protected; 200 on an admin path means it is not. Both are reportable without touching it |
| Security headers | The presence of CSP, HSTS and frame options is a maturity signal, and CSP `connect-src`/`script-src` lists third-party and internal API hostnames outright |

## TLS certificates

The certificate is observed data, which makes it the most trustworthy field in
the record.

- **Subject CN and SANs** name the host and its siblings. Loop back into
  `find-hidden-subdomains`.
- **A self-signed certificate whose CN is an internal FQDN** is one of the best
  finds available: it names the internal hostname and often the internal domain,
  which is usually the AD domain. Appliances ship these by default.
- **Issuer** tells you procurement and automation. A short-lived ACME cert means
  automated renewal. A commercial CA means a purchasing relationship. An internal
  CA name frequently contains the company or domain name.
- **Validity window.** An expired cert still being served means an unmonitored,
  likely unpatched host. A `not_before` far in the past on a still-valid long cert
  means an old deployment.
- **Certificate serial number** is unique per issuer, so a serial match across
  hosts is near-exact identity — the strongest infrastructure pivot in scan data.
- **Supported protocol versions and ciphers.** Offering only obsolete TLS versions
  dates the stack even when the version string is scrubbed.
- **JARM** fingerprints the TLS stack rather than the certificate. It groups
  appliances and frameworks; it does not identify an organization.

## SSH

The version string is unusually informative: `SSH-2.0-OpenSSH_8.9p1
Ubuntu-3ubuntu0.1` gives the distribution, the package revision, and therefore a
patch window. Distributions that backport fixes keep the upstream version number,
so read it as "this build lineage" rather than "this vulnerability".

The **host key fingerprint** is the real prize. A host key is generated per
machine, so the same key on two hosts means a cloned image, a shared appliance
template, or one operator deploying both. That is a same-operator pivot on par
with a shared certificate.

## Mail

| Service | What the banner gives you |
|---|---|
| SMTP 25/587/465 | The `220` greeting normally contains the server's own FQDN, frequently an internal name not present in public DNS. The software and version follow (Postfix, Exim, Exchange, a gateway appliance) |
| EHLO response in scan data | Advertised extensions show whether STARTTLS and AUTH are offered, which tells you whether it is a submission host or an internal relay |
| IMAP/POP 143/993/110/995 | Server software and version, plus advertised capabilities |
| Exchange / OWA over HTTP | Version-carrying headers and paths let you place the build. Distinguishing on-prem from hybrid matters: hybrid means on-prem servers still exist behind a cloud tenant |

Cross-check every mail hostname against the MX records from
`who-owns-this-domain`. A mail host with no MX pointing at it is usually legacy,
send-only, or forgotten.

## Windows and directory services

- **RDP (3389)** records commonly include NTLM negotiation details, which name the
  NetBIOS computer name, the NetBIOS domain, and the DNS domain. That is internal
  naming and AD domain attribution from a passive record.
- **SMB (445)** exposes the OS version, the host and domain names, and whether
  signing is required.
- **LDAP (389/636)** root-DSE information in scan data spells out the naming
  contexts — the full distinguished name of the directory, i.e. the internal
  domain.

These are the highest-value internal-naming leaks in scan data, and they are
observed by the scanner, not requested by you.

## Databases and data services

| Service | Reading |
|---|---|
| MongoDB, CouchDB | Version, and whether the scanner recorded that it answered without authentication. An answering database on the public internet is the finding |
| Elasticsearch | Cluster name and node names are in the banner, and organizations name clusters after teams, products and environments. Excellent internal vocabulary |
| Redis, Memcached | Historically no authentication by default. Version and uptime |
| MySQL, PostgreSQL, MSSQL | Version string plus, for MySQL, protocol capability flags. Also whether TLS is offered |
| MinIO and S3-compatible endpoints | Bucket and tenant naming, and whether listing is permitted |

Note the exposure and stop. Retrieving a record from an exposed database is
unauthorized access in most jurisdictions, regardless of the absence of a
password.

## Infrastructure, management and devices

- **SNMP (161)** is the most underrated OSINT source in scan data: `sysDescr`
  gives exact model and firmware, `sysName` gives the internal hostname,
  `sysLocation` frequently gives a real street address or room number, and
  `sysContact` gives a staff email or phone number. Feed those to
  `what-an-email-reveals` and `whose-number-is-this`.
- **IPMI, iLO, iDRAC (623 and web)** identify server hardware, and their web
  interfaces expose asset and service tags that tie back to a purchase.
- **Printers and MFPs** publish device names, locations, and sometimes address
  books and user names. Treat anything containing staff names as personal data.
- **Kubernetes and Docker endpoints** leak cluster, namespace and node naming
  through certificates and API metadata even when the API rejects you.
- **VPN and remote-access appliances** are identified from the certificate plus
  the login page title. Precise version determination usually requires probing,
  which is active — so report the product, not a CVE guess.

## Industrial control and cameras

ICS protocols answer with identification fields designed for engineers:
S7comm (102) returns module and plant identification strings, BACnet (47808)
returns device name, description and location, and EtherNet/IP (44818) returns
device name and serial. Those fields routinely name the physical facility, which
is exactly why an exposed ICS device is a safety issue and not just an IT one.

Cameras and RTSP endpoints index real people and sometimes name the site in the
stream title. Never open a feed.

For both categories: document, report to the operator's abuse contact or the
relevant CERT immediately, and do not interact. Some ICS protocols are fragile
enough that a malformed read affects the process.

## Ageing a record

1. Read the scan timestamp first, before the content.
2. Compare against other observations of the same IP and port across dates. Two
   dates showing the same banner is much stronger than one.
3. Compare the certificate's `not_before` to the scan date. A cert issued after
   the scan means the host changed since.
4. Treat version-derived CVE tags as leads. Backported patches keep old version
   strings, so a tagged host may be patched, and an untagged host may not be.
5. Watch for honeypot shape: too many open ports, incompatible services on one
   host, textbook-default banners, research netblocks.

## Report wording

Write: "On <date>, <platform> observed port <n> open on <IP>, presenting a banner
identifying <product/version>, with a certificate for <name>." That sentence is
defensible. "The target is running a vulnerable <product>" is not — you inferred
it from a self-reported string and never verified it, and verifying it would have
required touching the host.
