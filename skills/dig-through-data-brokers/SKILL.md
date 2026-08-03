---
name: dig-through-data-brokers
description: >-
  Use people-search aggregators and primary public records to find addresses, phone numbers,
  relatives, age and background on a person, and to audit and remove your own exposure. Covers
  Spokeo, BeenVerified, Whitepages, TruePeopleSearch, FastPeopleSearch, That'sThem, Radaris,
  Intelius and Pipl, plus voter files and county court and property records. Use when running
  a people search or reverse address lookup, tracing a debtor or missing person, building a
  subject's address history, or removing yourself from broker sites. Applies to skip tracing
  and debt recovery, asset investigation, executive protection, and personal exposure audits.
  Explains the FCRA limits that bar broker data from employment, tenancy, insurance and credit
  decisions, and the GDPR position. Reference at useosint.com/skills/dig-through-data-brokers.

---

# Dig through data brokers

People-search sites resell a blend of public records, marketing data, and
self-reported data. They are fast, cheap lead generators and terrible evidence.
The one rule that matters: **a broker record is a lead, never a fact.** Confirm
every field you intend to use against the primary source the broker got it from —
and if you cannot identify that primary source, do not use the field.

## What these services actually are

Three input streams, blended and sold:

- **Public records** — property deeds, court filings, business registrations,
  voter files where public, professional licences, bankruptcy, marriage and
  divorce. Authoritative at origin; the broker's copy is a stale transcription.
- **Marketing and commercial data** — warranty cards, loyalty programmes,
  subscriptions, credit-header data, online forms, ad exchanges. Never verified,
  often inferred, frequently household-level rather than person-level.
- **Self-reported and scraped** — profiles, résumés, forum posts, and whatever the
  broker's own users typed in.

They also buy from each other, constantly. That is the most important structural
fact about the category: one wrong record propagates across every brand, and
cross-checking five brokers gives you five copies of one error wearing five hats.
Apparent corroboration across brokers is worth close to nothing.

## Why the data is wrong

- **Address history is append-only in practice.** Brokers add addresses and rarely
  retire them, so a "current address" is often several moves old.
- **Household merging.** Two people at one address, or two people with the same
  name in one metro area, get fused into one profile. Same-name relatives —
  father and son, cousins named for the same grandparent — merge constantly.
- **Relatives are inferred, not recorded.** "Relatives" and "associates" lists are
  usually address-co-occurrence: former roommates, landlords, and the previous
  occupant show up as family.
- **Age is derived.** Often from a birth year in a credit header or a voter file,
  and often off by a year or displayed as a band.
- **Phone data ages fastest.** Number portability and prepaid churn mean carrier
  and line-type attributions decay quickly — see `whose-number-is-this`.
- **Corrections do not propagate.** Getting one broker to fix a record does not
  fix the upstream source or the six downstream buyers.

## Triage: what to reach for first

| What you hold | Better than a broker | Use a broker for |
|---|---|---|
| Name + city | Local property and court records, voter file where public | Generating a candidate address list to check against those records |
| Phone number | Carrier/line-type lookup via `whose-number-is-this` | Reverse lookup to a candidate name, then confirm elsewhere |
| Email address | `what-an-email-reveals` | Reverse lookup to a candidate name |
| Name + need for relatives | Obituaries — far more accurate and they state the relationship | A first-pass household cluster to test against the obituary |
| Name + need for employment | Professional networks, licensing boards, corporate registries | Nothing. Broker employment data is the worst field they sell |
| Name + need for assets | Property registry, court judgments, `who-really-owns-it` | Nothing usable |
| Your own name (self-audit) | Nothing — brokers *are* the target | Enumerating your exposure before opting out |

The honest summary: brokers are for turning a name into candidate selectors when
you have nothing else, and for auditing your own footprint. For every claim you
intend to publish or rely on, go to the primary record.

## Method

1. **Anchor first.** Do not run a bare name. Carry the disambiguating anchor from
   `find-anyone` into every search, and treat any result that fails the anchor
   test as a different person.
2. **Search a small number of brokers deliberately**, not all of them. Pick ones
   with different upstream sources rather than different brands.
