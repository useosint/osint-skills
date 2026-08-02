# Wayback CDX query cookbook

The CDX server is an index over capture records, not a search engine. One row
per capture, queryable by URL pattern, filterable by field, and collapsible.
Learn it properly and it becomes the fastest site-structure enumeration tool you
have — including paths that were never linked from anywhere and no longer exist.

Base endpoint:

```
http://web.archive.org/cdx/search/cdx
```

## The fields

Every capture record carries seven fields, addressable by name in `fl=`:

| Field | Meaning |
|---|---|
| `urlkey` | Canonicalised, SURT-form URL. Used for sorting and for `collapse=urlkey` |
| `timestamp` | Capture time, `YYYYMMDDhhmmss`, UTC. Goes straight into a replay URL |
| `original` | The URL as requested at capture time |
| `mimetype` | Content type recorded at capture. `warc/revisit` marks a dedupe record |
| `statuscode` | HTTP status the origin returned. Blank on revisit records |
| `digest` | Base32 SHA-1 of the response payload. Identical digest means byte-identical content |
| `length` | Compressed record size |

`digest` is the field people ignore and it is the most useful one. It turns
change detection into string comparison — no fetching, no diffing.

## Basic enumeration

Every capture of one URL, as JSON:

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com&output=json'
```

The first row of JSON output is a header row naming the columns, not data. Skip
it or your parser will treat the field names as a capture.

Every URL ever captured under a host, deduplicated to one row per URL:

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=json&fl=original&collapse=urlkey' \
  | jq -r '.[1:][] | .[0]' | sort -u
```

`matchType` controls the shape of the URL match, and setting it explicitly is
clearer than relying on wildcards:

- `matchType=exact` — that URL only. The default when no wildcard is present.
- `matchType=prefix` — everything under that path. Equivalent to `url=host/path/*`.
- `matchType=host` — every URL on that exact host.
- `matchType=domain` — the host and all of its subdomains. Equivalent to
  `url=*.example.com`.

`matchType=domain` is the one to reach for on a first pass. It enumerates
subdomains the archive observed, which frequently includes staging, legacy and
internal-facing hosts that never appeared in DNS by the time you looked. Feed
the result into `find-hidden-subdomains` to check which still resolve.

## Filtering

`filter=<field>:<regex>` keeps matching rows. Prefix with `!` to invert. Multiple
`filter` parameters combine with AND.

```bash
# Captures that actually returned content
filter=statuscode:200

# Everything except the noise
filter=!statuscode:(404|301|302)

# Documents only
filter=mimetype:application/pdf

# Anything not HTML — usually where the interesting files are
filter=!mimetype:text/html

# Path-based, on the canonicalised key
filter=urlkey:.*admin.*
```

Two things bite here. `statuscode` is empty on `warc/revisit` records, so a
`filter=statuscode:200` silently drops the deduplicated captures of unchanged
pages — which is most of them on a frequently-crawled site. And the regex is
applied to the whole field value, so anchor it or accept substring behaviour.

## Time windows

`from` and `to` take a timestamp prefix at any precision: `from=2019` means from
the start of that year, `from=201903` from the start of that month.

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/pricing&output=json&from=2018&to=2021'
```

Use this to bracket an event. If you know a claim was removed some time after a
regulatory filing, window the captures around the filing date and you cut a
thousand rows down to a dozen.

## Collapsing

`collapse=<field>` suppresses *adjacent* rows sharing that field value. Adjacent
matters: the records are sorted by urlkey then timestamp, so collapsing works
within a URL's chronological run, not globally.

```bash
# One row per unique URL — the enumeration idiom
collapse=urlkey

# One row per content change. The single most useful parameter here
collapse=digest

