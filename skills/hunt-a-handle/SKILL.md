---
name: hunt-a-handle
description: >-
  Enumerate a username across hundreds of platforms with sherlock, maigret and WhatsMyName,
  then correlate and confirm which accounts genuinely belong to the same person. Use for
  username OSINT and handle enumeration, "find all accounts for this username", cross-platform
  account correlation, nickname and screen-name pivots, or turning a handle into a real name.
  Applies to fraud and synthetic-identity investigation, recruitment and marketplace scam
  checks, trust-and-safety enforcement, insider-threat work, and personal exposure audits.
  Reference at useosint.com/skills/hunt-a-handle.
disable-model-invocation: true
---

# Hunt a handle

Handle reuse is the cheapest strong link in OSINT: one string, checked in
minutes, potentially tying a dozen platforms to one person. It is also the most
over-trusted. Enumerators do not verify identity — they perform HTTP existence
checks — and a hit list is a list of *candidates*, nothing more. The mistake
that ruins these investigations is pasting the tool's output into the report.
Enumeration is the cheap half; confirmation is the work.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md) and write down, before any query:
subject, objective, in-bounds selectors, out-of-bounds actions (logging in,
contacting, requesting follows), and the governing jurisdiction. Handle hunting
drifts easily — one run hands you thirty new platforms, and it is trivial to end
up profiling an uninvolved person who shares the string.

**Done when** scope is written down and you can name what would put you out of
bounds.

## Step 2 — Pick your enumerator

| Holding | Reach for | Why |
|---|---|---|
| One handle, need breadth fast | `sherlock` | Largest quick sweep, existence only |
| One handle, need profile content | `maigret` | Parses the page: display name, bio, IDs, links, sometimes country and creation date |
| Need to see why a hit fired | WhatsMyName data | Every check is a declared URI plus a match rule you can read |
| A handle on one known platform | Manual visit | Nothing beats reading the actual profile |

```bash
sherlock jdoe_92 --timeout 10 --csv
maigret jdoe_92 --html
```

maigret is the higher-value tool for correlation because it returns *fields*,
not booleans. A display name, avatar URL, self-declared location, numeric user
ID and an "also known as" list give you material to test the next platform
against. Sherlock gives you a URL and a claim.

WhatsMyName is a detection list, not a scanner: a JSON file of site entries,
each with a URI template and explicit match criteria (an expected HTTP status
and an expected string in the body, plus the equivalent for "missing"). Read the
entry for any site you doubt — it tells you exactly what the tool considered
proof. Many wrappers and web front-ends consume the same list, so a hit in three
different tools is often one rule firing three times, not three independent
confirmations.

**Done when** every candidate is recorded with platform, URL, the tool that
found it, and live/dead status.

## Step 3 — Generate variants

The handle you were given is one point in a person's naming habit. Recover the
habit and you find the accounts the first sweep missed.

- Separator swaps: `john.doe`, `john_doe`, `john-doe`, `johndoe`
- Truncations and initials: `jdoe`, `johnd`, `j_doe`, `doej`
- Number suffixes: birth year, birth year two-digit, `1`, `99`, `007`
- Leetspeak and character substitution: `j0hnd0e`, `johnd0e`
- Email local part as handle, and handle as email local part
- Gamer-tag morphology: prefixes, `xX…Xx`, clan tags, doubled letters

Full pattern list: [reference/variant-patterns.md](reference/variant-patterns.md).

Two inference directions matter. Handle → name: `jdoe_92` suggests a
first-initial-lastname pattern and a 1992 birth year, which is a hypothesis to
test, not a finding. Name → handle: if you already have a real name, generate
the handles that name would plausibly produce and enumerate those too — it often
outperforms starting from a handle someone gave you.

**Done when** the variant set is enumerated and the ones that produced hits are
folded back into Step 2.

## Step 4 — Confirm, or reject

For each candidate, look for evidence that survives a skeptical reader.

Strong:

- Same avatar. Verify with `find-the-original-image` — a match to a stock photo
  or a third party's picture is a rejection, not a confirmation.
- Byte-identical or near-identical bio text, especially with a typo or an unusual
  phrasing carried across.
- A self-declared cross-link: the profile links the other profile. Best evidence
  available short of an admission.
- A contact selector present on both (same email, same personal domain).

Moderate:

- Account creation dates clustering in a narrow window across platforms — people
  sign up for things in bursts.
- Follower/following overlap with the same distinctive small accounts.
- Writing style: idiom, punctuation habits, timezone of posting.

