---
name: write-the-intel-brief
description: >-
  Turn findings into a defensible intelligence product — BLUF key judgements, standardised
  estimative probability language, per-claim sourcing with timestamps and archived copies,
  separated observation, inference and assessment, documented negative findings and gaps,
  chain of custody and hashing, and redaction of uninvolved parties. Use when writing an
  intelligence report, due-diligence memo, evidence pack or executive summary, or when asked
  to write up an investigation so it survives challenge. Applies to regulated compliance
  reporting, litigation and disclosure, board and investment committee reporting, and
  law-enforcement referral. Reference at useosint.com/skills/write-the-intel-brief.
disable-model-invocation: true
---

# Write the intel brief

The report is the only part of the investigation anyone else sees, so it is the
only part that can be wrong in public. The failure that destroys credibility
isn't a missed source — it's a sentence that reads as fact and is actually an
inference. "The account is operated from Lisbon" versus "posting times cluster
in UTC+0/+1, consistent with Iberian working hours." One survives cross-
examination.

## Step 1 — Sort every claim into observation, inference, or assessment

Three categories, never blurred, ideally visually distinct in the text.

- **Observation** — what you saw, with source and timestamp. "The registry
  record retrieved 2024-03-11 lists A. Kestrel as director."
- **Inference** — a logical step from observations, with the step shown. "The
  same registrant email appears on both domains, so they were registered by one
  party."
- **Assessment** — your analytic judgement, carrying probability and confidence.
  "We assess it is likely the two companies are commonly controlled."

Any sentence where you cannot say which category it belongs to is a sentence
that has smuggled a conclusion into the evidence. Rewrite it. Verbs betray the
category: *is, lists, shows* for observation; *indicates, implies* for
inference; *we assess, we judge* for assessment. Watch out for "appears to be",
which pretends to be observation and is inference.

**Done when** every claim is tagged and no inference is written in the
grammatical form of an observation.

## Step 2 — Attach source, timestamp, and an archived copy to every claim

A claim with no source does not go in the report. Not in a footnote, not
"multiple sources" — the specific one, per claim.

Each source needs: the URL or the tool and its exact query; the UTC date-time
you retrieved it; the source-reliability grade (see `investigate-anything`); and
an archive reference. Live URLs rot, and hostile subjects delete. Archive
everything you cite, at the moment you cite it, using `read-deleted-pages` —
cite the snapshot alongside the live URL, and keep a local copy too, since
public archives can themselves be removed on request.

For anything that might become evidence, add chain of custody: who collected
it, when, with what tool and version, and a cryptographic hash of the stored
file (`sha256sum file` on Linux, `shasum -a 256 file` on macOS). Record the hash
in the report, keep the original untouched, and work on copies. A screenshot
with no hash, no timestamp and no capture method is worth very little; the
underlying HTML, headers, and image files are worth more.

**Done when** every retained claim has source, retrieval timestamp, grade, and
archive reference, and evidentiary items also have hashes.

## Step 3 — Lead with the judgements

Assume the reader stops after the first half page — because they will. BLUF:
the answer to the objective question first, in plain language, with its
probability and confidence. Then the two or three judgements that carry the
decision. Background, method and detail come after, for the reader who needs to
audit you.

A key judgement is one sentence, one judgement, with its estimative term, its
confidence, and the reason compressed to a clause. If a judgement needs a
paragraph of setup to make sense, it isn't a judgement yet.

**Done when** the objective question is answered in the first paragraph, and
the answer would still be defensible if nothing else were read.

## Step 4 — Use the probability ladder, and only it

"Possibly" everywhere is how a report says nothing at length. Standardise on one
ordered set of terms and use them consistently:

**almost certainly · highly likely · likely · roughly even chance · unlikely ·
highly unlikely · remote**

Rules that make it work: never use a term outside the ladder; never mix in a
numeric percentage in the same sentence as a word, since readers anchor on the
number; never use "possible" as an estimate, because everything not excluded is
possible; and print the ladder in the report so the reader maps words to ranges
the same way you did. Full table with ranges, the near-synonyms to avoid, and
worked rewrites: [reference/estimative-language.md](reference/estimative-language.md).

**Probability and confidence are different axes.** Probability is how likely the
judgement is to be true. Confidence is how good the evidence underneath it is —
source quality, corroboration, and the presence of gaps or plausible deception.
You can legitimately write "highly likely, low confidence": the evidence points
strongly one way but rests on a single unverifiable source. That sentence is
honest and useful. Collapsing the two into one word is not.

**Done when** every assessment carries one ladder term and a stated confidence
level, with the reason for the confidence given.

## Step 5 — Write the negative findings

Juniors delete these because they feel like failure. They are frequently the
most useful content in the report: they are what stops the next analyst
repeating the work, and in due diligence and pre-employment contexts the
absence of adverse findings is the deliverable.

State what you looked for, where you looked, and what you did not find —
distinguishing "checked, absent" from "could not check". "No sanctions or
enforcement listings for the subject in the OFAC, UK, and EU consolidated lists,
checked 2024-03-11" is a finding. "No adverse media found" without naming the
sources searched, the languages, and the date range is not a finding, it is a
shrug. Record rejected leads and candidates too, with the reason for rejection.

