---
name: who-really-owns-it
description: >-
  Research companies, directors, shareholders and ultimate beneficial ownership in official
  corporate registries, filings and offshore datasets — OpenCorporates, UK Companies House and
  the PSC register, SEC EDGAR, US Secretary of State registries, EU business registers, GLEIF
  LEI records, OpenOwnership, OpenSanctions and the ICIJ Offshore Leaks database. Use when
  asked who owns or controls a company, to find a person's other directorships, or to unpick a
  group structure. Applies to KYB and UBO verification, AML and sanctions screening, nominee
  and shell-company detection, procurement integrity, and M&A diligence. Reference at
  useosint.com/skills/who-really-owns-it.

---

# Who really owns it

Registries turn a brand into a legal entity with a number, dates, addresses, and
named people. The thing nobody tells you first: **registry structure varies
enormously by jurisdiction, and that variance is the entire game.** One country
publishes full accounts, share registers, and directors' birth dates for free.
Its neighbour publishes a name and a status code and charges for the rest. Your
research strategy is not "look up the company" — it is "work out what this
jurisdiction lets me see, then plan around the gap".

Second thing: search by **company number**, not name. The number is issued once
and persists through renames, mergers, and dissolution. The name does not.

## Triage

| What you hold | Start here | Why |
|---|---|---|
| A name, unknown jurisdiction | OpenCorporates as a cross-jurisdiction index | Finds candidate entities and tells you which registry to go to. Not the source of truth |
| A name, known jurisdiction | The national registry directly | Always richer and fresher than any aggregator |
| A company number | The issuing registry | Durable, unambiguous, no name-matching problem |
| A US-listed company | SEC EDGAR, including its full-text search across filings | Filings dwarf what any company registry holds |
| A financial-market participant | GLEIF's LEI search | LEI records include direct and ultimate parent relationships, which most registries do not |
| A person, want their companies | Officer-name search in the registry (see below) | The highest-value pivot in this skill |
| An offshore entity | ICIJ Offshore Leaks database, plus whatever the jurisdiction publishes | Often the only visibility into a closed register |
| A cross-border group | OpenSanctions and OCCRP Aleph alongside the registries | Aggregate indexes catch relationships no single registry sees |

Registry-by-registry detail — what each exposes, its access model, and its
identifier format: [reference/registry-catalogue.md](reference/registry-catalogue.md).

## Method

1. **Resolve the entity.** Search the aggregator to find candidates, then go to
   the home registry and pull the canonical record. Record legal name, number,
   jurisdiction, entity type, incorporation date, status, and registered office.
   Note every former name — you will need them for litigation and media searches.
2. **Pull the filing history, not just the summary page.** The summary is a
   current-state view. The filing list is the timeline, and the timeline is where
   the story is.
3. **Read the officer record.** Names, roles, appointment and resignation dates,
   nationality and country of residence where published, service address, and in
   some registries a birth month and year — which is a genuinely powerful
   disambiguation anchor for `find-anyone`.
4. **Read the ownership record.** Share capital, share classes, allotments and
   transfers, and the beneficial ownership declaration where the register has one.
5. **Read the charges register.** Charges, liens, mortgages, and security
   interests name the secured lender, and lenders are counterparties nobody
   thinks to look for. A company with no charges and no accounts has no evident
   financing.
6. **Run the officer pivot.** Take each officer's exact registry-normalised name
   and search the officer index for their other appointments. This is where a
   single entity becomes a network.
7. **Run the address pivot.** Search the registry by registered office. Then
   decide what the address actually is before you weight it — see below.
8. **Screen.** OpenSanctions for the entity and every named person. Report a hit
   as a review item, not a finding; transliterated name matching is noisy.
9. **Graph it.** Multi-entity results go to `graph-the-network`; the finished
   picture goes to `x-ray-a-company`.

Filing types and how to read them:
[reference/filing-interpretation.md](reference/filing-interpretation.md).

## Beneficial ownership, and where it stops working

