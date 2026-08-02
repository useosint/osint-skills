# People-data source catalogue by jurisdiction and record type

Organised so you can answer two questions fast: what is the primary source behind
this broker field, and can I actually get at it where my subject lives.

Access model shorthand: **Open** (free, online, searchable), **Gated** (free but
requires registration or in-person/postal request), **Paid** (per-record or
subscription), **Restricted** (purpose-limited by law), **Closed** (not available
to the public).

## United States

The deepest public-record environment in the world, and the reason the broker
industry is US-centric. Note that almost everything below is county- or
state-level, so "is this public?" has fifty-plus answers.

| Record type | Source | Access | Reliability | Notes |
|---|---|---|---|---|
| Property ownership, deeds, mortgages | County recorder / register of deeds; county assessor for valuation and mailing address | Mostly Open online, some Paid, some in-person | Very high — primary | The single best free confirmation source for an address. Entity-held property hides the individual |
| Civil and criminal court records, federal | PACER; CourtListener/RECAP as a free archive of already-purchased documents | PACER Paid per page, RECAP Open | Very high | Read the disposition. RECAP only has what someone already bought |
| Court records, state and county | Per-state portals, quality ranging from full-text search to a paper index | Open to Closed, varies wildly | High at origin | The biggest coverage gap in US research. Name-only indexes create false matches |
| Bankruptcy | Federal bankruptcy courts via PACER | Paid | Very high | Also surfaces address history and creditor lists |
| Voter registration | State election authorities; several states publish the file, others restrict or prohibit non-electoral use | Open to Restricted | High for address and age band | Check the state's use restrictions before using it in an investigation |
| Professional licences | State boards per profession; FINRA BrokerCheck for securities brokers; SEC IAPD for investment advisers; the CMS NPI registry for healthcare providers | Open | Very high | Best credential check available. Includes disciplinary history |
| Business registration | Secretary of State per state (see `who-really-owns-it`) | Open, mostly free search | Very high | Registered agent address is often the lawyer's |
| Nonprofit filings | IRS Form 990 filings, republished by several open explorers | Open | High | Names trustees and top compensation |
| Political donations | Federal Election Commission; state equivalents | Open | High for the record | Occupation and employer fields are self-declared |
| Sex offender registries | State registries and the federal public website | Open | High | Purpose-restricted use in some states; misuse is an offence |
| Vital records (birth, marriage, death) | State and county vital records offices | Gated to Restricted | Very high | Recent records usually restricted to the person or next of kin |
| Death index | Social Security death data as republished by genealogy services | Open | High but incomplete | Useful for eliminating a deceased candidate |
| Driver and vehicle records | State DMVs | Restricted | Very high | Driver's Privacy Protection Act limits use to enumerated purposes |
| Prison and inmate records | Federal Bureau of Prisons inmate locator; state DOC locators | Open | High | Confirms a period of incapacity, which resolves timeline conflicts |
| Aggregators | Spokeo, BeenVerified, Whitepages, TruePeopleSearch, FastPeopleSearch, That'sThem, Radaris, Intelius, PeopleFinders, Pipl (investigator tier) | Free teaser / Paid | Low — lead only | Different brands, overlapping upstream vendors |

## United Kingdom

Far more restricted than the US on individuals, more open than the US on companies.

| Record type | Source | Access | Notes |
|---|---|---|---|
| Company officers, including a service address and birth month/year | Companies House | Open, free, with an API | The richest free person-to-business source in any jurisdiction |
| Land and property ownership | HM Land Registry (England and Wales), Registers of Scotland, Land and Property Services (NI) | Paid per title | Not free-searchable by person name; you search by property |
| Electoral register | The edited/open register is commercially licensed; the full register is restricted | Restricted / Paid | Individuals can opt out of the open register |
| Court judgments | Registry Trust for judgments against individuals and businesses; BAILII and the official judgment publication service for judgments text | Paid / Open | County court judgment checks are a standard credit-adjacent search |
| Insolvency | The Insolvency Service individual insolvency register; The Gazette for statutory notices | Open | Bankruptcy and IVA records |
| Professional registers | GMC for doctors, NMC for nurses, SRA for solicitors in England and Wales, and equivalents by profession | Open | High reliability |
| Births, marriages, deaths | GRO indexes; ScotlandsPeople for Scotland | Gated / Paid | Index is searchable, certificates are ordered |
| Charity trustees | Charity Commission for England and Wales, and the Scottish and NI regulators | Open | Names trustees |

