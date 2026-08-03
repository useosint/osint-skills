---
name: pattern-of-life-from-socials
description: >-
  Deep-dive a subject's social media presence — profile metadata, follower and mutual network,
  content analysis, and posting-time pattern of life across Instagram, Facebook, X/Twitter,
  TikTok, LinkedIn, Reddit, Telegram and Discord. Use when profiling a social account, mapping
  someone's associates, inferring a subject's timezone or routine from their posts, or
  archiving a profile before it is deleted. Applies to threat assessment and executive
  protection, insider-threat investigation, pre-litigation research, and personal exposure
  audits — with explicit limits on profiling uninvolved third parties. Reference at
  useosint.com/skills/pattern-of-life-from-socials.
disable-model-invocation: true
---

# Pattern of Life from Socials

Pattern-of-life analysis turns scattered public posts into a model of where
someone is, when, and with whom. It is the most abusable technique in this
repo: the same method produces a due-diligence report and a stalking dossier.
The difference is authorization and scope, not tradecraft. The beginner error
is collecting posts instead of analysing them — screenshots of a feed are not
intelligence. Work four layers: account metadata, network, content, temporal
behaviour. The first and last are the two everyone skips, and the two the
subject can't curate.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md), then write down before opening a
single profile:

- **Subject** — the account(s) and the real-world entity you believe is behind
  them.
- **Objective** — the question that ends the investigation. "Pattern of life"
  is not one. "Does this vendor's EU lead actually live in the EU" is.
- **In / out of bounds** — explicitly. Minors, uninvolved family, home address,
  health, religion, sexuality and immigration status are out unless the
  objective requires them and you can defend that.
- **Posture** — observation only, or authorized interaction. Following, liking,
  messaging and viewing stories are all interaction.
- **Jurisdiction** — yours, the subject's, the platform's.
- **Stop condition** — you stop when the objective is answered, when the trail
  lands on an uninvolved third party, or when the only question left is "where
  do they sleep."

**Done when** all six are recorded in the case file.

## Step 2 — Choose a viewing identity, then preserve

Logged-out leaks less and sees less; logged-in sees more and leaks more.
Platforms variously report story views and profile visits to the subject, and
recommendation systems surface accounts that look at each other — so merely
viewing can put your research account in the subject's suggestions. Decide the
tradeoff using `investigate-without-getting-made`; never browse a subject from
a personal or employer account.

Then capture before you analyse. Accounts get locked or scrubbed
mid-investigation, often because someone noticed. Archive the profile and every
post you may cite via `read-deleted-pages`, and pull older snapshots — they
routinely show a previous bio, link, or handle. Save media locally.

**Done when** the viewing identity is recorded and everything you intend to
cite exists as an archive URL or a local file with a capture timestamp.

## Step 3 — Layer one: account metadata

Go after what the subject never chose. Full per-platform behaviour is in the
[platform disclosure matrix](reference/platform-disclosure.md).

- **Creation date.** Shown outright on some platforms, derivable on others.
  Snowflake-style 64-bit IDs encode a millisecond timestamp in their high bits,
  offset from a platform-specific epoch — the ID *is* the signup time. Plain
  sequential IDs give registration order, so you can bracket a date against
  accounts of known age.
- **The numeric ID.** It survives handle changes, so it — not the handle — is
  the durable selector. Record it.
- **Handle history.** Seldom a feature, usually recoverable from old mentions,
  inbound links, archived snapshots and abandoned cross-posts. A freed handle
  can be reclaimed by a stranger, so an old link proves nothing about current
  control.
- **Verification and linked accounts.** Whether a badge is paid or
  identity-checked changes what it's worth. Linked sites and business-account
  contact fields expose emails and phone numbers the personal profile wouldn't.

**Done when** ID, creation date, handle history and every linked selector are
recorded with sources.

## Step 4 — Layer two: network

A subject's OPSEC is nearly irrelevant if their relatives tag them.

- **Early followers.** The first accounts to follow a personal account are
  overwhelmingly family, school friends and coworkers — it spread by word of
  mouth before it had reach. Where follower ordering is observable, the oldest
  tail is the highest-value segment on the page.
- **Mutual-follow clusters.** Reciprocal edges map real-world communities:
  employer, school cohort, hometown, club. The cluster is the finding; a single
  edge isn't.
- **Tag direction.** Who the subject tags is curated. Who tags the subject is
  not. Inbound tags from an open-book cousin routinely deliver the birthday,
  the house, the car and the workplace the locked-down subject withheld.
- **Reply latency.** Accounts that reliably comment within minutes are the
  inner circle, regardless of follower counts.

Build this in `graph-the-network`, not as a list.

**Done when** the inner circle, one real-world cluster, and the third parties
who leak about the subject are identified and graded.

## Step 5 — Layer three: content

Read past the subject of each photo to the accidental content: reflections in
windows, mirrors, glasses and dark screens; laptop and phone displays in frame;
paperwork such as boarding passes, parcel labels and event badges; vehicles,
plates, dealer frames and parking permits. Repeated backgrounds are what
upgrade a room from "somewhere" to "home" or "workplace" — count occurrences
and note the date span.

Run `secrets-in-file-metadata` on everything you downloaded: platforms differ
in whether they strip EXIF, and the same platform may strip it from an inline
image while preserving it in a file attachment or an original-quality download.

