---
name: where-was-this-taken
description: >-
  End-to-end workflow to establish where and when a photo or video was captured and whether it
  is authentic — evidentiary handling, metadata extraction, reverse image search for
  provenance, visual geolocation, chronolocation from shadows, and manipulation checks, ending
  in a location finding with a stated confidence radius. Use when asked to verify where an
  image was taken, confirm or refute a claimed location or date, or authenticate media before
  relying on it. Applies to insurance claims, litigation evidence, disinformation analysis,
  and conflict and human-rights documentation. Reference at
  useosint.com/skills/where-was-this-taken.
disable-model-invocation: true
---

# Where was this taken

Input: an image or video file, or a URL to one. Output: a location with a confidence
radius, a time window, an authenticity assessment, and the evidence chain for each.

This workflow orchestrates. The technique detail lives in `secrets-in-file-metadata`,
`find-the-original-image`, `geolocate-from-pixels` and `is-this-photo-real` — run
those, don't reimplement them here.

The order matters more than anything else in this file. Metadata before analysis,
because analysis destroys metadata. Provenance before geolocation, because the
original's caption often *is* the location. Authenticity checks before you commit,
because geolocating a composite gives you a confident answer to the wrong question.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Then state, in writing, before you open the
file:

- **Subject** — what the media is, and who appears in or is affected by it.
- **Objective** — verification, disinformation research, missing persons, threat
  assessment, due diligence, litigation support, or showing someone their own
  exposure. If you cannot name a legitimate objective, stop.
- **In and out of bounds** — specifically: are you permitted to publish a precise
  coordinate, or only a region? Is face search permitted? Is anyone in the frame a
  private individual?
- **Jurisdiction** — yours, the subject's, and the platform's. Precise historical
  location data about an identifiable person is regulated personal data in most of
  them.
- **Publication floor** — decide now what precision you will publish, before you
  know the answer. Geolocating a private individual's home from their own photos is
  the mechanic of stalking regardless of your intent, and conflict imagery can make
  the people in frame a target. Rounding a coordinate is a decision to make cold.

**Done when** subject, objective, bounds, jurisdiction and publication floor are
written down in the case file.

## Step 2 — Secure a pristine copy

Everything downstream is worthless if you contaminate the original.

- Work from the file, not a screenshot of it. For platform video, pull the best
  rendition with `yt-dlp` and keep the sidecar JSON.
- Hash it immediately and record the hash: `sha256sum evidence.jpg`. A second
  algorithm costs nothing and pre-empts an argument.
- Set the original read-only, store it unmodified, and do all work on copies. Name
  derivatives so the transform is legible: `evidence_crop-sign.png`,
  `evidence_flop.jpg`.
- Record provenance of your own acquisition: the URL, the timestamp you fetched it,
  who gave it to you, and the platform it came from. Archive the source page before
  it changes.
- Note whether the file is an original capture, a platform re-encode, or a
  screenshot. This single fact determines which later tests are valid at all, and you
  will need it in the report.

**Done when** the original is hashed, read-only, and its acquisition path recorded,
and every subsequent step is operating on a named copy.

## Step 3 — Metadata

Run `secrets-in-file-metadata` before any transformation. Cropping, rotating,
upscaling or even opening the file in some editors rewrites tags.

Prioritise: GPS coordinates and `GPSHPositioningError`; `GPSImgDirection`, which
gives you the camera's bearing and lets you reproduce the exact view;
`GPSDateStamp`/`GPSTimeStamp` in UTC as the only timezone-anchored clock; the
timestamp triplet; device make, model and serial; the software chain; and the
embedded thumbnail for comparison against the main image.

If GPS is present you have a **lead**, not an answer. It is a writable field.
Continue to step 5 and verify it visually; a metadata coordinate that a visual check
confirms is a far stronger finding than either alone.

**Done when** metadata is extracted and recorded, or confirmed absent — and you have
written "no EXIF present" rather than "EXIF removed".

## Step 4 — Provenance

Run `find-the-original-image`. For video, extract keyframes first and search several
of them.

You are looking for an earlier appearance, a different caption, a photographer
credit, and a date you can corroborate independently through `read-deleted-pages`.
Open the match pages and read them — the caption on the earliest copy frequently
names the place outright, which collapses steps 5 and 6 into a verification exercise
instead of a search.

If the media is older than the claim, or from a different country than the claim, you
have your answer and it is a stronger answer than a coordinate.

**Done when** you have either an earliest-known publication with its date and
caption, or a documented null across at least three engines including crops and a
mirrored search.

## Step 5 — Visual geolocation

Run `geolocate-from-pixels`. Inventory clues before searching, rank them by
geographic specificity, fix the country from language, plates, driving side and road
markings, then narrow to a site and confirm in satellite and street-level imagery.

