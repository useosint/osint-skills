---
name: read-deleted-pages
description: >-
  Recover deleted, edited or historical web content using the Wayback Machine and its CDX API,
  archive.today, Common Crawl and Memento/Timetravel. Use when a page is deleted, changed or
  404s, checking what a site used to say, finding old team or staff pages, prior pricing,
  removed posts, pre-redaction wording or old contact details, enumerating every archived URL
  for a domain, or preserving evidence before it disappears. Applies to litigation and
  evidence preservation, regulatory and disclosure review, due diligence on a company's
  history, and journalism. Reference at useosint.com/skills/read-deleted-pages.

---

# Read deleted pages

Archives work because removal is a decision made after publication. The
beginner's mistake is treating the Wayback Machine as a website you browse: the
calendar UI shows one page at a time, while the CDX API enumerates every URL the
archive ever saw under a host, including paths nobody remembers.

## Which archive first

| Situation | Go to | Why |
|---|---|---|
| A URL that 404s now | Wayback, then archive.today | Different corpora, different removal pressure |
| "What did this site say before X" | Wayback CDX with `collapse=digest` | Gives the dates content changed, not every capture |
| A JS-heavy page or a social post | archive.today | Captures the rendered DOM; Wayback often replays an empty shell |
| Wayback says the URL is excluded | archive.today, then Common Crawl | Neither answers to Wayback's exclusion process |
| Paths and subdomains you don't know about | CDX with `matchType=domain` | It is an enumeration tool, not a lookup tool |
| A URL Wayback never captured | Common Crawl | Independent crawler, different seeds |
| Regional or national-TLD content | A Memento aggregator, then the national archive | Some national archives offer full-text search |
| Evidence you cannot lose | Capture it yourself, then submit to two archives | Nobody else is preserving it for you |

Coverage and removal policy per source:
[reference/archive-comparison.md](reference/archive-comparison.md).

## The CDX API is the actual tool

The CDX server indexes capture records — one row per capture — and lets you
filter, collapse and enumerate them. Every URL a crawler ever saw under a host,
deduplicated:

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=json&fl=original&collapse=urlkey' \
  | jq -r '.[1:][] | .[0]' | sort -u
```

Use `output=json` rather than the default text: it survives URLs containing
spaces and quotes, which the text format mangles. The first JSON row is a header
naming the columns, not a capture — hence the `.[1:]`.

Four parameters do nearly all the work:

- **`matchType`** — `exact`, `prefix`, `host`, or `domain`. `matchType=domain`
  returns the host *and all subdomains*, routinely surfacing staging, legacy and
  internal hosts long gone from DNS. Take them to `find-hidden-subdomains`.
- **`filter=<field>:<regex>`**, invertible with `!` and combinable. Filter to
  `statuscode:200` for captures that returned content, or `!mimetype:text/html`
  to isolate documents, archives and config files.
- **`from`/`to`** take a timestamp prefix at any precision — `from=2019`,
  `from=201903` — so you can bracket the window around a known event.
- **`collapse`** suppresses adjacent rows sharing a field. `collapse=urlkey` is
  the enumeration idiom; `collapse=digest` matters most.

`digest` hashes the captured payload, so `collapse=digest` reduces a page's
history to the captures where content actually *changed*. Four hundred captures
become six rows, and those six dates are the story.

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/about/team&output=json&collapse=digest&fl=timestamp,digest,statuscode'
```

Full parameters, paging, and a ready enumeration pass: [reference/cdx-cookbook.md](reference/cdx-cookbook.md).

## Replay is not the capture

The page at `web.archive.org/web/<timestamp>/<url>` is reconstructed. The
archive injects a toolbar, rewrites links and resource references back into the
archive, and — the part that misleads people — pulls each resource from *its own
nearest capture*, which may be months away from the HTML you asked for. The
rendered page you screenshot may never have existed.

Append `id_` to the timestamp to get the raw archived response with no injection
and no rewriting:

```bash
curl -s 'https://web.archive.org/web/20190412093000id_/http://example.com/pricing' > pricing-2019.html
```

