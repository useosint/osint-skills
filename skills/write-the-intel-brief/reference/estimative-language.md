# Estimative language reference

Words like "likely" mean wildly different things to different readers — this is
the reason intelligence communities standardise them. Sherman Kent's "Words of
Estimative Probability" is the origin of the practice; the two published
standards you will meet are the US ICD 203 analytic-standards ladder and the UK
Professional Head of Intelligence Assessment (PHIA) probability yardstick. Pick
one, print it in the report, and never step outside it.

## The ladder used in this repo

Ranges are the convention adopted here, aligned to the published yardsticks.
Whatever numbers you use, the ordering, the mutual exclusivity of the bands, and
the fact that you published the table are what matter.

| Term | Range | Use it when |
|---|---|---|
| Almost certain / almost certainly | 95%+ | Contradicting it requires assuming your primary evidence is fabricated. |
| Highly likely | 80–95% | Strong, corroborated, with an alternative that is alive but weak. |
| Likely / probably | 55–80% | Better supported than the alternatives, which remain plausible. |
| Roughly even chance | 45–55% | Genuinely balanced. Say so; do not drift upward to sound useful. |
| Unlikely | 20–45% | Possible, and the evidence points the other way. |
| Highly unlikely | 5–20% | Would require several things you believe to be wrong. |
| Remote / almost no chance | under 5% | Cannot be excluded, but nothing supports it. |

Never write a band and a number in the same sentence. Readers anchor on the
number and ignore the word, which defeats the point of banding.

## Terms to strike

| Banned | Why | Replace with |
|---|---|---|
| Possible, possibly | Everything not excluded is possible; it conveys no estimate. | A ladder term, or delete the sentence. |
| Cannot be ruled out | Same problem, with added false gravity. | "Remote" or "highly unlikely", if you actually mean that. |
| May / might / could | Modal verbs with no probability content, and they read as warnings. | A ladder term. |
| Suggests, points to, hints at | Vague inference verbs that let you avoid committing. | State the inference and its estimate separately. |
| Significant, substantial, considerable | Unquantified intensifiers. | The actual figure or scope. |
| Believed to be, reportedly, allegedly | Hides *who* believes or reports it. | Name the source and grade it. |
| Confirmed (as an intensifier) | Reserved for the confidence grade; using it loosely wrecks the grading scheme. | "Observed", or the ladder term. |
| Clearly, obviously | If it were, you would not be writing it. | Delete. |
| High probability | Colloquial, sits between two bands. | A ladder term. |

## Probability versus confidence

Two independent axes, both stated.

- **Probability** — how likely the judgement is to be true. From the ladder.
- **Confidence** — how good the underlying evidence is: source reliability,
  independent corroboration, coverage of gaps, and the assessed potential for
  denial and deception. High / moderate / low.

All four corners are legitimate:

| | High confidence | Low confidence |
|---|---|---|
| **Highly likely** | Multiple primary records agree. Act on it. | One unverifiable but internally coherent source points strongly one way. Say both. |
| **Roughly even chance** | Good evidence exists on both sides. | You have almost nothing; the estimate is close to a prior. |

Write the reason for the confidence, not just the label: "moderate confidence —
sourcing is a single national registry whose beneficial-ownership fields are
self-declared and unaudited."

## Rewrites

| Weak | Better |
|---|---|
| The domain may be linked to the same operator. | We assess it is **likely** (moderate confidence) that both domains were registered by one party: they share a registrant email observed on 2024-03-11. |
| It is possible the subject travelled to Cyprus. | Travel to Cyprus in that period is **roughly an even chance** (low confidence): two geolocated photographs are consistent with Limassol, but the posting date is not the capture date. |
| Sources suggest significant undisclosed ownership. | One filing (grade B2) names a nominee shareholder. We assess undisclosed beneficial ownership is **likely** (low confidence); the UBO register in this jurisdiction is not public. |
| We cannot rule out state involvement. | State involvement is **highly unlikely** (moderate confidence): the infrastructure is commodity, reused across unrelated fraud, and the targeting is opportunistic. |
| The account is clearly a sockpuppet. | The account is **highly likely** (high confidence) to be operated for a single promotional purpose: created within a day of two others posting identical text, no history before that date, avatar reverse-searches to a stock library. |

## Structural rules

- One judgement per sentence, one ladder term per judgement.
- Put the term in the main clause, not in a subordinate one where it can be
  read as applying to something else.
- Do not qualify a qualifier — "possibly highly likely" is meaningless.
- Never let the estimate change between the key judgements and the body. The
  body is where analysts quietly soften or harden a judgement they committed to
  on page one.
- If your judgement rests entirely on absence of evidence, say so explicitly:
  absence is weak wherever your collection coverage is weak, and you should have
  documented that coverage in the method section.
