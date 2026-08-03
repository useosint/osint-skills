---
name: find-anyone
description: >-
  Build a sourced, corroborated profile of a named individual from public records, social
  platforms, professional networks, court and property filings, licensing boards, patents,
  papers and obituaries — anchoring the name to a second selector first so you never fuse two
  people into one dossier. Use when asked to find, identify, background-check or profile a
  person, verify someone's claimed employment or credentials, or locate a missing or
  hard-to-reach individual. Applies to counterparty and investor due diligence, fraud and
  asset investigation, journalism, skip tracing, missing persons, pre-employment integrity
  checks on fiduciary roles, and self-exposure audits. Reference at
  useosint.com/skills/find-anyone.
disable-model-invocation: true
---

# Find anyone

Turn a name into a sourced profile of one specific human. The work is 20% finding
data and 80% proving the data belongs to your subject and not to someone with the
same name. Beginners collect first and disambiguate later; that is how you end up
with a confident, well-cited dossier describing two different people fused into
one. Bind the name to a second selector before you collect anything.

## Step 1 — Authorized scope

Write down, before searching: the subject, the objective, what is in bounds, what
is out of bounds, and which jurisdiction's law governs you and the subject. Read
[../../ETHICS.md](../../ETHICS.md).

Built for: counterparty and investor due diligence, fraud and asset
investigation, journalism, skip tracing and debt recovery, missing persons,
pre-employment integrity checks on senior or fiduciary roles, and personal
self-defense — running yourself to see what an attacker would find.

Out of bounds, always: establishing a private individual's home address, routine
movements, children, medical status, immigration status, or sexuality for any
purpose other than a documented lawful one; anything that puts you in contact
with the subject; and any use a reasonable person would call surveillance. If
your objective is to confront, embarrass, or reach the subject in person, stop.
See also the US employment-and-tenancy restriction in
`dig-through-data-brokers`, which binds a large share of the sources here.

**Done when** the scope note exists in the case file, names a lawful objective,
and states an explicit out-of-bounds list.

## Step 2 — Bind the name to a second selector

Never search on a name alone. Pick an anchor and carry it into every query.

| What you hold | First move | Why |
|---|---|---|
| Name + employer | Professional network, company bios, press releases | Employment is the strongest cheap anchor; it dates the person and gives a city |
| Name + city/region | Local records — property, court, voter file where public, local press | Geography prunes namesakes fastest |
| Name + a photo | `find-the-original-image`, then `secrets-in-file-metadata` | A face survives name changes and transliteration |
| Name + email or handle | `what-an-email-reveals`, `hunt-a-handle` | Machine-unique selectors; skip disambiguation almost entirely |
| Name + approximate age | Genealogy, obituaries, licensing records | Age bands split same-name clusters cleanly |
| Name only | Stop. Go back to the requester | A bare common name is not an investigable selector |

Common-name subjects need two anchors, not one. Non-Latin-script names need the
native-script spelling plus the transliterations actually used in your sources —
search all of them, because registries, papers, and press each pick a different
romanisation.

**Done when** you can state a discriminating test — "my subject is the one who
worked at X in Y" — that you will apply to every candidate record.

## Step 3 — Order of operations

Cheapest, highest-yield, lowest-noise first. Do not start with data brokers; they
will hand you plausible wrong answers before you have a way to reject them.

1. **Structured professional record.** Professional networks, employer team pages
   and bios, press releases, conference programmes and speaker pages. Self-published,
   so accurate about role and affiliation and unreliable about achievement.
2. **Published output.** Bylines, papers, patents, standards contributions. Use
   `google-like-a-spy` with `site:` and exact-phrase operators. Papers carry an
   institutional affiliation and often an ORCID, which exists specifically to
   solve name ambiguity; patents carry an inventor city and an assignee company.
3. **Regulated-role registers.** Licensing and professional boards publish name,
   licence number, jurisdiction, status, and often disciplinary history. If your
   subject claims a regulated role, this both confirms and dates it.
4. **Corporate record.** `who-really-owns-it` for directorships and shareholdings.
   The officer-name pivot is the highest-yield single step for anyone with
   business involvement.
5. **Public legal and property records.** Court dockets, judgments, insolvency,
   and land registers — where and only where public in that jurisdiction.
6. **Social and behavioural.** `hunt-a-handle` to enumerate accounts, then
   `pattern-of-life-from-socials`. Deliberately late: noisiest layer, easiest to
   misattribute.
7. **Aggregators.** `dig-through-data-brokers`, last, and only for leads you then
   confirm against a layer above.
8. **Historical.** `read-deleted-pages` for removed bios and old team pages —
   often the richest single source, because people scrub current pages and forget
   the archive.

Full source catalogue with what each one can and cannot prove:
[reference/source-catalogue.md](reference/source-catalogue.md).

**Done when** each layer has been worked or explicitly recorded as
not-applicable, with a reason.

## Step 4 — Record provenance as you collect

Every claim gets, at capture time: the claim, the source URL, the access date, a
saved copy or archive snapshot, and which anchor let you attribute it to your
subject. Reconstructing citations at the end always fails — the page will have
changed, and you will no longer remember why you believed record 14 was the
right person.

Corroboration standard: **two independent sources per claim.** Independent means
different origin, not different website. Three brokers agreeing is one source,
because they buy from each other. A company bio and a press release from the same
communications team is one source. A registry filing and a bylined news article
are two.

**Done when** every claim in the case file carries a source, a date, and an
attribution basis.

## Step 5 — Back out when it is a different person

