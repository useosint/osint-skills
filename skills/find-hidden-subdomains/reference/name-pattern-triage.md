# Triaging a discovered hostname by its name

A hostname is a claim about purpose. Use the label to decide what the host
probably is, what its existence proves about the organization, and what to do
next. None of this is a licence to connect to anything — the triage output is a
priority order for *passive* follow-up and for what you flag in the report.

## Environments

| Labels | Reading | Follow-up |
|---|---|---|
| `dev`, `test`, `qa`, `uat`, `stg`, `staging`, `preprod`, `sandbox`, `demo`, `beta`, `canary` | A non-production copy of a production system, usually with weaker auth, verbose errors, real data copied down, and nobody watching the logs | Highest-value passive target. Check archives for indexed pages, and check `secrets-in-git-history` for the config that names it |
| `local`, `localhost`, `127`-style names, `*.internal.<domain>` | A name intended to resolve only inside the network, leaked because someone requested a public cert for it | Proves an internal naming convention and often an internal CA gap. The host itself is usually unreachable — the value is the convention |
| Random hex or PR-number labels, `pr-1234`, `deploy-<hash>` | Ephemeral preview deployments from a CI platform | Tells you which CI/hosting platform they use and that per-PR environments exist. Individual hosts are usually long gone |
| `blue`, `green`, `a`/`b`, `v2`, `new`, `next` | Deployment strategy or a migration in flight | The old side of a migration is the neglected side |

## Remote access and network edge

| Labels | Reading | Follow-up |
|---|---|---|
| `vpn`, `sslvpn`, `remote`, `access`, `gw`, `gateway`, `fw` | Perimeter appliance. Its vendor is usually identifiable from the TLS certificate and the login page title in scan data | Report as an authentication surface. Identify the product via `find-exposed-servers`; do not attempt credentials, ever |
| `citrix`, `xenapp`, `rdp`, `rds`, `ts`, `anyconnect`, `pulse`, `globalprotect` | Names the specific remote-access product, which in turn tells you the shop: Citrix and RDS mean a Windows estate | Product identification is the finding. Version identification requires scan data, not probing |
| `jump`, `bastion`, `ssh`, `mgmt`, `oob`, `ipmi`, `idrac`, `ilo` | Administrative and out-of-band management. These should never be internet-facing | If scan data shows them exposed, that is a serious finding to report immediately through the abuse contact |

## Mail and collaboration

| Labels | Reading | Follow-up |
|---|---|---|
| `mail`, `smtp`, `imap`, `pop`, `mx`, `mta`, `relay`, `webmail` | Self-hosted mail, which means a mail server and an SMTP banner to read in scan data | Cross-check against MX in `who-owns-this-domain` — a mail hostname with no MX pointing at it is often a legacy or send-only host |
| `owa`, `exchange`, `autodiscover`, `lyncdiscover`, `sip`, `mailgate` | On-premises Microsoft messaging, or a hybrid deployment | `autodiscover` plus a Microsoft 365 tenant means hybrid, which means on-prem servers still exist |
| `intranet`, `portal`, `sharepoint`, `wiki`, `confluence`, `teams` | Internal collaboration. Frequently indexed by accident | Search archives and `google-like-a-spy` for indexed internal pages |

## Administration and infrastructure

| Labels | Reading | Follow-up |
|---|---|---|
| `admin`, `manage`, `console`, `dashboard`, `panel`, `cpanel`, `whm`, `plesk`, `webmin` | Management interface. Hosting control panels also tell you the hosting model | Report exposure. Never authenticate |
| `phpmyadmin`, `pma`, `adminer`, `db`, `mysql`, `postgres`, `mongo`, `redis`, `elastic` | Data tier, named in DNS, which is itself a design smell | Check `find-exposed-servers` for whether the port answers. An unauthenticated database is a report-now finding |
| `grafana`, `kibana`, `prometheus`, `zabbix`, `nagios`, `splunk`, `metrics`, `logs`, `status` | Monitoring. Dashboards leak internal hostnames, service topology and headcount-shaped detail even when read-only | Monitoring hostname lists are the best free internal asset inventory you will find |
| `jenkins`, `gitlab`, `git`, `svn`, `nexus`, `artifactory`, `sonar`, `harbor`, `registry`, `argocd`, `vault` | The build and supply chain. Naming these publicly means the pipeline has a public face | Straight to `secrets-in-git-history`. Artifact registries and CI logs are where credentials leak |
| `k8s`, `ingress`, `rancher`, `openshift`, `consul`, `etcd`, `nomad` | Container platform. Implies a cluster, and cluster ingress naming conventions to enumerate | Convention discovery: if `ingress-a` exists, so do siblings |