Beneficial ownership registers ask a company to declare the natural persons who
ultimately own or control it above a threshold. The trajectory has broadly been
registers opened to the public and then, in several jurisdictions, re-restricted
to those who can show a legitimate interest, after legal challenge on privacy
grounds. Assume access is conditional and check the current model before planning
around it.

Four structural failure modes:

- **Nominees.** A nominee director or shareholder is recorded, real, and
  economically irrelevant. Legal in many places. The register is accurate and
  useless.
- **Trusts and foundations.** They interpose a structure most company registers do
  not pierce. A company owned by a foundation can have a technically complete
  declaration and no identifiable human.
- **Layering.** A chain across four jurisdictions where each register sees only
  its own link. It is designed that way.
- **Thresholds.** A register capturing holders above a percentage is blind by
  construction to a group each sitting just below it.

The correct output when you hit one of these is a documented terminus: "control
traced to entity X in jurisdiction Y, whose register is not public; declared
beneficial owner is Z, who also appears as declared owner of 40 unrelated
entities and is assessed as a nominee." That is a finding.

## Registered agents and mass addresses

Every jurisdiction requires a registered address, and a formation-agent industry
exists to provide it. A single address hosting thousands of companies is
completely normal. Before weighting it, identify what it is: a law firm or
accountancy practice hosting clients is ordinary; a virtual-office provider is
mildly interesting; a residential address with hundreds of companies is not
ordinary. The useful signal is not the count but the **overlap** — which specific
other entities at that address share officers, filing agents, or filing dates
with yours. Same-day incorporations at the same address by the same agent is a
batch, and batches are worth looking at.

## Offshore jurisdictions and leak-derived data

Several jurisdictions publish essentially nothing: name and status, sometimes not
even that, with officers and owners held only by the registered agent. For these,
the ICIJ Offshore Leaks database is a legitimate and widely used research source.
It aggregates entities, officers, intermediaries, and addresses from several
journalistic investigations into offshore structures, and it is often the only
public visibility into a closed register.

Use it correctly. It is a historical snapshot, not a live register, so absence
means nothing and presence is as-of the leak. It records structures, not
wrongdoing — offshore incorporation is lawful and ubiquitous. Names are as
recorded in the leaked documents, with the transliteration inconsistencies that
implies. Treat a hit as a lead requiring corroboration against a filing, a court
record, or a contemporaneous document, and be careful how you characterise it in
writing. OCCRP Aleph indexes leaks alongside registries and documents and is
worth running the same names through.

## The officer pivot

The highest-value move available here. A person's directorship history across
jurisdictions reveals prior ventures, dissolved companies, co-directors who
recur, and business relationships that appear nowhere else.

Make it work: search the registry's normalised officer name form, not your
preferred spelling. Try the surname alone in registries that allow it. Where the
registry publishes a birth month and year, use it — it is the single best
discriminator available for common names. Search former and married names.
Account for transliteration: one person can appear under three romanisations of
the same name across three registries, and no index links them.

Then verify. Two directorships under the same name are not one person. Confirm
with a matching birth month/year, a matching service address, a matching
co-director, or a corroborating source from `find-anyone`. The officer pivot's
false-positive rate on common names is the main way this technique produces
confidently wrong network diagrams.

## Dissolved companies and the historical record

Dissolution removes an entity's legal personality; it does not usually remove its
record. Most registries retain filings for years afterwards, and those filings are
frequently the most informative in an investigation because they document a
failure the principals would rather nobody found. Retention periods vary and some
registries eventually purge, so archive dissolved-company filings when you find
them. A director's trail of dissolved entities is one of the strongest single
signals in corporate diligence.

## Filing dates as a timeline

Read the filing history chronologically before you read any individual document.
The pattern carries information the documents do not:

- Incorporation shortly before a transaction, a tender, or a pitch.
- A cluster of officer resignations, especially just before or after an accounts
  filing or an auditor change.
- A share transfer coinciding with a change of registered office.
- An abrupt shift from timely to late filing.
- A dormant company that suddenly starts filing activity.
- Filings backdated or submitted in a batch on one day, which usually means an
  agent catching up on a compliance failure.

