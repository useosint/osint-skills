# Cross-engine operator equivalence

An operator that exists on two engines rarely means the same thing on both. The
differences below are the ones that change results, not trivia.

Operator support changes without announcement and without error messages. An
engine that has dropped an operator will usually treat it as a plain search term
and return general results, so a query that "works" may not be filtering at all.
Test any operator you depend on against a query whose correct answer you already
know.

## The core set

| Operator | Google | Bing | DuckDuckGo | Yandex | Independent crawlers |
|---|---|---|---|---|---|
| `"phrase"` | Yes, still rewritten | Yes, more literal | Yes | Yes | Yes, usually the most literal of all |
| `site:` | Yes; host, domain, or TLD | Yes; most literal enumeration | Yes | Yes; also `host:` and `rhost:` | Generally yes |
| `-term` | Yes | Yes | Yes | Yes, and `~~` for exclusion | Generally yes |
| `OR` / `\|` | Yes, `OR` must be capitalised | Yes | Yes | Yes | Varies |
| `filetype:` | Yes | Yes, plus `ext:` | Yes | Use `mime:` | Varies; often absent |
| `intitle:` | Yes | Yes | Yes | Yes | Commonly supported |
| `inurl:` | Yes | Yes, plus `url:` for a single page | Yes | Yes | Varies |
| `intext:` | Yes | Yes | Unreliable | Yes | Varies |
| `before:` / `after:` | Yes, `YYYY-MM-DD` | Date filter in the UI | Time filter in the UI | `date:` operator | Varies |

## Where the same operator behaves differently

**`site:`** — On Google, a registrable domain matches subdomains, a bare TLD
works (`site:gov.uk`), and the result set is aggressively deduplicated and
truncated. Google will not give you a complete enumeration of a large host no
matter how you page it. Bing is markedly more literal and more complete on the
same host, which is why `site:` enumeration belongs on Bing even when the rest
of your work is on Google.

**`filetype:` versus `ext:`** — Google's `filetype:` matches on the document
type it determined during indexing. Bing's `ext:` matches the extension in the
URL. For hunting `.env`, `.bak`, `.sql`, `.old` and similar, `ext:` is what you
want, because those have no registered content type and Google frequently
declines to classify them at all. Yandex uses `mime:` and matches on the
declared content type.

**`intitle:` versus `allintitle:`** — the `all*` forms on Google apply to every
following term and interact badly with other operators in the same query.
Combining `allintitle:` with `site:` produces unpredictable results. Use one
`all*` operator alone, or repeat the single-term form.

**`before:`/`after:`** — Google filters on an *estimated* document date inferred
from the page, its URL, and its structured data. It is frequently wrong,
especially on CMS-driven sites that stamp the current date on every render. Use
it as a coarse sieve and never cite it as evidence of when something was
published. If you need a real date for a page, get it from `read-deleted-pages`.

**Phrase search** — the strongest signal on every engine, and still not
absolute on Google, which will stem and expand within a quoted phrase under some
conditions. Bing, Yandex, and the independent crawlers honour quotes more
literally. If a quoted string has to match exactly, verify on a second engine.

## Engine-specific operators worth knowing

**Bing** has two operators no other mainstream engine offers. `ip:` returns
pages Bing indexed at a given IP address, which is a genuine reverse-IP lookup
against a search index — useful for finding co-hosted sites, though it is
worthless on shared hosting and CDN addresses for the same reason reverse DNS
is. `contains:` finds pages linking to a file of a given type, which reaches
documents the crawler saw referenced but did not index directly. Bing also
supports `url:` to test whether one specific page is in the index, and
`language:` and `loc:` for language and region constraints.

**Yandex** carries the richest operator set still functioning. `host:` matches
an exact host and `rhost:` takes the host in reverse order, which lets you match
a domain and all its subdomains as one pattern. `mime:` filters document type,
`lang:` filters language, `date:` filters by date including ranges, and `title:`
and `url:` behave like their Google equivalents. Yandex also supports proximity
and structural operators that no other engine does: `/n` constrains word
distance, `&` requires terms in the same sentence, and `&&` requires them in the
same document. Yandex's crawl priorities differ sharply from Google's, and its
coverage of Russian, Turkish and CIS content is not replicated anywhere else.

**DuckDuckGo** takes most of its results from Bing's index, so treat it as Bing
with a privacy layer rather than an independent crawl — it will rarely show you
a page Bing does not have. Its distinguishing feature is bangs: a `!` prefix
redirects the query to another site's own search, which is the fastest way to
run one string across many platforms. It does not personalise or store the
query, which matters when the selector itself is sensitive.

**Startpage** returns Google's results through a proxy. Use it when you want
Google's index without Google's personalisation and without your own IP hitting
Google, but recognise that it is Google's index and therefore inherits all of
Google's rewriting.

**Independent crawlers** — Mojeek, Marginalia, and Brave run their own crawls.
Their indexes are far smaller, which means they miss most things but also that
they have not applied the same commercial ranking and deduplication. They will
surface small, old, and unpopular pages the majors dropped or never ranked.
Marginalia in particular is optimised for non-commercial text content and will
find the hobbyist page, the personal site, and the mailing-list archive that
Google buries. Brave supports Goggles, user-authored re-ranking rules you can
apply to a query. Operator support on all three is a subset of the core set and
varies; check each one's documentation rather than assuming.

## Engines that rewrite your query

This is the failure that silently ruins dorks, so know which engines do it.

**Google rewrites aggressively.** It stems terms, substitutes synonyms,
corrects perceived misspellings, and drops terms it judges unproductive. It also
personalises on account history, location, and language. Every one of these is
wrong for investigative use — a username is a misspelling to a spell checker and
a rare error string looks unproductive. Verbatim mode disables stemming,
synonyms, spell correction and personalisation, and it is the only state in
which a Google dork means what it says. The "Missing: `<term>`" notice in the
results header is Google telling you it dropped a term; if you see it, your
query did not run.

**Bing rewrites less** but still spell-corrects and expands. It shows a
"Including results for" notice with a link to search only for the original
string.

**Yandex applies morphological expansion by default** — a Russian query matches
inflected forms of the word. That is usually desirable for natural-language
Russian and undesirable for selectors. Prefix a term with `!` to disable
morphology on that term and match the exact form.

**DuckDuckGo** inherits Bing's rewriting.

**The independent crawlers** generally do the least rewriting, which is a real
advantage for exact-string hunting even given their small indexes.

## Practical rules

- Enumerate hosts on Bing, search text on Google in Verbatim, search non-Latin
  and CIS content on Yandex, and sweep the independents for anything old or
  obscure.
- When an engine returns zero results for a dork, that is a statement about that
  engine's index and operator support, not about the web.
- Never quote a result count from any engine. All of them are estimates,
  computed differently, and they change between pages of the same query.
- Log the engine name alongside the query string in your notes. A finding that
  does not say which index produced it cannot be reproduced.