3. **Extract selectors, not conclusions.** You want candidate addresses, phones,
   emails, middle names, age bands, and associated names. Each is a lead to test.
4. **Confirm each against a primary source.** Address → property or court record.
   Age → voter file, licensing record, or a document with a date of birth. Employment
   → the employer or a register. Relatives → an obituary or civil-registration index.
5. **Record which fields you confirmed and which you dropped.** A broker field that
   survived confirmation is now cited to the primary source, not to the broker.
6. **Pivot the confirmed selectors** into the technique skills in the table below.

Primary-source catalogue by jurisdiction and record type, with access and legal
notes: [reference/source-catalogue.md](reference/source-catalogue.md).

## The free-tier bait pattern

The business model is a teaser. Expect: a result page confirming a match exists
with characters masked; counts ("8 phone numbers, 12 addresses") designed to imply
depth; padding with public data the broker did not pay for; a progress animation
implying live searching that is actually a checkout funnel; a "report" that
arrives as an auto-renewing subscription with an awkward cancellation path; and
results for names that do not exist, because the funnel runs regardless.

Never treat a teaser count as evidence, and assume any paid tier bills until you
actively stop it. Some brokers do offer genuine investigator or business tiers
with contractual use restrictions — a different product, with obligations you
agree to when you sign.

## FCRA and the rule that actually binds you (US)

In the US there is a legal line between two things that look identical:

- A **consumer reporting agency** is regulated under the Fair Credit Reporting
  Act. It must maintain accuracy procedures, give consumers access and dispute
  rights, and only furnish reports for permissible purposes.
- A **data broker / people-search site** is not a CRA, disclaims FCRA compliance
  in its terms, and has none of those obligations.

The rule: **you must not use non-FCRA broker data to make decisions about
employment, tenancy, credit, or insurance.** That includes screening a job
applicant, vetting a tenant, or checking a contractor you are about to hire. If
the decision is one FCRA covers, you must go through a regulated CRA and follow
its process, including notice and adverse-action requirements. The broker's own
terms will say this; it is not decoration, and both the broker and the user have
been the subject of enforcement over it. This is the single most common way
otherwise-legitimate investigators create real liability.

Related US restrictions worth knowing: motor vehicle and driver records are
restricted to enumerated purposes under the Driver's Privacy Protection Act, and
some states restrict voter-file use to electoral purposes.

## GDPR and the UK/EU position

The US-style people-search market barely exists in Europe, and what does exists on
much thinner data. Durable reasons: aggregating and publishing personal data needs
a lawful basis, and "we bought it" is not one; transparency obligations require
telling the data subject you hold their data, which is fatal to a scraped
aggregation business; special-category data is stricter again; and subjects have
access, rectification, erasure, and objection rights that are cheap to exercise
and expensive to service. Electoral registers, land registries, and court records
are correspondingly more restricted than their US equivalents.

If you are in scope of GDPR, *your* case file is processing too. You need a lawful
basis, a retention limit, and a defensible answer if the subject asks what you
hold. Legitimate interests is available but requires a documented balancing test.

## Self-defense: audit and remove your own exposure

The most valuable use of this skill for most people. Run yourself through the
major brokers, record every profile URL, then work each opt-out. What to know:

- Opt-outs are per-broker, deliberately tedious, and usually require finding your
  own profile URL first. Some require email confirmation; some require identity
  documents, which is its own risk.
- Removals lapse. Brokers re-ingest from upstream, so a removed profile reappears
  after a refresh cycle. It is recurring maintenance, not a one-time job.
- Paid removal services automate the tedium across many brokers; they cannot reach
  brokers with no opt-out, and they do not touch the public records underneath.
- Jurisdiction helps. California created a broker registration requirement and a
  statutory deletion mechanism intended to let a resident request deletion across
  registered brokers at once; Vermont maintains a broker registry. Statutory
  rights are more durable than per-site forms — use them.
- The upstream source is the real fix: address confidentiality programmes for
  at-risk people, opting out of the UK open electoral register, and holding
  property through an entity are structural rather than cosmetic.

## Searching yourself leaves a trace

Assume every search you run is logged, sold, and potentially visible.

