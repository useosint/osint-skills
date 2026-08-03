---
name: investigate-anything
description: >-
  Start-here router and tradecraft baseline for any investigation into a person, company,
  domain, image or selector. Sets authorised scope, turns a vague request into an answerable
  intelligence question, writes a collection plan, picks the right workflow for the starting
  selector, and applies source grading and competing-hypothesis discipline. Use for
  "investigate this person or company", "do OSINT on X", "where do I start", or any
  open-source intelligence, due diligence, background or attribution task. Applies across due
  diligence, fraud, threat intelligence, journalism and compliance. Reference at
  useosint.com/skills/investigate-anything.
disable-model-invocation: true
---

# Investigate anything

The front door. Everything downstream is faster than the thinking that should
precede it, which is why most bad investigations are not collection failures —
they are framing failures. You can run forty tools against a name and produce a
confident dossier on the wrong person. The work here is deciding what question
you are answering, what would count as an answer, and what would prove you
wrong.

## Core vocabulary

Used across every skill in this repo, defined only here.

- **Selector** — one identifiable data point: name, handle, email, phone,
  domain, IP, wallet, hash, plate, IMO, company number.
- **Pivot** — turning one selector into new selectors (email → breach record →
  reused handle → forum profile → real name). An investigation *is* a chain of
  pivots. Every pivot is also a chance to jump onto a different person.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md), then write down five things:

1. **Subject** — the specific entity, distinguished from anyone with a similar
   name. Write the discriminators you will use ("the J. Okonkwo who is a
   director of company 09xxxxxx", not "J. Okonkwo").
2. **Objective** — see Step 2.
3. **In bounds** — selector types, sources, and whether interaction is allowed.
4. **Out of bounds** — the named things you will not do: logging into anything
   belonging to the subject, contacting them, family members, medical or
   religious data, and any selector unrelated to the objective.
5. **Jurisdiction** — whose law governs you, the subject, and the data. In the
   EU/UK, aggregating scattered public facts about a living person is processing
   personal data and needs a lawful basis and minimisation.

If you cannot state who authorized this and on what basis, stop. Not "proceed
carefully" — stop. An unauthorized investigation cannot be fixed later by a
good report.

**Done when** all five are written down and you can name the specific action
that would put you out of bounds.

## Step 2 — Frame an answerable question

"Find out about X" is not an objective; it has no stopping condition, so it
terminates when you get bored or when you find something that feels like a
result. Rewrite the request until it has a subject, a decision it feeds, and a
condition that would settle it.

| Vague | Answerable |
|---|---|
| Investigate this company | Does this supplier have an undisclosed owner subject to sanctions, and does it operate from the address on the invoice? |
| Who is this account | Is the operator of `@handle` the same person as the named ex-employee, or someone else? |
| Look into this domain | Is `example.com` operated by the same party as the phishing domain, on shared infrastructure? |

Then write the negative: what finding would mean *no*. If nothing could, the
question is unfalsifiable and you will confirm it whatever you see.

**Done when** the objective is one sentence, and you have written what a "no"
answer would look like.

## Step 3 — Write the collection plan before collecting

Aimless pivoting feels productive because every pivot yields something. A
collection plan is the list of *questions*, each mapped to the source most
likely to settle it, ranked by cost and intrusiveness — so you notice when
you're three hours into an interesting branch that answers nothing.

For each question: the indicator that would answer it, the source or skill that
produces it, whether it is passive, and what you do if it comes back empty.
Passive-first, always: exhaust archives, registries, and logs before anything
that touches the subject. Plans are revised as you learn — the point is that
deviations become visible.

**Done when** each objective question has a named source or skill and a
first/fallback order.

## Step 4 — Route by starting selector

Type the workflow skill's name.

| You have | Run |
|---|---|
| A person's name or real identity | `find-anyone` |
| A company, brand, or invoice entity | `x-ray-a-company` |
| A domain, website, or IP | `recon-a-domain-passively` |
| A username or handle | `hunt-a-handle` |
| An email address | `what-an-email-reveals` |
| A phone number | `whose-number-is-this` |
| A photo or video to locate or verify | `where-was-this-taken` |
| A social profile you already attribute | `pattern-of-life-from-socials` |

No clear starting point? Start with the selector that is both **unique and
indexed** — email and domain beat name and handle, because names collide and
handles are claimed by strangers.

Technique skills load themselves when you describe what you are doing. Before
touching anything the subject controls, run `investigate-without-getting-made`.
Keep the case in a graph from the first pivot: `graph-the-network`.

**Done when** the routed workflow has been run and its findings are recorded
with sources.

## Step 5 — Grade sources as you collect, not afterwards

Use the Admiralty (NATO-style) scheme: a **letter for the source** and a
**number for the information**, graded independently, on every item.

- Letter A–F: the source's track record and access. A = reliable history, no
  doubt of authenticity; F = cannot be judged.
- Number 1–6: whether the content is confirmed by other independent sources,
  and whether it is logical in itself. 1 = confirmed elsewhere; 6 = cannot be
  judged.

The independence matters: a corporate registry filing is B2, a well-run
newspaper report of that filing is B2 at best, and an anonymous forum post
repeating the newspaper is D3 — not new corroboration. Grade the *source you
actually touched*, not the source it claims to have. Full grid, worked
examples, and the common misgradings:
[reference/source-grading.md](reference/source-grading.md).

**Done when** every retained finding carries a two-character grade.

## Step 6 — Test hypotheses against each other

Analysis of Competing Hypotheses (ACH) exists because the natural mode of
investigation — pick the likeliest story, look for support — always succeeds.
Support is easy to find for any plausible story.

List every hypothesis including the boring ones ("it is a different person with
the same name", "the account was sold", "the shared IP is shared hosting").
Build a matrix of evidence against hypotheses, and for each cell ask only
whether the evidence is *consistent* with that hypothesis. Then work by column:
the hypothesis with the fewest inconsistencies wins, not the one with the most
support. **Evidence consistent with every hypothesis has no diagnostic value**
— the subject having a LinkedIn does not distinguish anything. A handful of
diagnostic items beats a hundred consistent ones. Worksheet and a filled
example: [reference/ach-worksheet.md](reference/ach-worksheet.md).

**Done when** you have listed at least one hypothesis you did not want and
recorded what evidence would refute your favoured one.

## Where this goes wrong

**Confirmation bias, OSINT edition.** You are given a name and told the person
works in logistics. You find a logistics profile and stop asking whether it is a
different person with the same name. The tell is that your discriminators
disappear once you find a candidate — you selected on them to *find*, then
stopped applying them to *test*. Fix: before you search, write the attributes
the true subject must have and the ones they cannot have; check every candidate
against both. Rejections are findings and belong in the report.

**Circular reporting.** Three sources agree, so you grade it confirmed. All
three copied one blog post, or all three pull from the same aggregator or the
same leaked dataset. This is the single most common cause of confident wrong
attribution, and it is invisible unless you look for it. For each corroborating
source, find its origin: check publication dates in order, look for identical
phrasing or a copied typo, and check whether the "independent" people-search
sites resell the same broker feed — see `dig-through-data-brokers`. Independent
means *different collection*, not different websites.

**Stale data presented as current.** Registries, WHOIS, and broker records
carry the date they were captured, not today's truth. Record the observation
date next to every fact; archive the page via `read-deleted-pages`.

**Selector drift.** Each pivot carries the risk that you have changed people. A
chain of five pivots each 90% likely is a coin flip. Re-anchor: after every
pivot, state which confirmed selector ties the new one to the subject.

**Tool output as evidence.** An enumerator's hit list, a breach aggregator's
match, a face-search score — these are leads. The tool did not verify identity;
it matched a string or a vector.

## Confidence grading

Applies repo-wide unless a technique skill says otherwise.

- **Confirmed** — two or more genuinely independent sources (different
  collection, not different sites), or one authoritative primary record such as
  a signed registry filing, plus nothing contradicting.
- **Probable** — one strong source, or several weak ones that survived a
  circular-reporting check, with the alternative hypotheses tested and weaker.
- **Unconfirmed** — a single uncorroborated lead. Say so in the report; do not
  quietly promote it because later text depends on it.
- **Rejected** — contradicted. Record it and why.

## When to stop

Stop when the objective question is answered to the confidence the decision
requires, or when you can document that available open sources cannot answer it
and name what would (a records request, a subpoena, interviews). "We could not
establish X, having checked A, B and C" is a deliverable, and often the honest
one. Stop also when you cross a scope boundary — that is a re-authorization
event, not a judgement call to make mid-flow.

**Done when** the objective is answered or documented as unanswerable, and
`write-the-intel-brief` has been run.

## Worked example

Objective: is the supplier `Nordvale Trading` on this invoice controlled by the
ex-director of a barred entity? Discriminator: a director DOB month/year.

`x-ray-a-company` returns a registry record with a director "A. Kestrel", DOB
matching, address a mail-forwarding suite. Two people-search sites and a
business-listing site all show the same home address for A. Kestrel — apparent
corroboration, until each is traced back and all three carry the same
misspelling of the street name from one broker feed. Circular; graded D3 and
dropped.

Competing hypotheses: (1) same person, (2) different A. Kestrel, (3) name used
as a nominee. Diagnostic item: the barred entity's filings and Nordvale's list
the same unusual accountancy firm, and the domain in the invoice footer shares a
registrant email with the barred entity's old site (`who-owns-this-domain`).
That is inconsistent with (2), consistent with (1) and (3). Reported as
probable, with the nominee hypothesis flagged as untested, and the gap named:
beneficial ownership is not disclosed in that jurisdiction.

## Pivots

Every workflow feeds `graph-the-network` while it runs and
`write-the-intel-brief` at the end. Selector-to-skill routing is Step 4; the
technique skills each list their own pivots.

## Legal notes

Public availability is not permission. Data-protection law applies to
aggregation of public personal data, and the aggregate is more sensitive than
any part. Terms of service govern automated collection even where the data is
public, and scraping disputes turn on authorization and contract, not on
whether the page was visible. Never authenticate to, probe, or send traffic at
systems belonging to the subject without written authorization.
