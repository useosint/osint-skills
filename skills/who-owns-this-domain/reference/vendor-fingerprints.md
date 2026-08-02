# TXT, SPF, DKIM, MX and CNAME vendor fingerprints

A domain's DNS is an unredacted procurement list. This catalogue maps
commonly-seen values to the vendor behind them.

Two rules before the tables:

1. **The vendor name is usually literally in the hostname.** If you hit an
   unknown `include:` or CNAME target, take its registrable domain and look it
   up — WHOIS plus a certificate-transparency search on that name identifies the
   vendor in under a minute. Do not guess from a partial string.
2. **Verify, don't assume.** Vendors rename hostnames and acquire each other.
   Everything below is a strong prior, not proof. A confirmed hit is one where
   you have read the actual record and checked the target domain's owner.

## SPF `include:` targets

| Include | Vendor | What it implies |
|---|---|---|
| `_spf.google.com` | Google Workspace | Google is the mail platform, or at least a sender |
| `spf.protection.outlook.com` | Microsoft 365 | Microsoft tenant exists; look for the tenant label in MX |
| `sendgrid.net` | SendGrid (Twilio) | Transactional/product email, so there is an application sending mail |
| `servers.mcsv.net` | Mailchimp | Marketing list exists |
| `spf.mandrillapp.com` | Mandrill (Mailchimp transactional) | App-generated mail |
| `amazonses.com` | Amazon SES | AWS-hosted application sending mail |
| `mail.zendesk.com` | Zendesk | Public support desk — a ticketing address to find |
| `_spf.salesforce.com` | Salesforce | CRM in use; likely a Salesforce community/portal too |
| `mktomail.com` | Marketo (Adobe) | Marketing automation, usually with a tracking subdomain |
| `spf.mailjet.com` | Mailjet | Transactional sender |
| `mailgun.org` | Mailgun | Developer-driven mail; often paired with an API subdomain |
| `spf.messagingengine.com` | Fastmail | Small org or privacy-conscious operator |
| `zoho.com` | Zoho | Cost-sensitive org, often outside the US/EU big-vendor default |
| `_spf.atlassian.net` | Atlassian Cloud | Jira/Confluence tenant, commonly seen alongside the Atlassian TXT token |

Also read the non-`include:` mechanisms. `ip4:`/`ip6:` blocks are netblocks the
org sends from — feed them to `find-exposed-servers`, and check whether one of
them is the web origin sitting behind a CDN. `redirect=` to another domain names
the parent organization in group structures. `exists:` mechanisms usually mean a
custom sending platform worth naming.

## MX targets

| MX pattern | Vendor | Notes |
|---|---|---|
| `aspmx.l.google.com`, `alt*.aspmx.l.google.com` | Google Workspace | |
| `<label>.mail.protection.outlook.com` | Microsoft 365 | The `<label>` is the tenant's `onmicrosoft.com` prefix. Two domains with the same label are the same tenant — one of the strongest passive same-owner signals available |
| `*.pphosted.com`, `*.ppe-hosted.com` | Proofpoint | Enterprise mail security in front of the real platform |
| `*.mimecast.com` | Mimecast | Regional prefix indicates the tenant's region |
| `*.iphmx.com` | Cisco Secure Email | |
| `*.messagelabs.com` | Broadcom/Symantec Email Security.cloud | |
| `*.mailcontrol.com` | Forcepoint | |
| `*.ess.barracudanetworks.com` | Barracuda Email Security | |
| `mx.zoho.com`, `mx2.zoho.com` | Zoho Mail | |
| `*.secureserver.net` | GoDaddy | Usually a small business on a bundled plan |
| `*.emailsrvr.com` | Rackspace Email | |
| `mail.protonmail.ch`, `mailsec.protonmail.ch` | Proton Mail | Deliberate privacy choice; note it |
| `*.messagingengine.com` | Fastmail | |
| `*.improvmx.com`, `*.forwardemail.net` | Forwarding-only services | One person or a placeholder domain, not a real mail estate |

