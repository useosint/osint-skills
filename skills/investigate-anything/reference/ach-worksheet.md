# Analysis of Competing Hypotheses — worksheet

ACH was developed by Richards Heuer at CIA and set out in *Psychology of
Intelligence Analysis*. It is not a scoring gimmick. It changes one thing: you
stop asking "what supports my theory?" and start asking "which theory does this
evidence *rule out*?" That inversion is the whole technique.

Use it whenever an attribution matters, whenever two analysts disagree, and
whenever you notice you already know the answer.

## Procedure

1. **List hypotheses first, before reviewing evidence.** Include the ones you
   consider unlikely. In OSINT the mandatory ones are:
   - It is a different entity with the same or similar name.
   - The account/identifier changed hands (sold, inherited, compromised,
     recycled by the platform).
   - The link is shared infrastructure or a shared service, not a relationship
     (shared hosting, a CDN, a registrar's privacy service, a company formation
     agent's address, a payment processor).
   - The identity is a nominee, front, or reseller for someone else.
   - The information was planted or is deliberately misleading.
2. **List every item of evidence, and every relevant absence.** Absences are
   evidence: no corporate filing, no archived copy, no account before a certain
   date. Number them E1, E2, … and carry each item's source grade.
3. **Fill the matrix by row.** For each item, for each hypothesis, mark:
   - `C` consistent, `I` inconsistent, `N/A` not applicable or no bearing.
4. **Delete the rows that are `C` everywhere.** They have no diagnostic value,
   however impressive they look. This step usually removes most of the material
   and is the reason the technique works.
5. **Read by column.** Score by *inconsistencies*, not support. The surviving
   hypothesis is the one with fewest `I`s. A hypothesis with a single hard `I`
   is in trouble regardless of how much `C` it has.
6. **Weight by grade and by diagnosticity.** One `A1` diagnostic item outweighs
   ten `D3` consistent ones. Note next to each `I` whether the evidence could be
   wrong — an inconsistency resting on an `F6` item is not a refutation.
7. **Write the falsifier.** For the leading hypothesis, state what evidence
   would overturn it, and whether it is obtainable. If nothing could overturn
   it, you have not analysed anything.
8. **Report the runner-up.** Name the second hypothesis and why it is weaker.
   This is what makes the judgement auditable, and it is what a reviewer, a
   client, or opposing counsel will attack first.

## Template

```
Objective question:
Date / analyst:

Hypotheses
  H1
  H2
  H3

Evidence                                    Grade   H1   H2   H3
E1  ...                                     B2      C    I    C
E2  ...                                     A1      C    I    I
E3  ...                                     D3      C    C    C   <- no diagnostic value, delete
E4  absence of ...                          B2      I    C    C

Inconsistency count (weighted):             H1: 1   H2: 2   H3: 1
Leading hypothesis:
Runner-up and why weaker:
What would refute the leading hypothesis:
Is that obtainable from open sources? If not, name the closed source.
Residual gaps carried into the report:
```

## Worked example

Question: is `@quiet_harbour` operated by the named former employee, K. Reyes?

- H1 — it is K. Reyes.
- H2 — it is a different person; the handle resembles Reyes's other handles by
  coincidence or convention.
- H3 — it is an account Reyes once held and later sold or abandoned.

| Evidence | Grade | H1 | H2 | H3 |
|---|---|---|---|---|
| E1 Handle matches Reyes's pattern on two other platforms | C3 | C | C | C |
| E2 Avatar reverse-searches to a stock photo library | B1 | C | C | C |
| E3 Posts reference an internal project by its unpublished codename | C2 | C | I | C |
| E4 Account creation predates Reyes's employment by four years | A1 | C | C | C |
| E5 Posting hours consistently sit in a timezone Reyes has never lived in, across two years including the employment period | B2 | I | C | C |
| E6 Writing switches abruptly in style and language mid-history | C2 | I | I | C |

E1, E2 and E4 are consistent with everything — delete them. The handle pattern
felt like the strongest evidence and is worth nothing here; the avatar being
stock is worth nothing either, since anyone might use one.

Remaining: H1 carries two inconsistencies, H2 carries two (one of them E3,
which is hard to explain away), H3 carries none. The dead end worth recording:
substantial effort went into the handle-pattern work in E1, and it turned out to
be non-diagnostic — say so, so nobody repeats it.

Leading hypothesis: H3, the account originated elsewhere and Reyes held it for a
period. Refuter: evidence of continuous single operation across the style
break — for example a platform-issued creation or transfer artefact, or an
identity selector present on both sides of the break. Not obtainable from open
sources here; named as a gap requiring platform records.