If step 3 gave you coordinates, do this anyway as an independent test rather than
navigating straight to the coordinate and confirming what you were told. Use
`GPSImgDirection` to reproduce the camera bearing and check that the view matches
what a camera at that position pointing that way would see. A bearing that points at
a blank wall means the coordinate is wrong.

**Done when** you have a candidate location with a stated radius and a written list
of the specific features you matched — or a documented region-only result with the
reason you could not narrow further.

## Step 6 — Chronolocation

Still in `geolocate-from-pixels`, using its chronolocation reference. Shadow azimuth
for the sun's bearing, shadow-length ratio for its elevation, then solve against a
sun-position calculator for the confirmed location. Expect two date bands, not one,
and break the tie with foliage, snow, crop stage, or a dated object in frame.
Corroborate against a weather archive and note which station you used and how far
away it is.

Reconcile the result against the metadata timestamps from step 3. Agreement between
an unanchored EXIF datetime and an independently derived sun position is one of the
strongest corroborations available in this whole workflow, because the two have no
common failure mode.

**Done when** you have a time-of-day range and a date band, each graded, with the
discriminator you used named — or an explicit statement that the date remains
two-banded.

## Step 7 — Authenticity

Run `is-this-photo-real`. At minimum: the physical-consistency checks — shadow
convergence across multiple objects, reflection geometry, perspective and scale — and
the internal-consistency sweep against your own step 5 findings.

The specific failure this step is here to catch: you have just geolocated a scene
that was assembled from two photographs, or generated. A composite geolocates
beautifully and means nothing. If shadow convergence fails or an element carries no
optical signature, your location finding applies to the background plate only, and
you must say so.

**Done when** manipulation and synthesis are assessed, each graded, with signal-level
tests either run or explicitly marked invalid for the copy you hold.

## Step 8 — Decide whether the claim is corroborated

Lay the independent lines of evidence side by side and ask what agrees.

The standard: **three mutually independent non-transient features** matching
reference imagery makes a location. Independence is the requirement people fudge.
Three photographs of the same sign is one feature. A building footprint, a utility
pole line and a ridgeline profile are three. Metadata GPS plus a visual match plus a
sun-position-consistent shadow are three, and they are independent because forging
all three coherently is hard.

Then run the falsification test you should have written in step 5: name the single
observation that would kill your candidate, go look for it, and record that you did.
A finding nobody tried to break is not a finding.

Grade the composite honestly:

- **Confirmed** — three independent features align, the falsification test was run
  and failed to break it, and no line of evidence contradicts another.
- **Probable** — two independent features, or three with one resting on undated or
  low-resolution reference imagery.
- **Region only** — country or province established, no site. A respectable result.
- **Excluded** — you can affirmatively rule out the claimed location. Needs only one
  hard contradiction, and is often more useful than finding the true site.
- **Unresolved** — say so. An honest gap beats a confident guess that gets rebutted.

**Done when** each of location, time and authenticity carries a grade and the
evidence it rests on, and any contradiction between lines of evidence is stated
rather than reconciled away.

## Step 9 — Express the finding

- **Coordinates plus a radius in metres, always.** A bare six-decimal coordinate
  claims sub-metre precision you do not have. Derive the radius from what actually
  bounds you: `GPSHPositioningError` if the finding rests on metadata, the resolution
  of the reference imagery if it rests on a satellite match, the size of the area
  consistent with your matched features if it rests on visual work.
- **Camera position and bearing, separately from the subject's position.** These are
  different places and reports routinely conflate them.
- **Time as a range in local clock time**, saying whether you converted from solar
  time and what offset you applied.
- **Date as one or two bands**, naming the discriminator that dropped the second — or
  reporting both if nothing did.
- **The specific features you matched**, listed, with links to the reference imagery
  and its capture dates.
- **Your assumptions**: assumed object heights, ground flatness, which reference
  bearing you used, which weather station.
- **Apply the publication floor from step 1.** If it says region-only, round the
  coordinate before it leaves your notes, not after someone asks.

**Done when** the finding is written with a radius, a grade, its matched features and
its assumptions, at the precision step 1 authorised.

## Step 10 — Handoff

Run `write-the-intel-brief` with the graded findings, the evidence chain, the hashes
from step 2, and the archived reference links.

New selectors this workflow produces, and where they go: business names and municipal
bodies to `x-ray-a-company`; phone numbers from signage to `whose-number-is-this`;
domains on signs or vehicles to `who-owns-this-domain`; named or credited individuals
to `find-anyone`; posting accounts to `hunt-a-handle` and
`pattern-of-life-from-socials`; aircraft or vessels in frame to
`track-planes-and-ships`; several related locations to `graph-the-network`.

**Done when** the brief is delivered, the case file retains the original hash and the
derivative chain, and data you no longer need for the stated objective is deleted.
