# Dork cookbook

Organised by what you are trying to achieve, not by operator. Substitute
`example.com` and `Target Name` throughout.

Two rules before you copy anything from here. Run every query in Verbatim mode or
you do not know what executed. And run the important ones on at least two
engines — Bing and Yandex honour `site:` and `inurl:` far more literally than
Google, and the independent crawlers hold pages the majors dropped.

## Find documents belonging to an organisation

Documents are where organisations leak. They carry authorship metadata, internal
paths, draft language, and names that never appear on the website.

```
site:example.com filetype:pdf
site:example.com filetype:xlsx OR filetype:xls OR filetype:csv
site:example.com filetype:docx OR filetype:doc
site:example.com filetype:pptx
site:example.com (filetype:pdf OR filetype:docx) ("internal use only" OR confidential OR draft)
```

Documents hosted somewhere else are the bigger prize, because nobody is
curating them:

```
"Example Corp" filetype:pdf -site:example.com
site:scribd.com "Example Corp"
site:issuu.com "Example Corp"
site:slideshare.net "Example Corp"
site:documentcloud.org "Example Corp"
```

Published-to-web office documents live on the vendor's hostnames, not the
customer's:

```
site:docs.google.com "Example Corp"
site:drive.google.com "Example Corp"
site:onedrive.live.com "Example Corp"
site:sharepoint.com "Example Corp"
```

Once you have files, every one of them goes through `secrets-in-file-metadata`.
Author fields, `Company`, template paths and internal UNC paths are usually
worth more than the document body.

Government and regulatory copies of a company's documents are a separate seam:
`site:gov.uk "Example Corp" filetype:pdf`, and the same shape against any
national or municipal TLD in scope.

## Find a person's accounts and mentions

Search the *handle* and the *email* as literal strings, not the person's name.
Names are ambiguous; selectors are not.

```
"jdoe1987"
"jdoe1987" -site:example.com
"j.doe@example.com"
"j.doe" "@example.com"
```

The email split across quotes catches the anti-scraping obfuscations — `j.doe
[at] example.com`, images of addresses with the text in the `alt`, and
mailto links whose visible text differs from the target.

Platform sweeps, which surface profiles whose on-platform search is worse than
the engine's index:

```
site:linkedin.com/in "Example Corp" "Head of"
site:x.com "jdoe1987"
site:github.com "j.doe@example.com"
site:reddit.com/user "jdoe1987"
```

Staff enumeration without touching the target's site:

```
site:linkedin.com/in "Example Corp"
"@example.com" -site:example.com
site:example.com (intitle:"team" OR intitle:"about us" OR intitle:"leadership")
```

Historical staff pages are a `read-deleted-pages` job — the current site has
already removed the people who left, and those are frequently the ones who will
talk to you.

Conference programmes, academic papers, patent filings, court listings, and
committee minutes are all full-text indexed and all name people in a role. A
name plus a rare institutional term is often a better query than any operator.

## Find exposed files — authorized discovery only

Run this section against estates you own or are contracted to assess. The
queries are unremarkable; the ethics are entirely in the scoping. Finding a
misconfiguration through a search index is passive, because the engine already
crawled it. Fetching, downloading, or using what you find is not, and doing it
outside an authorization is where practitioners get themselves prosecuted.
Report through the route in [../../../ETHICS.md](../../../ETHICS.md).

Directory listings — the classic, still productive because autoindex gets left
on during migrations:

```
site:example.com intitle:"index of"
site:example.com intitle:"index of" (backup OR bak OR old OR archive)
site:example.com intitle:"index of" "parent directory"
```

Configuration and environment files. `ext:` on Bing matches the URL extension
rather than a sniffed content type, which is what you want here:

```
site:example.com ext:env OR ext:ini OR ext:conf OR ext:cfg
site:example.com ext:yml OR ext:yaml
site:example.com ext:log
```

Database and backup artefacts:

