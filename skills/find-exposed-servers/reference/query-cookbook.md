# Shodan / Censys / FOFA query cookbook

Same intent, three query languages. Shodan is `filter:value` with implicit AND.
Censys is field-path syntax over a host document with explicit `and`/`or`/`not`.
FOFA is `field="value"` with `&&` and `||`, and its API takes the query
base64-encoded.

Field names and available filters change over time and by subscription tier —
check the platform's own filter reference before assuming a query failed for a
reason other than syntax.

## Core lookups

| Intent | Shodan | Censys | FOFA |
|---|---|---|---|
| One IP | `shodan host 203.0.113.10` | `ip: 203.0.113.10` | `ip="203.0.113.10"` |
| A netblock | `net:203.0.113.0/24` | `ip: 203.0.113.0/24` | `ip="203.0.113.0/24"` |
| An ASN | `asn:AS64500` | `autonomous_system.asn: 64500` | `asn="64500"` |
| A port | `port:8443` | `services.port: 8443` | `port="8443"` |
| A hostname | `hostname:example.com` | `dns.names: example.com` | `host="example.com"` |
| A country | `country:DE` | `location.country_code: DE` | `country="DE"` |
| Network owner string | `org:"Example Corp"` | `autonomous_system.name: "Example Corp"` | `org="Example Corp"` |
| Page title | `http.title:"Login"` | `services.http.response.html_title: "Login"` | `title="Login"` |
| Text in the response body | `http.html:"unique-string"` | `services.banner: "unique-string"` | `body="unique-string"` |
| Cert common name | `ssl.cert.subject.CN:example.com` | `services.tls.certificates.leaf_data.subject.common_name: example.com` | `cert="example.com"` |
| Cert issuer | `ssl.cert.issuer.CN:"R3"` | `services.tls.certificates.leaf_data.issuer.organization: "Let's Encrypt"` | — |
| Favicon hash | `http.favicon.hash:-123456789` | — | `icon_hash="-123456789"` |
| Named product | `product:"MongoDB"` | `services.software.product: MongoDB` | `app="MongoDB"` |
| Service protocol | `port:22` | `services.service_name: SSH` | `protocol="ssh"` |
| JARM | `ssl.jarm:<hash>` | `services.jarm.fingerprint: <hash>` | — |

Censys also carries curated `labels` on host records (login pages, remote access,
databases and similar), which is often a faster route to a category than guessing
ports. ZoomEye and Netlas cover the same ground again with their own field names —
ZoomEye uses `app:`, `title:`, `cidr:`; Netlas uses Elasticsearch-style field
paths. Worth a pass when the big two return nothing.

## Recipes

**Profile a netblock before touching individual hosts.**

```bash
shodan count 'net:203.0.113.0/24'                        # free, no result credits
shodan stats --facets port,product,org 'net:203.0.113.0/24'
```

Faceting first tells you whether you are looking at a web farm, a mail cluster or
a mixed corporate range, and it costs almost nothing.

**Everything serving the target's certificate.**

```
ssl.cert.subject.CN:example.com
```

Censys equivalent, then read `autonomous_system` on each hit. Hosts outside the
CDN's ASNs are origin candidates.

**Origin hunting: the cert, but not on the CDN.**

```
ssl.cert.subject.CN:example.com -asn:AS13335
http.html:"unique-build-hash-from-their-page" -asn:AS13335
http.favicon.hash:-123456789 -asn:AS13335
```

Exclude the proxy and CDN networks the target actually uses. Cloudflare is
AS13335; Fastly AS54113; Akamai AS20940; Amazon AS16509 and AS14618; Google
AS15169; Microsoft AS8075. Verify current ASNs rather than trusting a list —
providers add and retire them. Remember the confirmation step is active and needs
authorization.

**Find every instance of one appliance or portal.** Take the favicon hash from a
known host and search it alone. Then narrow by the org's ASNs. This finds the
regional and forgotten copies that share no DNS relationship with the main site.

**Time-bound a claim.**

```
net:203.0.113.0/24 after:01/01/2024
```

Shodan's `before:`/`after:` accept `dd/mm/yyyy`. Use them to answer "was this
still open recently" rather than reporting an ancient record as current.

**Bulk collection without burning query credits repeatedly.**

```bash
shodan download estate.json.gz 'asn:AS64500'
shodan parse --fields ip_str,port,product,hostnames estate.json.gz > estate.tsv
```

Download once, parse offline as many times as you need.

**Cheap single-IP enrichment with no key.**

```bash
curl -s https://internetdb.shodan.io/203.0.113.10 | jq '.ports, .hostnames, .cpes, .vulns'
```

**Subdomains from Shodan's DNS data.**

```bash
shodan domain example.com
```

Returns DNS records and known subdomains — a useful cross-check against
`find-hidden-subdomains`.

## Exposure hunts by port

Combine with `net:` or `asn:` scoped to your target. Never connect to what you
find; the port and banner are the finding.

| Looking for | Ports | Notes |
|---|---|---|
| Document databases | 27017 (MongoDB), 5984 (CouchDB), 9200 and 9300 (Elasticsearch) | Elasticsearch cluster names in the banner are frequently the org's project names |
| Relational databases | 3306 (MySQL), 5432 (PostgreSQL), 1433 (MSSQL), 1521 (Oracle) | An internet-facing database port is a finding regardless of authentication |
| Caches and queues | 6379 (Redis), 11211 (Memcached), 2181 (ZooKeeper), 5672 (AMQP), 1883 (MQTT) | Historically unauthenticated by default. MQTT topic names leak business logic |
| Container and orchestration | 2375 and 2376 (Docker), 6443 and 10250 (Kubernetes), 2379 (etcd) | An exposed Docker API or kubelet is critical. Cluster certificate names leak node naming |
| Admin and monitoring | 3000 (Grafana), 5601 (Kibana), 9090 (Prometheus), 8080 (Jenkins and others), 9000 (MinIO, Portainer) | Read-only dashboards still leak internal topology |
| Remote access | 3389 (RDP), 5900 (VNC), 23 (Telnet), 22 (SSH) | RDP records often include NTLM details naming the machine and AD domain |
| Windows networking | 445 (SMB), 139, 389 and 636 (LDAP), 88 (Kerberos) | LDAP naming contexts spell out the internal AD domain |
| File transfer and shares | 21 (FTP), 873 (rsync), 2049 (NFS) | Highest-consequence category if writable |
| Management planes | 623 (IPMI), 161 (SNMP) | SNMP `sysLocation` and `sysContact` leak physical addresses and staff contacts |
| Industrial control | 502 (Modbus), 102 (S7comm), 47808 (BACnet), 20000 (DNP3), 44818 (EtherNet/IP) | Identification fields name plants and facilities. Observe only, report urgently, never interact |
| Cameras and media | 554 (RTSP), 80 and 8000 on camera products | Feeds contain identifiable people. Do not view; report |

## Hygiene

- `count` and faceted `stats` are cheap; result-returning searches are metered.
  Shape the query with counts first.
- Pin every finding to the platform, the exact query, the record's scan
  timestamp, and the IP and port. A screenshot of a search UI is not evidence.
- When two platforms disagree, record both. Disagreement usually means the
  service changed between scans, which is itself worth reporting.
- Shodan can submit an active scan and can run monitoring alerts on address
  space. Both are out of scope for passive work — submitting a scan sends packets
  to the target.
