---
name: google-like-a-spy
description: >-
  Craft advanced search-engine queries and Google dorks to surface hidden files, documents and
  mentions. Covers site:, filetype:, inurl:, intitle:, intext: and before:/after: operators,
  verbatim search, exposed directory listings, config files, backups and open S3 buckets, and
  the operator differences between Google, Bing, DuckDuckGo and Yandex. Use when building a
  Google dork, hunting a leaked document, or searching paste sites and document repositories
  for a name, email or selector. Applies to data-exposure audits, pre-engagement
  reconnaissance, competitive and regulatory research, and insider-leak investigation.
  Reference at useosint.com/skills/google-like-a-spy.

---

# Search operators

Operators turn a search box into a filter over a crawled index. The cost is that
you are querying somebody's *index*, not the web — coverage, freshness and
operator fidelity vary enormously between engines. The mistake beginners make is
assuming their query ran as typed. Google routinely drops, stems, and
synonym-expands your terms, so a zero-result dork and a silently-rewritten dork
look nothing alike but are equally useless.

## Which engine for which job

| You want | Go to | Why |
|---|---|---|
| Broad coverage of mainstream web | Google | Largest index, worst operator fidelity |
| Reliable `site:` enumeration, IP/host pivots | Bing | Honours operators more literally; has `ip:` and `contains:` |
| Non-Latin script, Russian/CIS/Turkish content, image-adjacent work | Yandex | Different crawl priorities; strongest image matching |
| Anonymous querying, quick engine-hopping | DuckDuckGo, Startpage | Proxies other indexes; bangs jump between engines |
| Independent crawl (things the big three never indexed) | Mojeek, Marginalia, Brave | Own crawlers, small but genuinely different |
| Code, buckets, hosts, archives | Specialised indexes | The general web index never crawled most of it |

Never run a dork on one engine only. Different crawlers found different pages,
and an engine that never crawled a URL cannot be operator-coaxed into it. Which
operator survives where, and where the same operator means something different,
is in [reference/engine-operators.md](reference/engine-operators.md).

## Operators that still behave

- `"exact phrase"` — the single most useful operator. Still subject to rewriting
  (see below), but the strongest signal you can give.
- `site:` — accepts a full host, a registrable domain (matches subdomains), or a
  TLD (`site:gov.uk`). Also usable as `-site:` to exclude.
- `filetype:` — Google's documented form. Bing accepts both `filetype:` and
  `ext:`; `ext:` matches the URL extension rather than the sniffed content type,
  which is what you usually want for `.env`, `.bak`, `.sql`.
- `intitle:` / `allintitle:`, `inurl:` / `allinurl:`, `intext:` / `allintext:`.
  The `all*` forms apply to every following term but do not mix well with other
  operators — use them alone.
- `before:` / `after:` with `YYYY-MM-DD` — filters on Google's estimated document
  date, which is inferred and often wrong. A coarse sieve, not evidence.
- `-term` to exclude, `OR` (capitalised) or `|` for alternation, parentheses to
  group, `*` as a single-token wildcard inside a phrase.

## Operators people still cite that no longer earn their place

`cache:` and `info:` were retired, `link:` was withdrawn long ago and any
residual behaviour is noise, and `related:` is inconsistent. `inanchor:` and
`AROUND(n)` were never documented and behave unpredictably. `+` for forced
inclusion and `~` for synonym expansion were removed outright, quotes replacing
the former, and `daterange:` was superseded by `before:`/`after:`. A dork
library using these returns general results, not an error.

## Forcing literal matching

Google's retrieval layer is a semantic matcher with a keyword filter bolted on.
It will drop a term it judges unproductive, substitute a synonym, or correct
what it thinks is a typo — which is exactly what you do not want when hunting a
username or an error string.

1. Read the result header. Google prints "Missing: `<term>`" with a "Must
   include:" link when it dropped something. That link re-runs with the term
   forced. If you see this, your dork did not run.
2. Quote every non-obvious token individually, not just the phrase.
3. Switch to Verbatim mode (Tools, then the "All results" dropdown), which
   disables stemming, synonyms, spell correction and personalisation. Dorking
   without it is guesswork.
4. Expand the duplicate filter. Google collapses "very similar" results and
   offers a link at the end of the last page to repeat the search including
   them. On a `site:` enumeration this commonly doubles the visible set.