Use `id_` for anything you will parse, hash, diff, or cite. A page that replays
as blank may have been captured fine, so fetch the raw response before
concluding the archive has nothing — but archived JavaScript that called an API
at view time has no data behind it, because the API response was never captured.
Those pages are shells by nature, not by failure.

## What this actually recovers

Pull the raw captures at two dates from the `collapse=digest` list and compare
them as text. The removals are the evidence: a person deleted from a team page
between two dates is a departure with a date range attached, and a `find-anyone`
lead with no remaining reason to be loyal. What surfaces, in practice:

- **Staff and team pages.** The current site lists who is there now; the archive
  lists everyone who ever was, with titles, bios, and often direct email
  addresses from before the org moved to a contact form.
- **Prior pricing and terms** — what was charged, what was promised, and what
  the refund policy said on the date a dispute began. Also removed posts and
  press releases: partnerships, funding or clients both sides stopped mentioning.
- **Old contact details.** Phone numbers, street addresses and named individual
  contacts later replaced by a form. Straight into `whose-number-is-this`.
- **Pre-redaction copy.** Diffing a page published in full against its edited
  successor shows exactly which words somebody paid a lawyer to remove — a very
  strong signal about what matters.
- **Forgotten files** — document paths, backup filenames and admin surfaces
  indexed once and never cleaned up. See `secrets-in-git-history`.
- **The prior owner of a domain.** A domain that changed hands shows a different
  business in its archive history — the fastest way to spot a
  reputation-laundering purchase.

## Preserve it before you look further

Anything you find can be removed, and investigating sometimes causes the
removal. Capture first, analyse second.

Submit the live URL to the Internet Archive's Save Page Now at
`https://web.archive.org/save/` and to archive.today, so two independent
organisations hold a timestamped copy you did not create. Then take your own
record: a WARC preserves the full HTTP exchange including headers, which a
screenshot does not.

```bash
wget --warc-file=evidence-001 --page-requisites --no-parent https://example.com/pricing
sha256sum evidence-001.warc.gz | tee evidence-001.sha256
```

Record the capture time in UTC, the URL exactly as requested, and the hash. A
screenshot alone is weak — trivially forged, no headers. A third-party archive
URL plus your own hashed WARC is strong, because they corroborate each other and
one is outside your control. That is what `write-the-intel-brief` expects.

## Verifying a capture is genuine

Anyone can put content into an archive: both Save Page Now and archive.today
accept arbitrary URLs from anonymous submitters. A capture proves *that URL
served that content to that crawler at that time*, and nothing about who
controlled the URL. The realistic spoofing routes:

- **A forged screenshot of an archive page.** Trivial. Never accept a screenshot
  of an archive; work from the archive URL itself and re-fetch it.
- **Content injected via the URL.** A reflected query parameter, a
  user-generated content path or an open redirect lets someone archive
  attacker-chosen text on a legitimate-looking domain. Read the `original` field
  character by character: anything after `?` or `#`, any unfamiliar path
  segment, any lookalike host.
- **Capture after a domain changed hands.** The domain was the buyer's, not the
  original business's. Check transfer dates against the capture timestamp with
  `who-owns-this-domain`.
- **Selective capture** — a real page up for eleven minutes, archived by the
  person who put it up.

Corroboration, in order of strength: confirm the record exists independently in
the CDX index with `statuscode` 200 and a `digest`; look for adjacent captures
made by the archive's own crawler rather than by on-demand submission, since
crawler captures are much harder to stage; check a second independent archive
near the same date; check consistency with the site's other history. A lone
on-demand capture with no neighbours is an assertion by its submitter.

## Where this goes wrong

- **Absence is not evidence.** No capture means unlinked, robots-blocked, behind
  a login, too obscure to crawl, or removed — not that the page never existed.
  Check two archives before writing "no record".
- **Exclusion looks like absence.** An explicit exclusion notice means somebody
  acted; a plain 404 means nothing. Different facts — note which you got.