Weak on its own: the handle matching. That is the thing you are testing, not
evidence for it.

Platforms exposing a **numeric user ID** are disproportionately useful. Where
IDs are issued in registration order, the ID bounds an account's creation date
even when the profile hides it. GitHub's
`https://api.github.com/users/<login>` returns a numeric `id` and `created_at`;
Discord's snowflake IDs encode a creation timestamp directly. Per-platform
detail: [reference/platform-leakage.md](reference/platform-leakage.md).

**Done when** every candidate is graded confirmed, probable, or rejected, each
with its evidence written next to it.

## Where this goes wrong

Existence checks are HTTP heuristics. Every one of these produces a false
positive:

- **Soft 404s.** The site returns 200 with a "user not found" page. If the match
  rule keys on status code, everything exists.
- **Catch-all profile pages.** Some platforms render a generic shell for any
  string and only 404 on the API.
- **Rate-limit and CAPTCHA interstitials.** A challenge page is a 200 with body
  content, so it can satisfy both the "found" and "missing" rules — and once you
  are rate-limited, results for the rest of the run are garbage. Re-run failures
  separately rather than trusting a single sweep.
- **Reserved, squatted, and impersonation accounts.** Registered, real, not your
  subject.
- **Stale entries.** Sites change their 404 behaviour and detection lists lag.
  Absence of a hit is not absence of an account.

The deeper problem is collision. Common handles belong to many unrelated people,
and a short or dictionary-word handle across ten platforms is ten people far
more often than one. Confidence should scale with the handle's distinctiveness:
a rare invented string is itself weak-to-moderate evidence, `mike` is none.

Do not resolve ambiguity by logging in, messaging, or requesting a follow. That
is interaction, out of scope by default, and it tells the subject you exist —
see `investigate-without-getting-made`.

## Confidence grading

- **Confirmed** — an avatar match verified through `find-the-original-image`
  plus one other strong item, or a self-declared cross-link between the two
  profiles, or a shared contact selector.
- **Probable** — distinctive handle plus one moderate item (creation-date
  cluster, follower overlap, consistent style) and no contradicting evidence.
- **Unconfirmed** — the handle matches and nothing else does. Report it as an
  enumeration hit, not as the subject's account.
- **Rejected** — content, language, timeline, or avatar provenance contradicts
  the subject. Record rejections; they stop the next analyst redoing the work.

## Worked example

Given `sunfish_ada`. Sherlock returns 14 hits. maigret returns 9 with content,
including a code-hosting profile with display name "A. Okonkwo", a photography
site with the same avatar, and a forum with an empty shell profile.

The forum hit is discarded first: fetching a deliberately absurd handle on the
same forum also returns 200 with an identical empty page. Catch-all, not an
account.

The avatar on the photography site reverse-searches (via
`find-the-original-image`) to the same image on the code-hosting profile and
nowhere else — good. The code-hosting API gives a numeric ID and a creation date
in the same month as the photography account's stated join date. Two moderate
items plus an avatar match: confirmed for both.

A microblog hit with the same handle posts in a different language about
unrelated subjects, on an account predating the others by six years. Different
person, same string — rejected, and stated explicitly, because it is the first
thing a reviewer will find.

## Pivots

| New selector | Skill |
|---|---|
| Display name / real name | `find-anyone` |
| Exposed or inferred email | `what-an-email-reveals` |
| Phone number on a profile | `whose-number-is-this` |
| Avatar or posted photos | `find-the-original-image`, `secrets-in-file-metadata` |
| Photos with location context | `where-was-this-taken` |
| Code-hosting handle | `secrets-in-git-history` |
| Personal domain in a bio | `who-owns-this-domain` |
| Handle in credential dumps | `what-leaked-about-you` |
| Full posting history on a confirmed account | `pattern-of-life-from-socials` |
| The account map itself | `graph-the-network` |

## Legal and ToS notes

Automated enumeration hits platforms with scripted requests, which most terms of
service prohibit regardless of the data being public. Keep concurrency low, do
not defeat CAPTCHAs, and stop when a platform signals refusal. In the EU and UK,
assembling scattered public accounts into a profile of a living person is
processing personal data and needs a lawful basis and data minimisation.

## Step 5 — Report

Run `write-the-intel-brief`. Give the platform/URL/confidence/evidence table,
list rejections with reasons, and lead with the real-name and contact selectors
the handles produced.

**Done when** every candidate in the table carries a grade and a source, and no
enumeration hit appears without one.