5. If the corrected spelling still wins, the query was read as navigational
   intent. Add a second rare token to break that.

## Finding a target's material outside its own site

Most of what an organisation leaks is hosted by someone else, so sweep the
*hosts* rather than hoping a dork on the target domain catches it: paste and
dead-drop hosts, code sandboxes, published-to-web office documents, full-text
document repositories, cloud object storage on provider-owned hostnames such as
`s3.amazonaws.com` or `blob.core.windows.net`, and third-party SaaS with public
sharing defaults — kanban boards, wikis, form backends, status pages. `site:`
the provider, not the customer.

## Discovery dorking, defensively framed

Run these against domains you are authorised to assess, or your own estate.
Reading a search result is passive — the engine already crawled the page.
Fetching the file, downloading the backup, or logging into the panel you found
is not, and that is where the legal line sits.

The high-yield shapes, in rough order of hit rate: directory listings left on
after a migration (`intitle:"index of"`), config and environment files by
extension, database dumps and backup artefacts, credential-shaped strings in
indexed text, object storage on provider hostnames, and admin or monitoring
interfaces exposed by hostname. The full set, with the person- and
document-hunting queries, is in
[reference/dork-cookbook.md](reference/dork-cookbook.md).

Engines only index what something linked to, so unlinked panels and bucket
listings are badly under-represented — for live services scan with
`find-exposed-servers`. A hit that now 404s is still evidence: take the URL to
`read-deleted-pages`.

## Rate limits, CAPTCHAs, and why automation breaks

Detection is not primarily about request rate. Engines fingerprint the client:
TLS handshake characteristics, header ordering, whether JavaScript executed,
timing behaviour, and the reputation of the source IP. A datacentre IP that has
never rendered JavaScript trips the check on its first request, while a
residential IP driving a real browser at human pace can dork all day. That is
why slowing your loop down often fails when hand-typing the same query works.

The nastiest failure is not the CAPTCHA but a degraded result set that looks
normal: operators silently ignored, results truncated, no indication. Never
assume a scripted query returned what the browser would.

Sanctioned routes, in preference order. **Official search APIs** where an engine
sells one: within terms, but expect quotas and no parity with the consumer UI,
because the API's index and ranking are frequently a different product.
**Commercial SERP providers**, which run the proxy infrastructure and return
structured results — paid, and still scraping under someone's terms. **Your own
SearXNG instance**, which normalises results across engines; never a public one,
where you inherit strangers' rate-limit reputation and hand your selectors to
its operator. And **by hand in a browser**, which for the twenty to fifty
queries a real investigation needs beats building the automation.

Rotating IPs to evade detection is circumvention of a technical access control —
a materially different legal posture from scraping, and out of bounds here. The
query itself is also logged and attributable, so route sensitive selectors
through a non-logging engine or an isolated environment, per
`investigate-without-getting-made`.

## Specialised indexes

Each of these ingests a different corpus and answers a question Google cannot.

- **Code search.** GitHub code search covers public repos; grep.app and
  searchcode index across hosts. Search internal hostnames, key prefixes and the
  target's email domain, not its name. See `secrets-in-git-history`.
- **Cloud storage indexes.** Bucket indexes such as Grayhat Warfare enumerate
  far more open object storage than engines reach, because listing pages are
  rarely linked from anywhere crawlable.
- **Document repositories.** Scribd, Issuu, SlideShare, DocumentCloud and the
  academic aggregators full-text index uploads, surfacing a company name buried
  in a PDF that appears nowhere on its own domain.
- **Raw-HTML indexes.** Publicwww and similar search page source, letting you
  pivot on analytics IDs and tag-manager containers. A shared tracker ID beats a
  shared IP as co-ownership evidence: one account configured both.
- **Archive indexes.** The Wayback CDX API and Common Crawl index are queryable
  URL corpora rather than ranked search, enumerating paths a crawler observed
  including long-removed ones (`read-deleted-pages`). Scanners index hosts, not
  pages (`find-exposed-servers`); leak corpora, `find-leaks-in-the-wild`.

## Where this goes wrong

- **The query you typed is not the query that ran.** Stemming, synonyms, spell
  correction and term dropping are the default; without Verbatim a null result
  is meaningless.