```
site:example.com ext:sql OR ext:db OR ext:sqlite
site:example.com ext:bak OR ext:old OR ext:swp OR ext:tmp
site:example.com ext:zip OR ext:tar OR ext:gz
```

Credential-shaped content in indexed text. Treat a hit as an exposure to report,
never as a credential to try:

```
site:example.com intext:"BEGIN RSA PRIVATE KEY"
site:example.com intext:"api_key" OR intext:"apikey" OR intext:"secret_key"
site:example.com ext:env intext:"DB_PASSWORD"
```

Anything you find here belongs in `secrets-in-git-history` too — the same
artefact is usually in a repository, and the repository has the history.

Cloud object storage is served from provider hostnames, so pivot the `site:`
onto the provider rather than the customer:

```
site:s3.amazonaws.com "Example Corp"
site:storage.googleapis.com "Example Corp"
site:blob.core.windows.net "Example Corp"
site:digitaloceanspaces.com "Example Corp"
```

Search engines see very little of the bucket population because listing pages
are rarely linked from anywhere. Dedicated bucket indexes — Grayhat Warfare is
the widely used one — enumerate far more, and are the right tool if buckets are
the objective.

Admin interfaces and infrastructure that should not be public:

```
site:example.com inurl:admin OR inurl:login OR inurl:dashboard
site:example.com inurl:phpinfo OR intitle:"phpinfo()"
site:example.com inurl:wp-content OR inurl:wp-admin
site:example.com intitle:"Grafana" OR intitle:"Kibana" OR intitle:"Jenkins"
```

For live exposed services rather than indexed pages, stop dorking and use
`find-exposed-servers`. Shodan and Censys scan; search engines only crawl what
something linked to.

## Find a leaked selector across paste and code hosts

The selector is an email, a handle, a domain, an internal hostname, a document
title, or a key prefix. Pastebin's own search is not usable for this — the
engines' `site:` index is what people actually use.

```
site:pastebin.com "j.doe@example.com"
site:ghostbin.com "example.com"
site:justpaste.it "Example Corp"
site:controlc.com "example.com"
site:rentry.co "example.com"
```

Code and snippet hosts used as dead drops:

```
site:gist.github.com "example.com"
site:jsfiddle.net "example.com"
site:codepen.io "internal.example.com"
site:replit.com "example.com"
```

Text-sharing and collaboration surfaces with public-by-default sharing:

```
site:trello.com "Example Corp"
site:notion.site "Example Corp"
site:atlassian.net "Example Corp"
```

Search-engine coverage of paste hosts is poor and lagging by design — pastes are
short-lived and often unlinked. Once the engine route is exhausted, go to
`find-leaks-in-the-wild` for the aggregators, historical paste corpora, and
channel-based distribution that actually hold this material.

For anything that used to be indexed and no longer resolves, take the URL to
`read-deleted-pages`. A dork result that 404s is not a dead end; it is a
timestamped assertion that the path existed.

## Source-code and tracker pivots

Searching rendered text misses everything in the page source. Services that
index raw HTML let you search for analytics IDs, ad-network identifiers,
favicon references, and distinctive markup. Publicwww is the commonly used one.

The pivot: pull an analytics or tag-manager ID from the target's page source,
then find every other site carrying the same ID. Shared tracker IDs are strong
common-operator evidence, because they mean one account configured both
properties — much stronger than shared hosting. Corroborate before you rely on
it: agencies reuse their own IDs across unrelated clients, and template
marketplaces ship placeholder IDs that end up on thousands of sites.

## Query hygiene checklist

- Verbatim mode on, or the query did not run as typed.
- Check the "Missing:" line in the results header. If it is there, re-run with
  the term forced.
- Click through to omitted results on any `site:` enumeration.
- Never quote a result count. They are estimates and they move.
- Same query on a second engine before you conclude anything is absent.
- Record engine, exact query string, and retrieval date with every finding. A
  dork result with no query string attached cannot be reproduced, and an
  unreproducible finding is not evidence.