Do the geolocation itself in `geolocate-from-pixels`. Sanity-check anything
that looks too convenient with `is-this-photo-real`.

**Done when** each location-bearing artefact is logged with post URL, date, and
a pointer to the geolocation work.

## Step 6 — Layer four: temporal behaviour

Extract every post timestamp into a table and plot hour-of-day and day-of-week.
The extraction schema is in the
[analytic checklist](reference/analytic-checklist.md).

A contiguous gap of roughly seven to nine hours is the sleep window, and its
position gives a UTC offset — enough to separate continents, not neighbours. A
weekday dip through business hours suggests employment with restricted device
access; the inverse suggests shift work or a job spent online. Sudden
multi-day offset shifts are travel.

What wrecks this: scheduling tools post at fixed wall-clock times regardless of
where the human is, so a scheduled account measures the scheduler; platforms
may render timestamps in the *viewer's* locale; edits can carry the edit time;
and cross-posting bridges or shared team accounts blend several humans into one
histogram. Establish that posting is manual before reading anything into shape.

**Done when** both distributions exist over a stated sample window, with an
explicit inferred UTC offset and its confidence.

## Step 7 — Consolidate and report

Link accounts on evidence: the same avatar file, the same link-in-bio target,
follower-set overlap, aligned histograms. Writing style alone is a lead, not a
link. Then run `write-the-intel-brief`. Every claim cites a post or archive URL
and a date; every temporal conclusion states sample window and sample size.

**Done when** no claim lacks a citation and no inference lacks a grade.

## Where this goes wrong

- **Sample bias.** You're reading a self-published subset of a life. Silence
  means "didn't post," never "wasn't there."
- **Backdating.** A post date is an upper bound on the event date. Photos get
  posted months late, reposted, or lifted from someone else entirely.
- **The account is not the person.** Handles are sold, inherited, hacked and
  recycled; a long history may have changed hands. Partners, assistants and
  agencies post as the subject — two behavioural signatures in one histogram
  usually means two humans.
- **Curated self-report.** Location, job title and relationship status are
  marketing copy, and a common name plus a matching city is a coincidence
  generator, not a match.
- **Rendering differences.** Timestamps, follower ordering and mutual
  indicators change with login state, and are often approximate ("2h", "last
  week") rather than exact.
- **Observation changes the subject.** One who locks down mid-case may have
  been tipped off by you.

## Grading a finding

- **Confirmed** — an authoritative record or the subject states it, or two
  independent artefacts of *different* types agree (an inbound tag from a
  separate account plus a geolocated background). Both archived.
- **Probable** — several consistent signals of the same type, or one strong
  signal with nothing contradicting it: a repeated background plus a temporal
  pattern consistent with living there.
- **Unconfirmed** — single-source, self-reported, style-based, or drawn from
  too small a sample. A timezone from a few dozen posts or fewer is
  unconfirmed, full stop.

Downgrade anything resting on an assumption you can't state in one sentence.

## Worked example

Objective: confirm a supplier's "EU operations lead" is in Europe, as the
contract requires.

Bio says Lisbon. The numeric ID decodes to a signup years before the company
existed — so the bio says nothing about the present. Four months of timestamps
cluster 14:00–05:00 UTC with a dead zone 06:00–13:00: a sleep window centred
near 09:00 UTC, wrong for Lisbon, consistent with the Americas. Dead end: no
geotags anywhere, and the platform stripped EXIF from every download.

The network layer breaks it. Early followers cluster around one US state
university, and a relative tags the subject at a named local restaurant on a
date the subject publicly claimed to be in Portugal; a repeated kitchen
background appears on both sides of that date. Graded **probable** — no
authoritative record places the subject anywhere, and a histogram can't
separate adjacent countries. Reported with the sample window stated.

## Pivots

| You now have | Take it to |
|---|---|
| Handle and variants | `hunt-a-handle` |
| Avatar, banner, posted photo | `find-the-original-image`, `is-this-photo-real` |
| Photo needing place or time | `geolocate-from-pixels` |
| Downloaded media files | `secrets-in-file-metadata` |
| Exposed email / phone | `what-an-email-reveals`, `whose-number-is-this`, `what-leaked-about-you` |
| Corroborated personal name | `find-anyone` |
| Employer, brand page, link-in-bio domain | `x-ray-a-company`, `recon-a-domain-passively` |
| Follower and mutual edges | `graph-the-network` |
| Deleted or edited posts | `read-deleted-pages` |
| Aircraft or vessel in posts | `track-planes-and-ships` |
| Wallet address or ENS name | `follow-the-crypto` |

## Legal and ToS

Automated collection of profile and follower data breaches the terms of service
of essentially every major platform and has been litigated as a computer-misuse
matter in some jurisdictions; manual viewing of public content generally has
not. Creating an account to view a subject is at minimum a ToS problem, and a
fraud problem if you misrepresent identity to gain access.

Under GDPR and comparable regimes "publicly available" is not itself a lawful
basis, and profiling a person's location and routine is high-risk processing.
Political opinion, health, religion, sexuality and union membership are special
categories — if they surface incidentally and aren't in scope, don't record
them. And the one that matters: sustained monitoring of an individual's
location and routine meets the statutory definition of stalking in many
jurisdictions, and sourcing it publicly is not a defence. Authorization, a
written objective and a stop condition are what make this work lawful.
