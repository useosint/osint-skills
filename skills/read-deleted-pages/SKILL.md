---
name: read-deleted-pages
description: Recover deleted or historical web content from web archives. Use when a page is deleted or changed, checking what a site used to say, finding old team pages or prices, retrieving archived social posts, or mining the Wayback Machine and archive.today.
---

# Wayback & Web Archives

Deleted content rarely disappears. Archives recover old bios, staff lists,
prices, exposed files, and edited claims.

## Sources

- **Wayback Machine** (`web.archive.org`) — the largest; multiple snapshots over
  time.
- **archive.today** — on-demand snapshots that capture JS-heavy pages and pages
  Wayback misses; good for social posts and paywalled/edited articles.
- **Google/Bing cache**, and country archives (UK Web Archive, etc.).

## Techniques

```bash
# Every URL the Wayback CDX API knows for a domain — great for finding
# forgotten paths, PDFs, and admin pages
curl -s 'http://web.archive.org/cdx/search/cdx?url=example.com/*&output=text&fl=original&collapse=urlkey' \
  | sort -u
```

- Compare snapshots across dates to see **what changed and when** (a scrubbed
  claim, a removed name, a price hike).
- Pull old **team/about** pages for former staff → `find-anyone`.
- Recover deleted **social posts** by archiving the profile URL, or search
  archive.today for the handle.
- Grep CDX output for `.pdf`, `.xls`, `.env`, `/wp-admin` and other exposed
  paths, then check if the file is still live.

## Pitfalls

- Snapshots are incomplete; absence of a snapshot ≠ the page never existed.
- Robots.txt and takedowns can hide snapshots — try archive.today as a fallback.
- Preserve evidence: save the archived URL itself (it's a stable citation) plus
  a local screenshot.