Actively hunt the disconfirming detail. Signals you have crossed onto a namesake:
an age or graduation year off your band by more than a few years; a location with
no plausible bridge to a known one; a career discontinuity requiring two
full-time roles at once; a middle initial that conflicts rather than merely being
absent; a relatives cluster sharing no member with the one you already had.

Do not quietly drop the record. Split the file: maintain a candidate set, and
record for each candidate what would confirm or eliminate it. Fusing two people
destroys the whole product, and it is invisible in the finished brief unless you
tracked candidates explicitly.

**Done when** every collected record is assigned to a named candidate, and the
non-subject candidates are documented rather than deleted.

## Step 6 — Family and associate structure

Only when the objective requires it. Obituaries name survivors with relationships
and cities and are the most efficient family-structure source there is; genealogy
and civil-registration indexes give births, marriages, and deaths where published;
co-directorships and co-authorship give professional associates. Treat relatives
as context for disambiguation, not as targets — pivoting a full investigation
onto an uninvolved family member is out of bounds.

**Done when** relationships used in the brief are sourced, and no uninvolved
third party has been profiled.

## Step 7 — Report

Hand off to `write-the-intel-brief`. Separate confirmed facts from inference,
state the disambiguation basis up front, list the candidates you eliminated, and
cut anything collected that the objective does not need.

**Done when** the brief states its confidence grade per claim and its
disambiguation basis, and the surplus collection has been deleted.

## Where this goes wrong

- **Name collision is under-estimated.** Even an unusual name is often shared
  within one family — juniors, seniors, and cousins named for the same
  grandparent live in one city and appear in the same records.
- **Aggregators launder each other's errors.** A wrong middle initial or a merged
  household entered once propagates everywhere and then looks corroborated.
- **Self-published bios are aspirational.** Titles inflate, dates round, degrees
  get upgraded. Confirm credentials at the issuing institution or register.
- **Absence of record is not absence of fact.** A sparse footprint may mean a
  private person, a non-English footprint, a recent immigrant, or closed
  registries. It is not evidence of concealment.
- **Photo matching is over-trusted.** The same headshot on two profiles proves
  the profiles share an image, not a person — scrapers, stock photos, and
  impersonation accounts all reuse images. Confirm with a second selector.
- **Name changes break continuity.** Marriage, transliteration, pseudonyms, and
  legal changes split one trail into two, and older records under a prior name
  will not link themselves.
- **You may be looking at a synthetic identity.** Fraud cases produce subjects
  whose tidy, recent, shallow footprint is manufactured. A profile with no
  pre-existing history is itself a finding.

## Confidence grading

- **Confirmed** — two independent sources, at least one primary (a registry
  filing, a court record, a licensing board entry, an institutional page), that
  agree on the claim *and* on a shared discriminating anchor.
- **Probable** — one primary source, or two secondary sources with an anchor
  match, and no contradicting record found.
- **Unconfirmed** — single secondary source, aggregator-only, or anchor match
  that relies solely on name plus a broad region. Report it as a lead.
- **Rejected** — assigned to a different candidate. Keep it in the file with the
  reason.

Grade the *identity attribution* separately from the *claim*. A court record can
be entirely genuine and still not be your subject's.

## Worked example

Objective: pre-investment diligence on "Marcus Rowntree", named as CTO of a
vendor, anchor = the employer.

1. Company team page gives role and a headshot. Archive it — vendor sites churn.
2. Exact-phrase search on name plus company surfaces two conference talks with
   the same headshot and a stated prior employer. Anchor now two-deep.
3. Officer search in `who-really-owns-it` on the surname returns four directorships.
   Three list a birth month and year matching the conference bio's implied age
   band; one is in a different country with a birth year eleven years off —
   split off as candidate B, documented, not used.
4. Dead end: an aggregator profile ties the name to a bankruptcy. The listed
   middle initial conflicts and the city has no bridge to any known location.
   Assigned to a third candidate; the bankruptcy does not enter the brief.
5. Prior employer claim fails to corroborate — no press, no archived team page,
   no filing. Graded unconfirmed and flagged as a diligence question, which is
   itself the useful finding.

## Pivots

| Selector produced | Feed into |
|---|---|
| Username or display name | `hunt-a-handle` |
| Email address | `what-an-email-reveals` |
| Phone number | `whose-number-is-this` |
| Photograph | `find-the-original-image`, `secrets-in-file-metadata` |
| Photo with a location question | `where-was-this-taken` |
| Company name or registry number | `x-ray-a-company`, `who-really-owns-it` |
| Personal or vanity domain | `recon-a-domain-passively` |
| Confirmed social accounts | `pattern-of-life-from-socials` |
| Address, relatives, prior cities | `dig-through-data-brokers` |
| Deleted bio or old profile | `read-deleted-pages` |
| Finished evidence set | `write-the-intel-brief` |

## Legal notes

In the EU and UK, profiling a living person is processing personal data: you need
a lawful basis, and journalism, legal claims, and legitimate interests are
distinct bases with distinct limits. The subject may hold access and erasure
rights against you. In the US, using aggregator data for employment, tenancy,
insurance, or credit decisions outside a regulated consumer reporting agency is a
compliance violation however public the data feels — see
`dig-through-data-brokers`. Driver and vehicle records are restricted-purpose in
many jurisdictions. If your research is adverse and might reach proceedings,
capture evidence so it survives challenge: timestamped, hashed, archived.

For self-defense, run this workflow on yourself, use the opt-out guidance in
`dig-through-data-brokers`, and use `investigate-without-getting-made` so the
searching itself does not create new exposure.
