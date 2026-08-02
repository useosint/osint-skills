# Archive sources: coverage and removal policy

Archives differ on three axes that decide whether the page you want exists: how
content gets captured, what the capture preserves, and who can make it go away.
The third axis is the one investigators underweight and the one that decides
whether your evidence survives the case.

Coverage, policy and availability change. Verify before relying on any specific
behaviour described here.

## Capture model determines coverage

**Crawler-driven** archives — Wayback's own crawls, Common Crawl, national
library archives — capture on their own schedule from seed lists, link graphs,
and partner feeds. Broad, unattended, and blind to anything unlinked or
login-gated. They give you *history* of popular and linked pages, and nothing at
all for the rest.

**On-demand** archives capture only what a human submits. Archive.today is
purely this; Wayback also accepts on-demand submissions alongside its crawls.
Coverage is therefore a record of what somebody thought worth preserving, which
correlates strongly with controversy — the page that got deleted is often
precisely the page somebody archived by hand first.

**Consequence:** an obscure page has no crawler coverage and no on-demand
coverage unless someone cared. A controversial page usually has both. Absence of
a capture on an obscure URL means almost nothing.

## Wayback Machine

The default and the largest, and the only one with a real query API — the CDX
server, covered in [cdx-cookbook.md](cdx-cookbook.md).

Strengths: depth over time on any well-linked site, sometimes decades of
captures at high frequency. A queryable index over captures, which no other
general archive offers at the same quality. Stable, citable URLs. Save Page Now
for on-demand capture.

Weaknesses that change your results:

- **JavaScript-heavy pages replay badly.** The crawler stores the resources it
  fetched; anything rendered client-side from an API call at view time is
  usually absent or broken. Single-page applications often archive as an empty
  shell. What you see in replay may be far less than what the crawler stored —
  fetch the raw capture with the `id_` modifier before concluding a page is empty.
- **Replay reconstructs a page from resources captured at different times.** The
  HTML may be from one date and an image or stylesheet from months either side.
  The rendered page you screenshot may never have existed in that form.
- **Removal happens.** See the exclusion section below.

## archive.today

Run separately from the Internet Archive, on-demand only, and valuable
precisely because it is a different corpus answering to different pressure.

- **Renders the page in a browser before saving.** It captures the DOM after
  JavaScript execution and stores a static HTML rendering plus a screenshot.
  This is why it works on social posts, single-page apps and dynamic content
  where Wayback replays a blank shell.
- **Does not honour robots.txt** and does not offer the same removal routes.
  Content that vanished from Wayback under an exclusion frequently remains here.
  Removal is at the operator's discretion and is not a published process.
- **One page, one moment.** No crawl, no site enumeration, no CDX-style API. You
  can list existing snapshots of a URL or URL prefix through its own interface,
  and it has a full-text search over what it holds, but there is no equivalent
  of `matchType=domain`.
- **Operates across several interchangeable domain names.** They serve the same
  corpus; if one is unreachable from your network another usually is. Access is
  sometimes blocked for VPN, Tor and certain resolvers, which matters when you
  are working from an isolated environment — see
  `investigate-without-getting-made`.
- **Operator is anonymous and funding is opaque.** For most work this is
  irrelevant. For evidence intended to survive challenge, it is a point an
  opponent can raise, so corroborate a decisive archive.today capture against
  another source where you can.

Practical rule: check both Wayback and archive.today, always, in both
directions. Each holds material the other does not, and the pattern of which
one holds what is itself informative — a page present only on archive.today
often means somebody preserved it deliberately, and a page removed from Wayback
but present on archive.today means somebody tried to make it go away.

## Common Crawl

An open, independent crawl published as WARC files with a per-crawl URL index.
Broad and shallow: enormous host coverage, few captures per URL, no on-demand
submission, and a lag between crawl and publication.

Use it when Wayback has no capture and you need to establish that a URL existed
and returned content in a given window, or when you want a crawl that is
independent of the Internet Archive entirely. Not useful for change tracking.

## Memento and Timetravel

Memento is a protocol, not an archive: it standardises "give me this resource as
it was at this datetime" across archives. A TimeMap lists known captures of a
URL; a TimeGate redirects to the nearest capture to a requested datetime.

The aggregator services built on it query many archives at once, which is the
efficient way to discover that a national or institutional archive holds a
capture you would never have thought to check. Treat aggregator results as a
discovery layer, then go to the holding archive directly for the actual capture.

## National, institutional and specialist archives

Frequently overlooked and often the only holder of a regional page.

- **National library web archives** — the UK Web Archive, the Portuguese web
  archive, and equivalents in many countries — collect within a national remit,
  typically by TLD or by subject. Some offer full-text search across their
  holdings, which Wayback does not, and full-text search of an archive is a
  different and sometimes much more powerful tool than URL lookup. Access is
  sometimes restricted to reading-room use for legal-deposit reasons.
- **Legal and academic citation archives** — Perma.cc and similar — exist to
  make citations permanent for court filings and journals. Capture is by
  registered users, so coverage is narrow, but what is there was captured
  deliberately with provenance in mind.
- **Self-hosted capture tooling** — Webrecorder's tools and the WARC-writing
  modes of standard fetchers — let you produce your own archive-grade record.
  This is the right answer for evidence you cannot afford to lose.
- **Platform-specific mirrors** exist for video and social content that general
  archives handle poorly.

## Removal, exclusion, and how content disappears

**Retroactive robots.txt exclusion** is the mechanism that has caught out the
most investigators. Historically, the Wayback Machine applied a site's *current*
robots.txt to its *entire* capture history — so a new `Disallow` could make
years of archived pages inaccessible overnight, with no notice and no record.
The Internet Archive has moved away from applying this to many categories of
site, but the underlying capability and other exclusion routes remain, and older
guidance and tooling still assume the old behaviour.

The investigator-relevant consequences:

- **Domain transfers destroy archives.** Buy an expired domain, publish a
  restrictive robots.txt, and the previous owner's archived history can become
  unavailable. This is a known and cheap technique for laundering a site's past.
  It is also why a domain that changed hands is worth checking against
  archive.today and Common Crawl before you accept that its history is gone.
- **Exclusion is not deletion.** Excluded material is generally still held; it
  is not served. That distinction matters for a legal request and means nothing
  for your immediate investigation.
- **Takedown requests** — from rights holders, from data-protection claims, from
  the site operator directly — remove specific material through a process that
  is not public.

**Reading the failure mode matters.** A URL that was never captured, a URL whose
captures are being withheld, and a URL captured as a 404 are three different
facts. An explicit exclusion notice tells you somebody acted; a plain absence
tells you nothing. Note which one you got.

## Choosing quickly

- Need history, structure, or change tracking: Wayback, via CDX.
- Wayback shows an empty shell or a broken render: archive.today.
- Wayback shows an exclusion notice: archive.today, then Common Crawl.
- Need to prove a URL existed when Wayback has nothing: Common Crawl.
- Regional or national-domain content: the relevant national archive, found via
  a Memento aggregator.
- Evidence you must not lose: capture it yourself to WARC *and* submit to at
  least two independent archives, today, before anyone knows you are looking.
