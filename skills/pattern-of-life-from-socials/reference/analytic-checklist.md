# Pattern-of-life analytic checklist

Work top to bottom. Every line either produces a recorded artefact or gets
marked "not available" with a reason. A blank is not the same as a negative
finding, and six months later you won't remember which it was.

## Layer 0 — Case setup

- [ ] Subject, objective, in/out of bounds, jurisdiction and stop condition
      written down and dated.
- [ ] Viewing identity chosen and its exposure documented.
- [ ] Evidence store created: one folder per platform, capture log with
      UTC timestamps, hashes of downloaded media.
- [ ] Collection window declared (e.g. "posts from the last 18 months"). State
      it in the brief; every temporal conclusion depends on it.

## Layer 1 — Account metadata

- [ ] Profile URL, captured and archived.
- [ ] Handle, exactly as spelled, including case and separators.
- [ ] Display name, and any prior display names visible in archives.
- [ ] Numeric / immutable account ID.
- [ ] Creation date — stated, decoded from ID, or bracketed by ordering. Record
      the method.
- [ ] Handle history: prior handles plus the source for each (old mention,
      inbound link, archive snapshot, cross-post).
- [ ] Verification status and what kind of verification it is.
- [ ] Bio text verbatim, plus every link, including link-aggregator
      destinations expanded one level.
- [ ] Business/creator contact fields (email, phone, category, address).
- [ ] Profile and banner images downloaded, hashed, run through
      `find-the-original-image`.
- [ ] Pinned or featured content — usually the subject's own summary of what
      matters to them.
- [ ] Language, locale and script conventions used in the interface-facing
      fields.

## Layer 2 — Network

- [ ] Follower and following counts, with capture date.
- [ ] Follower list ordering determined (insertion order vs affinity-ranked)
      using a control account.
- [ ] Earliest-cohort followers captured, where ordering allows. These are the
      family-and-close-friends layer.
- [ ] Mutual follows enumerated and clustered.
- [ ] Clusters labelled with the real-world community they appear to represent
      (employer, school, hometown, congregation, hobby) and the evidence for
      that label.
- [ ] Inbound tags and mentions collected separately from outbound ones.
- [ ] Accounts that appear in comments within minutes, repeatedly — the inner
      circle.
- [ ] Accounts that leak about the subject: relatives, colleagues and friends
      whose own accounts are open. Note which specific facts each one leaks.
- [ ] Third-party minors and uninvolved parties identified and excluded per the
      scope gate. Record the exclusion.
- [ ] Graph exported to `graph-the-network`.

## Layer 3 — Content

For each post in the collection window:

- [ ] Post URL, archive URL, post ID.
- [ ] Timestamp, normalised to UTC, with the source of the timestamp.
- [ ] Text verbatim.
- [ ] Media downloaded and hashed.
- [ ] Location claims: geotag, check-in, place name in text, place name in
      hashtags.
- [ ] Inadvertent disclosure sweep, per image:
  - [ ] Reflections — windows, mirrors, glasses, screens, glossy surfaces,
        vehicle paint, cutlery.
  - [ ] Screens in frame — laptop, phone, TV, monitors, ATMs, departure boards.
  - [ ] Paper — boarding passes, parcel labels, receipts, prescriptions, event
        badges, name plates, whiteboards, calendars, post.
  - [ ] Vehicles — plates, dealer frames, inspection stickers, parking permits,
        toll transponders, distinctive damage.
  - [ ] Building detail — house numbers, intercom panels, letterboxes, utility
        markings, street furniture, signage, language of signage.
  - [ ] Uniform, badge, lanyard, branded clothing.
  - [ ] Pets, children's school uniforms, sports club kit. Note that these are
        commonly out of bounds; record only if the objective requires.
- [ ] Repeated-background register: assign each recurring interior or view an
      ID, count appearances, record first and last seen dates and the times of
      day. Repetition plus timing is what distinguishes home from workplace
      from a friend's house.
- [ ] EXIF extracted via `secrets-in-file-metadata`, recording which upload
      path the file came from.
- [ ] Any image worth geolocating handed to `geolocate-from-pixels` with the
      specific question you want answered.
- [ ] Any suspiciously convenient image checked with `is-this-photo-real`.

## Layer 4 — Temporal

Extraction schema — one row per post, CSV or equivalent:

```
post_id, platform, timestamp_utc, timestamp_source, local_hour_assumed_utc,
weekday, post_type, has_media, is_reply, client_or_source_label, notes
```

Then:

- [ ] Sample size and window recorded. Under a few dozen manual posts, do not
      draw a timezone conclusion at all.
- [ ] Hour-of-day histogram in UTC.
- [ ] Day-of-week histogram.
- [ ] Hour-by-weekday heat map — this separates work schedule from sleep, which
      the two one-dimensional plots cannot.
- [ ] Sleep window identified: the longest contiguous low-activity block,
      typically seven to nine hours.
- [ ] Inferred UTC offset, stated as a range, with the reasoning.
- [ ] Weekday-versus-weekend difference characterised.
- [ ] Offset shifts flagged as candidate travel, with dates.
- [ ] Automation check completed before any of the above is believed:
  - [ ] Are post times suspiciously round (top of the hour, fixed minutes)?
  - [ ] Is the interval between posts unnaturally regular?
  - [ ] Does the platform expose a client or source label indicating a
        scheduler or API client?
  - [ ] Do replies — which are hard to schedule — show a different distribution
        from top-level posts? If they do, trust the replies.
  - [ ] Is there evidence of cross-posting from another platform, which would
        make this histogram a copy of that one?
- [ ] Multi-operator check: does the distribution look like one human or like
      two overlapping schedules?

## Layer 5 — Consolidation

- [ ] Every cross-platform link listed with its evidence type and grade.
- [ ] Every location claim listed with grade and the artefacts supporting it.
- [ ] Contradictions listed explicitly. A contradiction you found and explained
      is a strength; one the reader finds is a failure.
- [ ] Coverage gaps stated: platforms not examined, date ranges with no posts,
      content types not accessible.
- [ ] Out-of-scope material identified and deleted, with the deletion recorded.
- [ ] Handoff to `write-the-intel-brief`.

## Analytic conclusions worth making explicit

Write these as sentences in the brief, or say you couldn't establish them:

- Home location, at the resolution you can actually defend — country, region,
  city, neighbourhood. Do not report a resolution finer than your evidence
  supports.
- Work location and employer, and whether the two are separable in the data.
- Daily rhythm: wake window, work window, sleep window.
- Weekly rhythm: which days differ and how.
- Travel events with dates and, where possible, destinations.
- Inner circle: who, and the basis for calling them that.
- Community memberships.
- Devices and platforms used, from client labels and media characteristics.
- What changed over the collection window — a shift in rhythm, location, or
  network is often the actual finding.