**Done when** searched-and-empty, could-not-check, and rejected-candidate items
are each written up with scope and dates.

## Step 6 — Document method and gaps

Reproducibility is what separates an intelligence product from an opinion.
Record the tools with versions, the exact queries and dorks, the databases and
their coverage dates, the languages searched, and anything that shaped the
result: rate limiting, geo-restricted content, paywalls, a persona's access
level, deleted material recovered only from archives.

Gaps go in the body, not buried at the end: what could not be established, why
(no public registry in that jurisdiction, platform requires authentication,
records are sealed), and what would close it — a records request, a subpoena, a
site visit. Naming the closed source is a service to whoever reads it.

**Done when** another analyst could re-run the collection from the report alone
and get the same result, and every unanswered objective question has a named
reason and a route.

## Step 7 — Minimise, redact, and format for the audience

Collect broadly, publish narrowly. Remove everything not needed for the
objective — especially data about uninvolved third parties who appeared in the
collection: family members, neighbours, co-residents at an address, bystanders
in photographs, unrelated people sharing the subject's name. Redact rather than
delete where the item explains a reasoning step, and say what was redacted and
why, so the redaction itself is auditable. Never publish full national-ID
numbers, payment card numbers, credentials, or plaintext passwords from breach
data; reference them by type and partial value. Keep the unredacted case file
separately, encrypted, under the retention limit in
[../../ETHICS.md](../../ETHICS.md).

Then match the format to the reader:

| Audience | Shape |
|---|---|
| Client or executive | One-page BLUF, judgements with probability and confidence, business implication, no tool names in the body |
| Incident responder | Judgements plus a machine-usable indicator table (selectors, first/last seen, confidence) and the raw artefacts |
| Legal or regulatory | Observation-only body, inferences separated and labelled, chain of custody and hashes per exhibit, method appendix, nothing redacted without a log |
| Internal handover | The graph from `graph-the-network`, the collection plan with what was and wasn't done, and every dead end |

Template with all sections, and the evidentiary variant:
[reference/report-template.md](reference/report-template.md).

**Done when** the report contains no third-party data the objective doesn't
need, and the format matches the named audience.

## Where this goes wrong

- **Inference laundering.** An inference stated on page 2, repeated as
  background on page 5, cited as established on page 8. Watch for your own
  claims re-entering as facts.
- **Confidence inflation from volume.** Forty low-grade items feel like a lot.
  Grade quality, not count; check for circular reporting before any
  corroboration claim.
- **The hedge that means nothing.** "It cannot be ruled out that" is true of
  everything. Either estimate it or drop it.
- **Screenshots as evidence.** Trivially forged and easily misread. Cite the
  archived original; use a screenshot only as an illustration next to it.
- **Report written from memory.** Reconstructing sources afterwards produces
  citations to pages that no longer say what you remember. Cite as you collect.
- **The wrong-person catastrophe.** Everything above is fine and the subject is
  the wrong human being. Restate the discriminators in the report and show which
  evidence ties the findings to *that* individual specifically.
- **Distribution.** Once sent, it is copied forever. Mark handling, name the
  recipients, and assume onward sharing.

## Confidence grading

- **High confidence** — multiple independently collected sources, at least one
  authoritative primary record, consistent, no plausible deception, no material
  gap.
- **Moderate confidence** — credible sourcing with partial corroboration, or a
  gap that does not touch the core judgement.
- **Low confidence** — single source, unverifiable sourcing, significant gaps,
  or a live possibility of manipulation. Still publishable — say why it is low
  and what would raise it.

State the confidence next to the judgement, not in a preamble the reader skips.

## Worked example

Objective: does the supplier share control with a barred entity?

BLUF: "It is **likely** (moderate confidence) that Nordvale Trading and the
barred entity share beneficial control."

Observation: both filings name the same accountancy firm; both domains resolve
to a registrant email `admin@ke-holdings.example` (retrieved 2024-03-11,
archived). Inference: a shared registrant email indicates one registering party.
Assessment: likely common control — moderate, not high, because the beneficial
owner is undisclosed in that jurisdiction and a nominee arrangement remains
untested.

Negative finding included: the shared home address reported by three
people-search sites was traced to one broker feed carrying an identical
misspelling; recorded as circular and excluded. Redacted: two co-residents at
that address, unrelated to the objective. Gap named: UBO register is
non-public; a formal request would close it.

## Pivots

The report is the terminal product; it consumes rather than produces selectors.
Take the entity map from `graph-the-network`, the archived copies from
`read-deleted-pages`, and the scope statement from `investigate-anything`.
Unresolved indicators go back to the workflow that produces them.

## Legal notes

An OSINT report about a living person is personal data in its own right, and the
subject may have access rights to it in some jurisdictions — write every line as
if the subject will read it, because they may be entitled to. Reports likely to
be used in proceedings need the evidentiary format from Step 7 and unbroken
custody; a report assembled loosely and reformatted later cannot recover
custody it never had. Breach-derived material carries its own handling
constraints — see `what-leaked-about-you` — and quoting credentials into a
report can itself be unlawful processing.