# One capture per day; :N takes the first N characters of the timestamp
collapse=timestamp:8
```

`collapse=digest` is how you find *when a page changed* without downloading
anything. Every surviving row is a capture whose content differed from the one
before it. On a page with four hundred captures you typically get five or six
rows, and those are the dates worth opening.

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/about/team&output=json&collapse=digest&fl=timestamp,digest,statuscode'
```

## Paging large result sets

Two mechanisms exist and they are not interchangeable.

`limit=N` caps rows; a negative value returns the last N, which is the quick way
to get the most recent captures. Combined with `showResumeKey=true`, the
response ends with a resume key you pass back as `resumeKey=` to continue.

For host- and domain-wide queries there is a separate paged interface:
`showNumPages=true` returns the number of pages available, then `page=N` walks
them. This is the right approach for a large site — a single unpaged
domain-match query on a big host will time out or truncate.

## Turning records into fetchable URLs

Replay URL format:

```
https://web.archive.org/web/<timestamp>/<original-url>
```

Append a modifier to the timestamp to change what you get back:

- `id_` — the raw archived response, unmodified. No injected banner, no
  rewritten links, no toolbar. **This is the one you want** for anything you
  will parse, hash, diff, or cite as evidence.
- `if_` — the page without the toolbar but with link rewriting intact.
- `im_` — the raw bytes of an image capture.

```bash
curl -s 'https://web.archive.org/web/20190412093000id_/http://example.com/pricing' > pricing-2019.html
```

Building fetch URLs straight from a CDX enumeration:

```bash
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=json&fl=timestamp,original&filter=mimetype:application/pdf&collapse=urlkey' \
  | jq -r '.[1:][] | "https://web.archive.org/web/\(.[0])id_/\(.[1])"'
```

Two other endpoints are worth knowing. The availability API answers "is there a
capture near this date" in one small JSON object, which is cheaper than a CDX
query when you only need the nearest snapshot:

```bash
curl -s 'https://archive.org/wayback/available?url=example.com&timestamp=20200101'
```

And Wayback exposes a Memento TimeMap, which is the standards-based way to list
captures and lets the same client code work against any Memento-compliant
archive:

```bash
curl -s 'https://web.archive.org/web/timemap/link/http://example.com/'
```

## Common Crawl

A different corpus with the same query idiom. Common Crawl publishes a separate
index per crawl, so you query one collection at a time:

```bash
curl -s 'https://index.commoncrawl.org/CC-MAIN-2023-50-index?url=example.com%2F*&output=json'
```

The collection list is published at `index.commoncrawl.org`. Records give you
the WARC file, offset and length, so you fetch a byte range rather than a page.
Coverage is broad and shallow — a huge number of hosts, few captures each, and
no on-demand capture — which makes it good for "did this URL exist in this
window" and poor for change tracking. Its value is independence: it is a
different crawler with different seeds, and it holds pages Wayback never saw.

## A practical enumeration pass

```bash
# 1. Every host the archive ever saw under the domain
curl -s 'http://web.archive.org/cdx/search/cdx?url=*.example.com&output=json&fl=original&collapse=urlkey&limit=20000' \
  | jq -r '.[1:][] | .[0]' | awk -F/ '{print $3}' | sort -u

# 2. Non-HTML assets — documents, archives, configs
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=json&fl=original,mimetype,timestamp&filter=!mimetype:text/html&collapse=urlkey'

# 3. Paths that smell like admin or backup surface
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=json&fl=original,statuscode&collapse=urlkey' \
  | grep -Ei 'admin|backup|\.sql|\.env|\.bak|config|staging|test|internal'

# 4. Change history of one page of interest
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/about/team&output=json&collapse=digest&fl=timestamp,digest'
```

Step three is where old exposures live. A path that returned 200 in the archive
and 404s now is a removed file, and the archive may hold its content. A path
that 404s in the archive and 200s now is new. Both are worth writing down.

Check whether recovered paths are still live before you conclude anything — but
recognise that fetching them is an interaction with the target's server, not a
passive archive read, and it lands in their logs.