- **Retroactive removal.** Wayback has historically applied a site's *current*
  robots.txt to its whole archive history, so a new `Disallow` could pull years
  of captures at once — making an expired-domain purchase plus a restrictive
  robots.txt a cheap way to launder a site's past. The practice has narrowed,
  but go to archive.today and Common Crawl when a history looks too clean.
- **Composite renders.** Mixed-date resources mean the rendered page is a
  reconstruction. Cite the HTML capture timestamp, not "how it looked".
- **Capture time is not publication time.** A page first captured in March may
  have been published in January. The capture bounds the date from above only.
- **Dynamic and personalised content.** The crawler saw one variant — one
  geography, one A/B bucket, logged out. Prices and availability especially.
- **Sparse sampling hides everything.** A page captured twice a year can change
  and revert with no trace; `collapse=digest` shows observed changes, not all
  changes. Timestamps are UTC, and forgetting that breaks a timeline by a day.

## Confidence grading

- **Confirmed** — a crawler-initiated capture with `statuscode:200`, retrieved
  raw with `id_`, on a URL verified as the subject's, corroborated by a second
  archive or by adjacent captures in the same crawl series.
- **Probable** — a single well-formed Wayback capture with no second source, or
  an archive.today capture consistent with the site's other history.
- **Unconfirmed** — an on-demand capture with no neighbours; a URL carrying
  query parameters or user-generated content paths; a screenshot; content read
  from a composite replay rather than the raw response.
- **Rejected** — a capture whose URL was not under the subject's control at that
  date, or one taken after a domain transfer and presented as the prior owner's.

Cite the full archive URL with timestamp, the original URL, the capture time in
UTC, and how you retrieved it. An archive citation without a timestamp is not a
citation.

## Worked example

A supplier's site claims an industry certification. The client wants it verified
before signing.

`collapse=digest` on the certifications page returns nine content changes over
six years. The raw captures either side of the most recent one show the
certification body's name changed — from a recognised accreditor to a similarly
named entity — with no announcement.

The dead end: the accreditor's own register has no live entry either way, and
its archived member lists replay as empty shells. Fetching them with `id_` shows
why — the list was rendered client-side from an API call, so the crawler
captured a page with no data in it. Nothing recoverable there.

CDX enumeration on `matchType=domain` then turns up a staging host holding an
archived PDF of the original certificate. Its metadata carries an expiry date
two years before the current site claims coverage, and
`secrets-in-file-metadata` gets an author name from the same file.

Grade: the wording change **confirmed** — two crawler captures, raw, both read.
The lapse **probable** — one document, no confirmation from the accreditor.

## Pivots

| New selector | Goes to |
|---|---|
| Former staff names, titles, bios | `find-anyone`, `pattern-of-life-from-socials` |
| Email addresses from pre-form contact pages | `what-an-email-reveals` |
| Phone numbers and street addresses | `whose-number-is-this` |
| Subdomains and hosts from CDX enumeration | `find-hidden-subdomains`, `who-owns-this-domain` |
| Archived documents and PDFs | `secrets-in-file-metadata` |
| Archived images | `find-the-original-image`, `geolocate-from-pixels` |
| Forgotten paths and exposed file names | `google-like-a-spy`, `secrets-in-git-history` |
| Prior corporate identity of a domain | `x-ray-a-company`, `who-really-owns-it` |
| A timeline of edits and removals | `write-the-intel-brief`, `graph-the-network` |

## Legal and handling notes

Reading an archive is passive; it touches the archive's servers, not the
target's. Fetching a recovered path against the live site is not passive and
lands in the target's logs — decide deliberately which you are doing.

Archived personal data is still personal data. Content removed under a
right-to-erasure request may persist in archives, and republishing it can create
the liability the removal was meant to extinguish. Weigh the investigative need
against the reason for removal, and minimise per
[../../ETHICS.md](../../ETHICS.md). Reproducing substantial archived content in
a published report is a separate copyright question from using it as evidence.

Bulk retrieval strains a nonprofit's infrastructure: rate-limit enumeration and
raw fetches, and pull the index once rather than repeatedly.