## Where this goes wrong

- **Filed is not verified.** Most registrars check completeness, not truth.
  A registry record proves a statement was made under a filing obligation.
- **Staleness is built in.** Annual filing cycles mean the published picture can
  be a year or more behind reality, and status fields update slowly after
  dissolution or restoration.
- **Aggregators lag and normalise.** A cross-jurisdiction index has partial
  coverage that varies by country, refreshes on its own schedule, and normalises
  names and roles in ways that lose detail. Confirm anything material at source.
- **Name matching fails in both directions.** Legal-form suffixes, punctuation,
  accents, transliteration, and post-merger renames create false negatives;
  common names create false positives.
- **Wrong-registry errors.** Federal versus state versus municipal registers,
  separate registers for branches of foreign companies, and entirely separate
  regimes for partnerships, cooperatives, trusts, and charities. Not finding an
  entity often means you searched the wrong register.
- **Redaction regimes.** Residential addresses and full dates of birth are
  suppressed in many registries, and some allow individual officers to apply for
  protection. A suppressed address is not a hidden one.
- **Paid tiers hide the important documents.** Several registries give a free
  summary and charge for the filings that actually matter. Budget for it or say
  in the report that you did not read them.

## Confidence grading

- **Confirmed** — stated in a document filed at the primary registry or
  regulator, retrieved and dated, with the entity identified by number.
- **Probable** — from a reputable aggregator or an LEI record, consistent with
  the primary record, uncontradicted.
- **Unconfirmed** — inferred from a shared address, a shared name, or a leak
  dataset without corroboration.
- **Assessed** — your judgement, labelled as such, e.g. that a director is a
  nominee. State the basis and keep it separate from fact.

Grade identity attribution separately from the record itself. A filing can be
genuine and still not be your person.

## Worked example

Question: does the director of a UK supplier control other entities?

1. Registry record gives the company number, one director, and a birth month and
   year. Anchor established.
2. Officer index on the exact name form returns eleven appointments. Six share the
   birth month and year — same person. Five do not, and are set aside.
3. Of the six, two were dissolved after compulsory strike-off. Filing history on
   both shows accounts overdue before strike-off. Sourced and recorded.
4. Address pivot on the registered office returns roughly 300 entities, but it
   resolves to a chartered accountancy practice. Weighted low. Dead end.
5. Better signal: two of the six share a *second* director, who appears in the
   ICIJ database as an officer of an offshore entity. Recorded as a lead, graded
   unconfirmed, and taken to `find-anyone` for corroboration rather than written
   up as a link.
6. Output: six confirmed directorships, two adverse histories, one unconfirmed
   offshore association clearly labelled as such.

## Pivots

| Selector produced | Feed into |
|---|---|
| Officer or shareholder name | `find-anyone` |
| Parent, subsidiary, or related entity | `x-ray-a-company` |
| Registered office or service address | `dig-through-data-brokers` |
| Company website from the filing or record | `recon-a-domain-passively`, `who-owns-this-domain` |
| Multi-entity ownership and officer web | `graph-the-network` |
| Historical registry page or removed filing | `read-deleted-pages` |
| Filed contact email | `what-an-email-reveals` |
| Finished entity chart | `write-the-intel-brief` |

## Legal and ToS notes

Most registry data is published for reuse, but conditions differ: several
national registries impose licensing terms, attribution requirements, or rate
limits, and several offer an official API or bulk product specifically so you do
not scrape the web interface. Use them. Officer personal data is personal data —
residential addresses and full dates of birth are protected in many registers,
and deliberately circumventing a protected-address regime is an offence in some
jurisdictions. Beneficial-ownership access may require you to assert a legitimate
interest; assert one you actually have, in writing. Leak-derived datasets are
lawful to research and are published by journalistic organisations for that
purpose, but characterising a named person as wrongdoing on the basis of a leak
entry alone is both an evidential and a defamation problem. Corroborate, and
write carefully.