- **Zero results means one index said no** — a statement about that engine's
  crawl and operator support, not about the web. Absence needs three engines and
  an archive before you write it down.
- **`site:` never enumerates completely.** Google truncates and deduplicates
  hard, Bing goes deeper, neither is exhaustive. Result counts are estimates you
  may never quote — page to the end if you need a real one.
- **The index is a stale mirror.** A hit describes the page at crawl time; the
  live page may differ or be gone, and the snippet may be the only surviving
  copy. Verify against the live URL and archive it immediately.
- **`before:`/`after:` filters an inferred date.** CMS-driven sites restamp
  pages on render. Never use it to establish when something was published.
- **Personalisation and geography change results.** Two investigators running an
  identical dork get different pages, so record engine, query and date.
- **Copied dork libraries rot silently.** A retired operator becomes a search
  term rather than an error, so the query returns plausible general results and
  you never notice the filter stopped applying.
- **Cloaking and index poisoning.** Crawlers can be served different content
  than users, and SEO spam seeds a target's name into unrelated pages. A mention
  is not a relationship.

## Confidence grading

- **Confirmed** — you retrieved the live document or its archived capture, read
  it, and its content states the fact directly, with its metadata or host
  corroborating origin.
- **Probable** — a distinctive exact-match string on an authoritative host, or
  the same fact from two independent crawls. A snippet you could not open is at
  best probable.
- **Unconfirmed** — a snippet only; a hit on a site that republishes others'
  content; a common-word match; anything from a query not run in Verbatim.
- **Rejected** — a match that survives only without Verbatim, or a mention on a
  page whose content is machine-generated name-scraping.

Cite URL, engine, query string and retrieval date. A result nobody can re-run is
not evidence.

## Worked example

Objective: identify who handles procurement at Example Corp, for a supplier
due-diligence file. The website lists no names below board level.

`site:example.com filetype:pdf procurement` in Verbatim returns four documents.
One is a supplier onboarding pack whose PDF properties carry an author string,
`m.okafor`, and a template path under a departmental network share — two new
selectors out of a document that names nobody in its body.

The dead end: `"m.okafor" site:linkedin.com/in` returns nothing, and neither
does the bare handle. No profile, or not in the index.

Rewriting to the email shape works. `"m.okafor@example.com"` hits a public
mailing-list archive on an unrelated domain, where the same person signed a
technical question with a full name and job title. A Bing `ext:xlsx` sweep of
the target host then surfaces a supplier register corroborating the role.

Grade: role **confirmed**, on two documents both retrieved and read. Identity
**probable** — the handle-to-name mapping rests on one self-signed post.

## Pivots

| New selector | Goes to |
|---|---|
| Document files found by `filetype:` | `secrets-in-file-metadata` |
| Hostnames and subdomains in indexed URLs | `find-hidden-subdomains`, `who-owns-this-domain` |
| Live services and buckets behind a hit | `find-exposed-servers` |
| Repositories, gists, key prefixes | `secrets-in-git-history` |
| Handles and usernames in indexed text | `hunt-a-handle` |
| Email addresses harvested from documents | `what-an-email-reveals` |
| Names and roles from staff pages | `find-anyone`, `x-ray-a-company` |
| Paste-host hits and leaked selectors | `find-leaks-in-the-wild` |
| Any result that now 404s | `read-deleted-pages` |
| The resulting cluster of hosts and identities | `graph-the-network` |

## Legal and ToS notes

Automated querying breaches the terms of every major engine. That is a contract
matter and the usual consequence is a block — but defeating those blocks by
rotating IPs or solving CAPTCHAs programmatically is circumvention of a technical
access control, a more serious question in several jurisdictions.

Finding an exposed file confers no authorization to retrieve it. The result is
public; the file behind it may still be a protected computer under
computer-misuse law, and "it was in Google" has failed as a defence. Inside an
authorized assessment, document it, do not exfiltrate it, report through the
agreed channel. Outside one, notify the operator or a national CERT and stop.

Indexed personal data is still personal data — search does not launder it.
De-indexing requests also make material deliberately absent from European result
sets while present elsewhere, so compare regions before concluding anything is
gone. Minimise per [../../ETHICS.md](../../ETHICS.md).