## European Union / EEA

Assume individual-level records are closed unless you find a specific legal basis
for publication. Company records are a different story — see the registry
catalogue in `who-really-owns-it`.

- **Population registers** exist in most member states and are Closed or heavily
  Restricted. The Nordic countries are a partial exception: several publish or
  make semi-available basic residency and, in some cases, taxation data. Do not
  generalise from one country to the region.
- **Land registries** range from Open (some cadastral data in the Netherlands and
  parts of Scandinavia) to Paid to Restricted.
- **Court records** are generally published as anonymised or pseudonymised
  judgments. Party names are commonly redacted.
- **Insolvency registers** are frequently Open at national level.
- **Professional registers** are Open in most member states for regulated
  professions.
- **Data subject rights** apply to your processing as well as the broker's.

## Canada, Australia, New Zealand

| Jurisdiction | Notable open sources |
|---|---|
| Canada | Federal and provincial corporate registries; provincial land registries (mostly Paid); court records by province with varying access; professional regulators by province |
| Australia | ASIC Connect for company and licensing records; ABN Lookup for business numbers; state land titles offices (Paid); AustLII for judgments; state and federal court portals |
| New Zealand | The Companies Office register, which is unusually open and free; land information services (Paid); NZLII for judgments |

Australia and New Zealand both have broad privacy statutes that restrict
commercial aggregation, so the US broker model is largely absent.

## Everywhere else

The general rule: company records are more open than person records almost
everywhere, so route person questions through business involvement where you can.
Where a country has a national ID system, person records tend to be *more*
centralised and *less* public, not more. Absence of a searchable record in a
low-transparency jurisdiction tells you nothing about your subject.

## Record type to primary source mapping

Use this to answer "what should I confirm this broker field against?"

| Broker field | Confirm against |
|---|---|
| Current address | Property record, court filing, voter file where public, a utility or regulatory filing |
| Address history | Deeds with transaction dates, court filings with dates |
| Age / date of birth | Voter file, professional licence, corporate officer record where DOB is published, vital records index |
| Middle name | Any primary document — deeds and court filings usually carry the full legal name |
| Phone | `whose-number-is-this`; broker phone data is not confirmable against a primary source, so it stays a lead |
| Relatives | Obituaries first, then civil-registration indexes |
| Employment | Employer site, professional register, corporate officer record |
| Prior names / aliases | Marriage records, name-change notices, prior filings under the old name |
| Criminal record | The court of record, directly. Never rely on a broker's criminal field — it is the field with the highest error rate and the highest consequence |
| Bankruptcy | The bankruptcy court's own record |

## Opt-out and suppression

| Mechanism | Scope | Durability |
|---|---|---|
| Per-broker opt-out form | One broker | Low — records re-ingest on refresh |
| Statutory deletion mechanisms (California's broker registration and deletion scheme; broker registries such as Vermont's) | Registered brokers in that state | Higher, because it is a legal obligation rather than a courtesy |
| GDPR/UK erasure and objection requests | Any controller in scope | High, and enforceable |
| Paid removal services | Many brokers, automated and repeated | Medium — coverage limited to brokers with an opt-out path |
| Address confidentiality programmes for at-risk individuals | The upstream public records themselves | Highest — fixes the source, not the copy |
| Opting out of the UK open electoral register | One major upstream source | High for that source |
| Holding property through an entity | Land registry | High, but shifts the question to `who-really-owns-it` |
