# Corporate registry catalogue

What each registry exposes and how you get at it. Access models change; the
structural point — that a given jurisdiction is rich or thin, free or paid — is
the durable part.

Access shorthand: **Open** (free search and free documents), **Free search /
paid docs**, **Paid**, **Gated** (registration or legitimate-interest test),
**Closed**.

## Cross-jurisdiction indexes

| Source | What it is | Use it for | Caveats |
|---|---|---|---|
| OpenCorporates | The largest cross-jurisdiction index of company records, compiled from official registries, with an API | Finding which registry holds an entity; officer search across jurisdictions; a first pass at group structure | Coverage varies enormously by jurisdiction — some countries are near-complete, some are name-and-status only, some are absent. Refresh lag means status fields can be wrong. Normalisation loses detail. Never the source of truth; always confirm at the national registry |
| GLEIF (Global Legal Entity Identifier Foundation) LEI search | The register of Legal Entity Identifiers issued to entities participating in financial markets | Verified legal name and address, and crucially direct and ultimate parent relationships — a structured ownership link most registries do not publish | Only covers entities that needed an LEI. Parent data depends on the entity reporting it |
| OpenOwnership | Aggregated beneficial ownership data across contributing jurisdictions | Cross-border beneficial ownership | Only as good as the contributing registers |
| OpenSanctions | Aggregated sanctions, PEP, and related entity datasets across jurisdictions, with bulk data and an API | Screening entities and officers in one pass | A hit is a review trigger; name matching is noisy |
| OCCRP Aleph | Investigative index across leaks, registries, documents, and court records | Finding a name in material no registry indexes | Mixed provenance; treat each hit according to its underlying source |
| ICIJ Offshore Leaks database | Entities, officers, intermediaries, and addresses from journalistic investigations into offshore structures | Visibility into jurisdictions whose registers are closed | A historical snapshot, not a register. Presence is not wrongdoing; absence means nothing |
| EU Business Registers interconnection (accessible through the European e-Justice portal) | A search layer across EU member-state registers | Locating an entity when you know the country but not the register | Thin data; a routing tool, not a source |

## United Kingdom and Ireland

| Jurisdiction | Registry | Access | Exposes |
|---|---|---|---|
| UK | Companies House | Open, free, with a documented API and bulk data products | Company number, incorporation, status, registered office, full filing history with downloadable documents, officers with role and appointment/resignation dates and birth month and year, the PSC (persons with significant control) register, share capital, charges, annual accounts, and confirmation statements. The most useful free corporate registry anywhere, and the reason UK-linked research is disproportionately tractable |
| UK | The Gazette | Open | Statutory notices: insolvency, winding-up, strike-off, administration |
| UK | Insolvency Service registers | Open | Individual insolvency, and the disqualified directors register |
| Ireland | Companies Registration Office | Free search / paid docs | Company number, officers, filings, annual returns |

The UK's identifier is an eight-character company number, zero-padded, with
jurisdiction-prefixed forms for Scotland and Northern Ireland. Keep the leading
zeros; dropping them is a common lookup failure.

## United States

There is no national company registry. Incorporation is state-level, disclosure
is federal only for securities issuers, and this split is the defining feature of
US corporate research.

| Source | Access | Exposes |
|---|---|---|
| Secretary of State registries, one per state (California's business search, Delaware's entity search, New York's, Texas's, and so on) | Mostly Open free search; documents often Paid | Entity name, number, formation date, status, registered agent, and — depending entirely on the state — officers, managers, or nothing at all about people. Many states publish no shareholder information whatsoever |
| Delaware Division of Corporations | Free search / paid docs | The most-used incorporation jurisdiction and one of the least informative: name, file number, status, registered agent. No officer or member list is published |
| SEC EDGAR | Open, free, with a full-text search across filings and a documented API | Everything a company registry does not: audited financials, subsidiary lists in the annual report exhibits, insider holdings and transactions, beneficial ownership above reporting thresholds, related-party transactions, auditor identity and changes, and material event disclosures. If your target is a US-listed issuer or connected to one, start here and not at the state |
| FinCEN beneficial ownership reporting | Not public | A US federal beneficial ownership reporting regime exists but the register is not a public search tool. Do not plan around access to it |
| USAspending.gov and the Federal Procurement Data System | Open | Federal contract awards, which evidence real revenue |
| SAM.gov | Open | Federal contractor registration and exclusion status |
| IRS Form 990 filings, via public republishers | Open | Nonprofit trustees, officers, and compensation |

Practical consequence: for a private US company, the state registry often gives
you a registered agent and nothing else. Your people information will come from
court filings, licensing boards, property records, and `find-anyone`, not from
the registry.

## Europe