## Identity

| Labels | Reading | Follow-up |
|---|---|---|
| `sso`, `auth`, `login`, `accounts`, `idp`, `adfs`, `keycloak`, `okta`, `oauth`, `id` | The identity provider, and a CNAME here usually names the vendor and the tenant | Tenant name is a high-value selector. Feed the vendor tenant label to `who-owns-this-domain` for cross-domain matching |
| `ldap`, `dc`, `ad`, `radius`, `kerberos` | Directory services named publicly. Almost always a leak rather than an intentional exposure | Note the domain naming convention — it often reveals the internal AD domain name |

## APIs and application surfaces

| Labels | Reading | Follow-up |
|---|---|---|
| `api`, `api-v1`, `graphql`, `rest`, `gateway`, `ws`, `mqtt`, `grpc` | Programmatic surface. Versioned names imply older versions still running | `api-v1` alongside `api-v3` is a strong lead: old versions rarely get the new auth controls |
| `cdn`, `assets`, `static`, `media`, `img`, `files`, `downloads`, `share`, `docs` | Content delivery and file storage, often a bucket behind a CNAME | The CNAME target names the storage provider. Publicly listable storage is a common real finding |
| `ftp`, `sftp`, `backup`, `nas`, `archive`, `dump` | File transfer and backups. Highest-consequence category if exposed | Report immediately if scan data shows it open. Do not connect |
| `shop`, `pay`, `billing`, `checkout`, `invoice` | Payment flow, which implies compliance scope and a payment vendor | Vendor identification via CNAME and CSP; useful for supply-chain mapping |
| `careers`, `jobs`, `support`, `help`, `blog`, `status`, `investors` | Third-party SaaS with the target's branding | Read the content — job ads name internal tooling, status pages name internal services |

## Legacy and time markers

| Labels | Reading |
|---|---|
| `old`, `legacy`, `deprecated`, `bak`, `tmp`, `temp`, `copy`, `test2` | Someone kept it "just in case". Unpatched by definition |
| A year (`2019`, `fy21`), a campaign name, an event name | Time-boxed project infrastructure, abandoned after the date passed |
| `v1` where `v2` or `v3` exists | The older surface is still routable and rarely reviewed |

## Structure and convention signals

- **Numbered hosts** (`web01`, `node3`, `app-02`) mean a sequence. If `01` and
  `03` exist, `02` almost certainly does — but confirm it, don't assume it, and
  remember a wildcard-DNS zone will happily "confirm" anything.
- **Geographic and datacenter codes** (`eu`, `apac`, `lon`, `fra`, `nyc`, `dc1`,
  `rack4`) map the physical estate and often the legal entities. Country codes
  hint at where subsidiaries and data-processing sit — useful input to
  `x-ray-a-company`.
- **Personal names or initials** as labels mean per-person hosts or someone's
  experiment. Treat as personal data, minimize, and think hard about whether it
  belongs in the report at all.
- **Product codenames** that appear in no public marketing are a genuine find:
  unannounced products, acquisitions in progress, or internal project names that
  make excellent search terms elsewhere.
- **Inconsistent conventions** across a domain usually mean an acquisition. Two
  naming styles, two former IT teams.

## Priority order for follow-up

1. Anything suggesting exposed data or management: databases, backups,
   out-of-band management, admin panels, file shares.
2. Non-production environments of production systems.
3. Remote-access and identity infrastructure — for identification and reporting,
   not testing.
4. Legacy and versioned surfaces.
5. Monitoring and CI, for the internal inventory they leak.
6. Everything else, as inventory.

The output of this triage belongs in the asset inventory with a one-line reason
for its priority. A flat list of 200 hostnames is not a finding; a ranked list of
eight with reasons is.