A security gateway MX in front of a platform is the normal enterprise pattern.
The platform underneath is then identifiable from SPF and DKIM rather than MX.

## DKIM selectors worth trying

DKIM requires knowing the selector, so try the vendor defaults. A `CNAME` at the
selector name is as informative as the key itself, and its target names the
vendor.

| Selector | Vendor |
|---|---|
| `google` | Google Workspace |
| `selector1`, `selector2` | Microsoft 365 — the CNAME target embeds the `onmicrosoft.com` tenant name, which is the pivot you actually want |
| `k1` (CNAME into `dkim.mcsv.net`) | Mailchimp |
| `s1`, `s2` (CNAME into `sendgrid.net`) | SendGrid |
| `pm` (CNAME into `mtasv.net`) | Postmark |
| `zendesk1`, `zendesk2` | Zendesk |
| `mandrill` | Mandrill |
| `protonmail`, `protonmail2`, `protonmail3` | Proton Mail |
| `fm1`, `fm2`, `fm3` (CNAME into `fmhosted.com`) | Fastmail |
| `hs1`, `hs2` with a numeric suffix | HubSpot |
| a long random token (CNAME into `dkim.amazonses.com`) | Amazon SES — three such records is the standard SES setup |
| `default`, `mail`, `dkim` | Self-hosted signer defaults. Self-hosted DKIM means self-hosted mail, which means a mail server to find |

An **identical DKIM public key on two domains** means one signing
configuration. That is same-operator evidence, not coincidence.

## TXT verification tokens

Each token proves the org has, or had, an account with that vendor.

| Prefix / location | Vendor | Follow-up |
|---|---|---|
| `google-site-verification=` | Google Search Console / Workspace | Multiple distinct tokens mean multiple people or agencies have verified the domain |
| `MS=ms…` | Microsoft 365 tenant | Corroborate with the MX tenant label |
| `_amazonses.<domain>` TXT | Amazon SES | AWS presence |
| `facebook-domain-verification=` | Meta Business Manager | Ad account exists; pivot to the org's Meta pages |
| `apple-domain-verification=` | Apple Business/services | |
| `atlassian-domain-verification=` | Atlassian Cloud | Look for a `<name>.atlassian.net` tenant |
| `slack-domain-verification=` | Slack | Workspace exists; the workspace name is often the org slug |
| `docusign=` | DocuSign | Contract workflow |
| `adobe-idp-site-verification=` | Adobe federated ID | SSO in place, so there is an IdP to identify |
| `dropbox-domain-verification=` | Dropbox Business | |
| `globalsign-domain-verification=` | GlobalSign | Cert procurement relationship |
| `have-i-been-pwned-verification=` | HIBP domain search | Someone in security is monitoring breaches — pair with `what-leaked-about-you` |
| `detectify-verification=` | Detectify | They run external attack-surface scanning; expect a mature security posture |
| `keybase-site-verification=` | Keybase | Usually an individual, not a company |
| `brave-ledger-verification=` | Brave Rewards | Creator/publisher, usually a small site |
| `yandex-verification:` | Yandex Webmaster | Suggests a Russian-language audience or market |
| `firebase=` | Firebase project | The value is the project ID — feed it to `secrets-in-git-history` |
| `_github-challenge-<org>.<domain>` TXT | GitHub organization verification | **The record name contains the GitHub org name.** Straight into `secrets-in-git-history` |

Tokens are per-tenant values. The **same token value on two domains** means the
same vendor account, which is a strong same-owner signal.

## DMARC `rua` / `ruf` destinations

The reporting address names the DMARC vendor, and by extension part of the
security stack.

