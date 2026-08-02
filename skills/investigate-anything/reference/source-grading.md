# Source reliability and information credibility grading

The Admiralty Code (also called the NATO system, and used in allied intelligence
doctrine and by many police forces as the "5x5x5" variant) grades two things
separately with one letter and one digit, written together: `B2`, `A1`, `F6`.

The whole point is the separation. A reliable source can pass on something
unverified (`A5`). An unreliable source can report something you have confirmed
elsewhere (`E1`). Collapsing them into a single "confidence" number destroys the
distinction and is the most common misuse.

## Source reliability (letter)

Judges the *source*, based on its history and its access — not this particular
item.

| Grade | Meaning | Typical OSINT examples |
|---|---|---|
| A | Reliable. No doubt of authenticity, trustworthiness or competence; consistent history of accuracy. | A signed filing obtained directly from the official registry; a certificate transparency log entry; a court's own docket system. |
| B | Usually reliable. Minor doubts; mostly valid history. | An established news organisation with a corrections policy; a well-maintained regulator database; a mainstream WHOIS/RDAP response. |
| C | Fairly reliable. Some doubt; has provided valid information in the past. | A trade publication; a reputable but small research blog; a commercial threat-intel feed you have spot-checked. |
| D | Not usually reliable. Significant doubt; has provided both valid and invalid information. | A people-search aggregator; an unmoderated wiki; a marketing data broker. |
| E | Unreliable. History of invalid information. | An anonymous forum account with an agenda; a known disinformation outlet; a "leak" channel that has published fabrications. |
| F | Cannot be judged. No basis to assess. | A first-time anonymous tip; a screenshot with no provenance; a pastebin with no author. |

Grade the source you actually touched. A newspaper's report of a court judgement
is B — the newspaper — even though the judgement itself is A. If you want the A,
go and get the judgement.

## Information credibility (number)

Judges *this item*, on two grounds: independent confirmation, and internal
logic.

| Grade | Meaning | How you earn it |
|---|---|---|
| 1 | Confirmed. Corroborated by other independent sources, logical, consistent with other information on the subject. | Two separate collections agree. Not two websites — two collections. |
| 2 | Probably true. Not confirmed, but logical and consistent with other information. | Fits everything else you hold; nothing independent yet. |
| 3 | Possibly true. Not confirmed, reasonably logical, agrees with some other information. | Partial agreement, partial gaps. |
| 4 | Doubtful. Not confirmed, possible but not logical; no other information on the subject. | Free-floating, slightly odd. |
| 5 | Improbable. Not confirmed, not logical, contradicted by other information. | Conflicts with things you have graded higher. |
| 6 | Cannot be judged. No basis to assess validity. | Nothing to compare it against, and no internal test available. |

`6` is not an insult and it is not rare — a single unusual claim early in a case
is honestly a `6`. Use it rather than inflating to `3`.

## The independence test

Before you grade anything `1`, run all three checks:

1. **Origin.** Order the sources by publication date and read the earliest. Do
   the later ones add observation, or restate?
2. **Textual identity.** Shared phrasing, a shared typo, an identical
   transliteration of a foreign name, the same wrong middle initial — these
   travel with copies, not with independent observations.
3. **Upstream feed.** Many apparently distinct sites resell one dataset. This is
   normal for people-search sites, business-listing directories, breach
   aggregators, and reputation sites. Two resellers of one feed are one source.

If any check fails, the corroboration is circular. Grade the single origin and
note the derivatives.

## Applying it in practice

- Grade at the moment of collection, in the same row as the URL and the
  timestamp. Retrospective grading turns into rationalisation.
- Grade every item, including the ones that support your conclusion. Analysts
  grade contradicting evidence harshly and supporting evidence generously
  without noticing.
- When two items conflict, the grades decide which one you carry forward, and
  the conflict itself goes in the report's gaps section.
- Regrade when new information arrives. An `F6` tip that later matches a
  registry filing becomes an `F1` — the source is still unjudgeable, the
  information is now confirmed. That pair is exactly the situation the two-axis
  scheme exists to express.
- Do not average the two characters into one score. Carry both into the report.

## Common misgradings

| Mistake | Correction |
|---|---|
| Grading a screenshot by the reputation of the platform it claims to show | Screenshots are `F` unless you retrieved the live or archived original yourself. |
| Grading an archived page as less reliable than a live one | An archive snapshot of a page has the same source reliability and a *better* provenance record. Archive everything — see `read-deleted-pages`. |
| Giving `1` because three websites agree | Run the independence test first. |
| Giving `A` to any government source | Government data has known error and staleness. Registries hold what was filed, not what is true; self-declared filings are `B` at best on their contents. |
| Giving a low letter because you dislike the conclusion | The letter is about track record and access. Nothing else. |
| Using the grade as a confidence level in the report | Related, not the same. Grades describe inputs; confidence describes your judgement. See `write-the-intel-brief`. |
