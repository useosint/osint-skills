# Number formats and search permutations

Search engines index the characters on the page, not a normalised number. A
number written `(555) 123-4567` on one site and `+1.555.123.4567` on another are
two different strings, and searching one will not find the other. This is the
most common reason a phone investigation returns nothing when the number is
sitting in plain sight in an indexed document.

Generate the permutations mechanically, search each one quoted, and repeat
across more than one engine — index coverage of the same number differs sharply
between them.

## The permutation set

For any number, vary four things independently:

1. **Country code** — present with `+`, present with the international access
   prefix (`00` in much of the world, `011` from North America), or absent
   entirely with the national trunk prefix restored.
2. **Grouping** — the national convention, plus the common wrong ones. Numbers
   get regrouped by whoever typed them.
3. **Separator** — space, hyphen, dot, none. Also parentheses around the area
   code, and a slash (common in German-speaking countries).
4. **Trunk prefix** — the national leading digit present or absent.

Worked out for the North American example `+1 555 123 4567`:

```
+15551234567        +1 555 123 4567     +1 (555) 123-4567
+1-555-123-4567     +1.555.123.4567     1-555-123-4567
(555) 123-4567      (555)123-4567       555-123-4567
555.123.4567        555 123 4567        5551234567
001 555 123 4567    011 1 555 123 4567
```

For `+44 7700 900123`:

```
+447700900123       +44 7700 900123     +44 (0) 7700 900123
07700 900123        07700900123         07700-900123
0044 7700 900123    (07700) 900123
```

The `+44 (0) 7700` construction — country code with the trunk prefix
parenthesised — is technically wrong and extremely common on business cards,
letterheads, and websites. Always search it.

## National grouping conventions

Group as the locals write it, not as your tooling formats it. Common shapes:

| Region | Typical written form |
|---|---|
| North America | `(555) 123-4567`, `555-123-4567` |
| UK | `07700 900123`, `020 7946 0000` (variable-length area code) |
| Germany | `030 12345678`, `+49 (0)30 12345678`, area code and subscriber split by `/` |
| France | `01 23 45 67 89` — pairs |
| Italy | `06 1234 5678`, leading zero retained internationally |
| Netherlands | `06-12345678`, `020-1234567` |
| India | `+91 98765 43210` — five and five |
| Japan | `090-1234-5678` |
| Brazil | `(11) 91234-5678` |
| Australia | `0412 345 678`, `(02) 1234 5678` |
| China | `138 0013 8000` |

Where the national destination code is variable-length (the UK is the classic
case), the grouping itself is ambiguous and different sites will split the same
number differently. Search more than one split.

## Obfuscated and evasive forms

People who do not want a number scraped write it deliberately oddly, and these
forms are exactly where the interesting results are — classified ads, forum
signatures, and marketplace listings.

- Unicode dashes and spaces in place of ASCII: en dash, non-breaking hyphen,
  non-breaking space. Visually identical, textually different.
- Digits spelled out, wholly or partly: `five five five 123 4567`,
  `555 one two three ...`
- Words for separators: `555 dash 123 dash 4567`.
- Digits interrupted by characters intended to be removed: `5.5.5.1.2.3.4.5.6.7`,
  `555_123_4567`, `555*123*4567`.
- Homoglyph substitution: letter `O` for zero, letter `l` or `I` for one.
- Split across lines or fields so the number never appears contiguously.
- Numbers embedded in images to defeat text indexing. Nothing textual will find
  these; consider whether the platform in question is worth manual review.

You cannot enumerate all of these. Prioritise: the last four digits alone,
quoted, alongside the area code as a separate term, catches a large share of
obfuscated cases without generating impossible volumes of noise. Beware that
short digit strings also generate heavy false-positive traffic — pair them with
another term (a name, a city, a domain) rather than searching alone.

## Where to search, beyond general engines

- Regional search engines, which index local classifieds and directories that
  the global engines skip.
- Business and trade directories, chamber-of-commerce listings, and licensing
  registers.
- Classified and marketplace sites, including their archived versions via
  `read-deleted-pages`.
- Paste sites, forums, and messaging-channel archives via
  `find-leaks-in-the-wild`.
- Code hosting: numbers appear in test fixtures, config files, and contact
  pages. Use `secrets-in-git-history`.
- Document-type searches (PDF, spreadsheet, presentation) via
  `google-like-a-spy` — invoices, membership lists, and event registrations leak
  numbers constantly and are rarely deliberately published.
- Breach corpora via `what-leaked-about-you`, which index the number as a field
  rather than as page text and therefore sidestep the whole formatting problem.

## Recording

Log every permutation searched and every engine used. A phone search that
returns nothing is a defensible finding only if you can show the permutation set
was complete; otherwise it is just an incomplete search.
