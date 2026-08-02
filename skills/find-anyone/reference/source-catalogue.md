# Person source catalogue — organised by the claim it can support

Pick the source by the claim you need to prove, not by what is convenient. Each
entry states what it establishes, how reliable it is, and how it fails.

## Identity and existence

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| National ID / civil registration indexes (birth, marriage, death) | Existence, dates, parents, spouse | High where published; index-only in many countries | Access is restricted in most of Europe; US varies by state; recent records often withheld |
| Obituaries and funeral-home notices | Death date, surviving relatives with relationships and cities, employer, military service, church, schools | High for relationships, medium for dates | Written by family; nicknames instead of legal names; paid notices are removed when the funeral home changes provider |
| Genealogy indexes (FamilySearch, Find a Grave, national civil-registration indexes such as the UK GRO index) | Family structure, birth/death years | Medium-high | User-contributed trees are unreliable; index entries are transcriptions and carry transcription errors |
| Naturalisation, gazette, and name-change notices | Legal name changes | High | Only some jurisdictions publish; often print-era only |

## Employment, role, and credentials

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| Professional networking profiles | Current and prior roles, dates, location, education | Low-medium — self-asserted, unverified | Inflated titles, hidden gaps, fabricated roles; deleted profiles disappear entirely, so archive on sight |
| Employer team/leadership pages and bios | Role, seniority, headshot, sometimes email format | Medium-high for current role | Churns fast; departed staff removed same-day — use `read-deleted-pages` |
| Press releases and news bylines | Role at a specific date, quotes attributable to the person | High for the fact of the role | PR language inflates; wire reprints look like independent corroboration but are one source |
| Conference programmes, speaker pages, session recordings | Role, expertise, employer, appearance, sometimes travel | High | Programmes are removed after the event; archive them |
| Licensing and professional boards (medical, legal, financial, engineering, real estate; e.g. FINRA BrokerCheck and SEC IAPD in US finance, the GMC register for UK doctors, the SRA register for solicitors in England and Wales, US state medical boards, the US NPI registry for healthcare providers) | Licence held, jurisdiction, licence number, status, disciplinary history | Very high — primary, and the best single credential check that exists | Only covers regulated roles; a lapsed licence and never having held one look different, so read the status field carefully |
| University and alumni pages, thesis repositories | Degree, year, department, supervisor | High | Common names in large cohorts; some universities publish only initials |

## Published output

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| Academic search and identifier systems (Google Scholar, ORCID, OpenAlex, Semantic Scholar, Crossref) | Publications, affiliation history, co-authors, ORCID as a durable person-level identifier | High; ORCID especially, because it is designed to solve name ambiguity | Author disambiguation in automated indexes routinely merges same-name researchers; ORCID is self-claimed and often incomplete |
| Patent databases (Google Patents, Espacenet, WIPO Patentscope, USPTO's public patent search) | Inventorship, inventor city/country at filing, assignee company, filing timeline | High — patents are examined legal documents | Inventor address is as-filed and ages badly; assignment can be reassigned later; corporate inventors are listed by legal name only |
| Standards bodies, open-source commit history, mailing-list archives | Technical contribution, employer at the time (via email domain), activity timeline | High | See `secrets-in-git-history` for the email-to-identity pivot |
| Bylines and author pages | Employment, subject expertise, output timeline | High | Pen names; freelancers appear across outlets with inconsistent bios |

## Business involvement

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| Corporate registries and officer indexes (see `who-really-owns-it`) | Directorships, shareholdings, incorporation dates, service address, sometimes birth month/year | Very high — filed under legal duty | Officer name matching across jurisdictions is fuzzy; service addresses are often the accountant's |
| Beneficial ownership registers | Ultimate control | High where open, but see the nominee problem in `who-really-owns-it` | Increasingly access-restricted |
| Charity and nonprofit filings (e.g. the UK Charity Commission register, US Form 990 filings) | Trusteeships, board roles, sometimes compensation | High | Small charities file minimal detail |
| Political donation and lobbying registers | Donations with employer and occupation self-declared, lobbying registrations | High for the record, medium for the self-declared occupation field | Jurisdiction-specific; thresholds mean small donations are invisible |

## Location and assets

Handle everything in this section under a documented objective. Location data on
a private individual has a narrow band of legitimate use.

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| Property and land registries (US county assessor and recorder offices; HM Land Registry in England and Wales, paid and per-title; Kadaster in the Netherlands; many others closed or paid) | Ownership, purchase date and price, mortgage, sometimes a mailing address | Very high where open — primary records | Property held through an LLC or trust hides the individual; some jurisdictions publish nothing |
| Court dockets and judgments (PACER and the CourtListener/RECAP archive in US federal courts; state court portals with wildly varying access; BAILII and official judgment databases in the UK) | Litigation history, addresses as filed, business disputes, judgments, bankruptcy | Very high — but read the disposition, not just the filing | Being sued is not being liable; sealed and expunged records vanish; state-court coverage is patchy and often not full-text searchable |
| Voter registration files (public in some US states, restricted in others; UK's edited electoral register is commercially available, the full register is not) | Address, age band, registration date, sometimes party | High where genuinely public | Legality of use varies by state and is sometimes limited to electoral purposes — check before use |
| Aggregators | Address history, phone, relatives | Low — lead only | See `dig-through-data-brokers` in full |

## Social and behavioural

Use after identity is anchored, never to establish it. Detail lives in
`hunt-a-handle` and `pattern-of-life-from-socials`.

| Source | Establishes | Reliability | How it fails |
|---|---|---|---|
| Platform profiles | Handle, network, self-presented biography, activity timeline | Low-medium | Impersonation, parody, abandoned accounts, and namesakes |
| Photographs on any of the above | Appearance; a cross-platform link when the same image recurs | Medium | Image reuse proves image reuse; see the caveat in the parent skill |
| Archived versions of all of the above | What the subject removed | High and often decisive | Robots-directive removals and site-owner exclusions can retroactively blank an archive |

## Reliability shorthand

- **Primary** — created by the body with legal authority over the fact
  (registry, court, licensing board, civil registration). Two primaries that
  agree closes a claim.
- **Secondary** — reported by someone with direct knowledge (news, employer,
  institution). Two secondaries plus an anchor gives *probable*.
- **Self-asserted** — the subject wrote it. Useful for leads and for detecting
  discrepancies against primary sources; never sufficient alone.
- **Derived** — an aggregator's recombination of other people's data. Lead only.