- Broker searches are logged against your account, IP, and payment identity, and
  the search itself is data the broker can sell.
- Some professional and social platforms notify a subject that you viewed their
  profile, or surface you via contact-graph inference — uploading a contact list
  is how investigators most often get made.
- Some paid and investigator tiers notify the subject or generate a record
  accessible to them; credit-header products can leave an inquiry trail.
- Searching your own name from your own account creates the strongest possible
  association between you and your identifiers.

Use `investigate-without-getting-made` before touching any of this on a sensitive
matter. Minimum: a separate browser profile, no account reuse, and never the
case's real contact details in a signup form.

## Where this goes wrong

- **Confidence from repetition.** Five brokers, one upstream vendor, one error.
- **Merged people presented as one.** The profile looks coherent because the
  merge is invisible; two address clusters in unconnected regions is the tell.
- **Deceased subjects.** Records persist and sometimes merge with a same-name
  living relative — a specific and damaging failure.
- **Recency illusion.** "Last updated" reflects when the broker refreshed its
  copy, not when the underlying fact was true.
- **Coverage collapses outside the US.** Thin to nonexistent elsewhere; absence
  of a result for a non-US subject means nothing at all.
- **Under-representation of the mobile and the young.** People who rent, move
  often, are recent immigrants, or have never held property or a landline are
  systematically thin in these datasets. Sparse results are a sampling artefact.
- **Suppressed subjects.** People who have opted out, or who are enrolled in an
  address confidentiality programme, produce a clean result that is not evidence
  of anything.

## Confidence grading

- **Confirmed** — the field is corroborated by a primary record (deed, court
  filing, licence, registration) that names your subject and matches your anchor.
  Cite the primary record; the broker drops out of the chain entirely.
- **Probable** — corroborated by one independent non-broker source, with the
  anchor matching and no conflicting record.
- **Unconfirmed** — appears only on brokers, however many. Report as a lead with
  the anchor basis stated.
- **Rejected** — fails the anchor test, or conflicts with a primary record.
  Keep it in the file assigned to a different candidate.

Never grade a claim higher because more brokers agree.

## Worked example

Skip trace on a judgment debtor: name plus a last-known city.

1. Two brokers return a profile with four addresses across two states, an age of
   47, and six "relatives".
2. Anchor test: the debtor's known employer city matches only two of the four
   addresses. The other two go to a candidate B file.
3. County recorder for the matching county shows a deed in the subject's name at
   address 2, sold three years ago. Address 2 is confirmed as historical, not
   current — the broker showed it as current.
4. Dead end: a "relative" with a distinctive surname turns out, via the obituary
   of the actual relative, to be a prior occupant of address 2. Dropped.
5. Address 1 has no property record. The utility of the broker here was narrowing
   four addresses to one with a real document behind it; everything else was noise.
6. Confirmed selectors — one prior address, one middle initial from the deed —
   go to the court file for the current service address.

## Pivots

| Selector produced | Feed into |
|---|---|
| Candidate name from a reverse lookup | `find-anyone` |
| Email address | `what-an-email-reveals` |
| Phone number | `whose-number-is-this` |
| Username or screen name | `hunt-a-handle` |
| Employer or business name | `x-ray-a-company`, `who-really-owns-it` |
| Address tied to a company | `who-really-owns-it` |
| Removed or changed broker profile | `read-deleted-pages` |
| Relatives and associates cluster | `graph-the-network` |
| Your own exposure inventory | `what-leaked-about-you` |

## Legal and ToS notes

Scraping these sites breaches their terms and most deploy active anti-automation;
the business tiers exist precisely to sell you the API instead. Bulk collection of
personal data has its own exposure under computer-misuse and data-protection law
depending on where you and the data sit. Do not use non-FCRA data for FCRA-covered
decisions. Do not use broker data to locate a person who has taken steps to be
unlocatable unless you have a documented lawful basis — a court order, a
skip-trace mandate, an active investigation — and read [../../ETHICS.md](../../ETHICS.md)
before you start. This category is the raw material of doxxing and stalking, and
the same lookup is legitimate or criminal depending entirely on the objective you
wrote down at the start.