| Destination domain | Vendor |
|---|---|
| `dmarcian.com`, `ag.dmarcian.com` | dmarcian |
| `vali.email` | Valimail |
| `rep.dmarcanalyzer.com` | DMARC Analyzer (Mimecast) |
| `emaildefense.proofpoint.com` | Proofpoint Email Fraud Defense |
| `dmarc.report-uri.com` | Report URI |
| `ondmarc.redsift.com` | OnDMARC (Red Sift) |
| `dmarc.postmarkapp.com` | Postmark DMARC monitoring |
| a mailbox at the org's own domain | In-house processing, or nobody is reading them |

A `rua` at an MSSP or consultancy domain rather than a product vendor tells you
who runs their security operations. That is a supply-chain fact worth reporting.

## CNAME targets

| Target pattern | Vendor / meaning |
|---|---|
| `*.cloudfront.net` | AWS CloudFront |
| `*.elb.amazonaws.com`, `*.compute.amazonaws.com` | AWS load balancer / EC2 — the hostname encodes the region, and EC2 names encode the IP |
| `*.awsapps.com` | AWS-hosted apps; the label is often the account alias |
| `*.azurewebsites.net`, `*.azureedge.net`, `*.trafficmanager.net`, `*.cloudapp.azure.com`, `*.blob.core.windows.net` | Azure, with region and resource name in the label |
| `ghs.googlehosted.com`, `*.googleusercontent.com` | Google-hosted services |
| `*.herokudns.com`, `*.herokuapp.com` | Heroku |
| `*.netlify.app`, `cname.vercel-dns.com`, `*.pages.dev`, `*.workers.dev`, `*.github.io` | Developer-platform hosting — implies the site is in a public-ish repo. Try `secrets-in-git-history` |
| `*.edgekey.net`, `*.edgesuite.net`, `*.akadns.net` | Akamai |
| `*.fastly.net`, `*.b-cdn.net`, `*.incapdns.net` | Fastly, Bunny, Imperva |
| `*.myshopify.com`, `*.squarespace.com`, `*.wixdns.net`, `*.webflow.io`, `*.wpengine.com` | Hosted site builders / managed WordPress |
| `*.zendesk.com`, `*.freshdesk.com`, `stspg-customer.com`, `*.hs-sites.com`, `*.gitbook.io`, `*.readthedocs.io` | Support desk, status page, marketing, docs — each is a public content surface to read |
| `*.okta.com`, `*.onelogin.com` | Identity provider; the label is usually the org's tenant name |

A CNAME pointing at a SaaS tenant that no longer exists is a subdomain-takeover
candidate. Record it and report it through the abuse contact. Registering the
dangling name yourself is not passive research.

## Nameserver fingerprints

| NS pattern | Operator |
|---|---|
| `*.awsdns-##.com/.net/.org/.co.uk` | Route 53 (a four-name set across four TLDs) |
| `<firstname>.ns.cloudflare.com` | Cloudflare. **The pair is assigned per account**, so the same pair across domains implies one Cloudflare account |
| `ns1-##.azure-dns.com/.net/.org/.info` | Azure DNS |
| `ns-cloud-<a-e>#.googledomains.com` | Google Cloud DNS |
| `dns#.p##.nsone.net` | NS1 |
| `*.akam.net` | Akamai Edge DNS |
| `*.ultradns.*` | Vercara/Neustar UltraDNS |
| `*.dynect.net` | Oracle Dyn |
| `*.dnsmadeeasy.com` | DNS Made Easy |
| `*.domaincontrol.com` | GoDaddy |
| `*.registrar-servers.com` | Namecheap |
| `*.name-services.com` | Enom/Tucows ecosystem |
| `*.sedoparking.com`, `*.bodis.com`, `*.above.com`, `*.parklogic.com` | Parked or monetized. No owner infrastructure behind it — go to historical records instead |

Registrar-default nameservers mean the domain is probably not in active
operational use. Cloud DNS or a dedicated provider means someone is running it
deliberately, and the account-level fingerprints above become available.