| Country | Registry | Access | Notes |
|---|---|---|---|
| Germany | Handelsregister, with company data also surfaced through the Unternehmensregister | Free search, some documents free, some paid | Rich filings including articles and accounts; HRA/HRB numbers are local-court-scoped, so record the court |
| France | The national company register operated by INPI, with data also published through the government's business directory service and Infogreffe | Open data plus paid documents | SIREN (entity) and SIRET (establishment) identifiers; beneficial ownership access has been restricted |
| Netherlands | KVK (Chamber of Commerce) | Free search / paid extracts | KVK number; UBO register access restricted |
| Belgium | Crossroads Bank for Enterprises | Open | Enterprise number |
| Spain | Registro Mercantil, with corporate announcements in the BORME official bulletin | Paid documents | The bulletin is a useful free timeline of appointments and changes |
| Italy | Registro delle Imprese, via the chambers of commerce | Paid | |
| Denmark | CVR | Open, free, with an API | Unusually open, including accounts and ownership |
| Norway | Brønnøysund Register Centre | Open, free, with an API | Very open |
| Sweden | Bolagsverket | Free search / paid docs | |
| Finland | The Finnish Patent and Registration Office and the joint business information system | Open | |
| Estonia | e-Business Register | Open, very rich | Digital-first; among the most accessible in Europe |
| Switzerland | Zefix, the central business name index, linking to cantonal registers, with notices in the official commercial gazette | Open | The gazette is the timeline source |
| Luxembourg | The trade and companies register | Free search / paid docs | Holding-company heavy, so it recurs constantly in group structures |
| Ireland, UK | See above | | |

## Asia-Pacific

| Country | Registry | Access | Notes |
|---|---|---|---|
| Singapore | ACRA, via its BizFile service | Paid documents | Comprehensive but per-document paid |
| Hong Kong | Companies Registry, via its online search service | Paid per document | Directors and charges available; a common node in cross-border structures |
| Australia | ASIC's registers, searchable through ASIC Connect, plus ABN Lookup for business numbers | Free search / paid extracts | ACN and ABN identifiers; ABN Lookup is free and open |
| New Zealand | Companies Office | Open, free, unusually complete | Directors and shareholders published free |
| India | The Ministry of Corporate Affairs portal | Free search / paid docs | CIN identifier; director identification numbers make the officer pivot reliable |
| Japan | The National Tax Agency's corporate number system | Open for basic data | Corporate number, name, address; detailed registry extracts are obtained separately |
| China | The national enterprise credit information publicity system, plus commercial resellers | Free basic, Chinese-language | Name matching requires the Chinese-character name; romanisations will not resolve |

## Americas, Africa, Middle East

| Country | Registry | Access | Notes |
|---|---|---|---|
| Canada | Corporations Canada federally, plus a registry per province | Mixed, mostly free search | Check both federal and provincial |
| Canada (securities) | SEDAR+ | Open | Filings for Canadian issuers |
| Brazil | The federal revenue service's CNPJ lookup | Open | CNPJ identifier; broad coverage |
| Mexico | The public commerce registry system | Gated | |
| South Africa | CIPC | Gated / paid | |
| UAE | Free-zone authorities each maintain separate registers alongside the mainland registries | Mostly Closed | Fragmented by free zone; expect very limited public visibility |

## Offshore and low-disclosure jurisdictions

Typical pattern: a name-and-status search, with officers, shareholders, and
beneficial owners held by the licensed registered agent and not published. British
Virgin Islands, Cayman Islands, Panama, Seychelles, Belize, Marshall Islands, and
several others fall broadly into this category, with differing details and with
beneficial-ownership regimes that are typically accessible to authorities rather
than the public.

Research strategy when your chain enters one of these:

1. Take whatever the registry does publish — name, number, incorporation date,
   status, and the registered agent.
2. Search the ICIJ Offshore Leaks database for the entity, the agent, and the
   known officers.
3. Pivot to jurisdictions that *do* publish: if the offshore entity holds shares
   in a UK, Nordic, or NZ company, that company's filings will name it, and
   sometimes name the humans behind it.
4. Look for litigation. Offshore entities that end up in court in an open
   jurisdiction generate filings that expose the structure.
5. Document the terminus explicitly and stop.

## Identifier formats worth knowing

Recording the right identifier is what makes your research reproducible.

| Jurisdiction | Identifier |
|---|---|
| UK | Company number, 8 characters, zero-padded, with country prefixes for Scotland and NI |
| US | State-issued entity or file number, format per state; SEC filers additionally have a CIK |
| France | SIREN for the entity, SIRET for each establishment |
| Germany | HRA/HRB number, scoped to the registering local court |
| Netherlands | KVK number |
| Australia | ACN for companies, ABN for anything with a tax presence |
| India | CIN for companies, DIN for directors |
| Brazil | CNPJ |
| Global, financial markets | LEI, 20 characters |
| EU VAT | Country-prefixed VAT number, validatable through the EU's VIES service |
