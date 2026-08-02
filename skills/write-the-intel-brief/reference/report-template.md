# Report templates

Three shapes: the standard report, the evidentiary variant, and the one-page
client brief. Delete sections that do not apply — but write "None" or "Not
checked", never leave one silently absent, because a missing section reads as an
oversight and a "None" reads as a finding.

## Standard OSINT report

```markdown
# OSINT report — <subject>

Analyst: <name/handle>            Report date: <YYYY-MM-DD>
Collection period: <YYYY-MM-DD to YYYY-MM-DD>   All times UTC.
Requester: <who asked>            Handling: <distribution / retention>
Authorization basis: <mandate, contract, lawful basis, jurisdiction>

Subject and discriminators:
<the specific entity, and the attributes distinguishing it from same-named others>

Objective:
<the one-sentence answerable question>

Scope: in bounds <...>  |  out of bounds <...>

Probability ladder: almost certain · highly likely · likely · roughly even
chance · unlikely · highly unlikely · remote
Confidence: high / moderate / low — quality of the underlying evidence, not
the probability of the judgement.
Source grades: letter A–F source reliability, digit 1–6 information credibility.

## Bottom line

<Answer to the objective question in one or two sentences, with its ladder term
and confidence. Written so it stands alone if nothing else is read.>

## Key judgements

1. <Judgement>. **<ladder term>**, <confidence> confidence — <the reason, one clause>.
2. ...

## What was observed

<Facts only. Each with source, retrieval timestamp, grade, archive reference.
No inference verbs in this section.>

| # | Observation | Source | Retrieved (UTC) | Grade | Archive |
|---|---|---|---|---|---|
| O1 | | | | | |

## Inferences

<Each inference names the observations it rests on and shows the step.>

- I1 — from O2 and O5: <inference>. Alternative explanation considered: <...>.

## Assessment

<Analytic judgement. Include the competing hypotheses considered and why the
leading one was preferred — see the ACH worksheet in `investigate-anything`.>

## Entity map

<Graph or node/edge tables from `graph-the-network`. Edge confidences shown.>

## Negative findings

- Checked and absent: <what, where, date range, languages>.
- Could not check: <what, and why — paywall, authentication, no public register>.
- Candidates rejected: <candidate, reason for rejection>.

## Method

Tools and versions, exact queries, databases and their coverage dates,
languages, personas used and their access level, anything that constrained
collection (rate limiting, geo-restriction, robots/ToS limits observed).

## Gaps and what would close them

| Gap | Why open | What would close it | Available? |
|---|---|---|---|

## Recommendations

<Proportionate to the objective. Say what decision each supports.>

## Appendix A — source list

<Every URL, tool, query, with retrieval timestamps and archive references.>

## Appendix B — redaction log

<What was removed or masked, and why. Third parties redacted by category.>
```

## Evidentiary variant

For material that may reach a regulator, a court, or a disciplinary process.
Same skeleton, with these changes:

- **Body is observation-only.** Inference and assessment move to a clearly
  separated, separately paginated section, or into a second document.
- **Exhibit register**, one row per artefact:

```markdown
| Exhibit | Description | Collected by | Collected (UTC) | Method / tool + version | Source URL | Archive URL | SHA-256 | Storage location |
|---|---|---|---|---|---|---|---|---|
| EX-001 | | | | | | | | |
```

- **Hashing.** Hash at the moment of collection, before any processing:
  `sha256sum <file>` (Linux) or `shasum -a 256 <file>` (macOS). Record the hash
  in the register and re-verify before submission. Keep originals immutable and
  work on copies; note every transformation (cropping, conversion, redaction)
  as a derived exhibit with its own hash.
- **Capture completeness.** Prefer the underlying artefact over a picture of it:
  saved HTML plus HTTP response headers, the original image file with metadata
  intact (see `secrets-in-file-metadata`), the API response as returned. A
  screenshot is a supplement, not the exhibit.
- **Continuity.** Every transfer of custody logged with who, when, and how.
- **No silent redaction.** Every redaction logged; the unredacted original is
  retained and hashed.
- **Analyst statement.** Name, role, qualifications, the tasking, the method,
  and a declaration of what was and was not done.

## One-page client brief

```markdown
# <Subject> — <objective, phrased as a question>
<Date> · Prepared for <client> · <handling marking>

**Bottom line.** <One sentence answer, ladder term, confidence.>

**What this means for you.** <Two or three lines of consequence: the decision
this supports, the risk it changes.>

**Key judgements.**
- <judgement> — <ladder term>, <confidence>
- <judgement> — <ladder term>, <confidence>

**What we did not find.** <Negative findings in plain language — usually the
part the client most needs.>

**Limits.** <Two lines: the main gap and why it is open.>

Full report, sourcing and method: attached.
```

Keep tool names, query syntax, and selector tables out of the client brief; they
belong in the full report. The client brief is a decision document, and every
line that is not decision-relevant reduces the chance the decision-relevant ones
get read.
