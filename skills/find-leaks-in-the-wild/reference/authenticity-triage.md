# Leak authenticity triage

A checklist for deciding whether a dataset is what it claims to be. Work it in
order; the early checks are cheap and reject most of what circulates.

The default hypothesis for any dataset presented as a new breach is that it is
a recombination of older material. Most circulating "breaches" are. Make the
claim earn its way past that.

## Stage 1 — the claim, before you look at any data

1. **Has the alleged victim disclosed an incident?** Check their newsroom, their
   status page, and their regulatory filings. A confirmed disclosure with a date
   and a scope is the strongest single piece of evidence available and outranks
   everything downstream.
2. **Has a regulator or CERT published a notification?** Many jurisdictions
   require breach notification, and those notices name the incident, the date
   and the categories of data affected.
3. **Who is making the claim, and what is their history?** A seller with a track
   record of verified drops is different from a new account. On forums this is
   what the reputation system is measuring, though a compromised or purchased
   established account defeats it.
4. **What is the claimed record count?** Suspiciously round numbers — exactly
   ten million, exactly one million — indicate a truncated or padded dataset
   rather than a table dump. Real tables have untidy counts.
5. **Does the claimed scope match the victim's plausible scale?** More records
   than the organisation could have had users is the commonest tell of an
   aggregation marketed under one company's name.

## Stage 2 — structure of the sample

Sellers publish a sample. Analyse the sample; you rarely need the full dataset,
and not taking it is usually the better decision anyway.

6. **Does the field structure look like a user table?** A genuine dump inherits
   its schema from the source application: consistent column order, a primary
   key, foreign keys, internal identifiers, nullable fields that are actually
   null, and columns whose purpose is only meaningful inside that application.
   A combolist has two or three columns and no structure at all.
7. **Are the internal identifiers coherent?** Sequential or near-sequential IDs,
   with gaps where records were deleted, are hard to fabricate convincingly.
   Randomly distributed IDs across a small sample suggest cherry-picking or
   synthesis.
8. **Do the timestamps behave?** Registration dates should be distributed across
   the service's lifetime, cluster around known growth events, and never predate
   the service's launch or postdate the claimed breach. Check the format and the
   epoch — a mix of formats means a merge of sources.
9. **Is the password storage plausible for this service and era?** Unsalted MD5
   on a service launched recently is implausible; a modern purpose-built
   password hash on a decade-old forum dump is implausible in the other
   direction. A single dataset containing several hash formats is a merge, not a
   breach — unless the service demonstrably migrated schemes, which leaves a
   date boundary you can see.
10. **Is there any plaintext at all?** Some genuine breaches contain plaintext
    passwords because the service stored them badly. A dataset that is *entirely*
    plaintext, with no hashes, is usually a combolist assembled from cracked
    material, because the cracking already happened upstream.
11. **Are the email domains distributed as you would expect?** A service with a
    national user base should show that country's mail providers. A flat global
    distribution dominated by the largest free providers is what aggregated
    combolists look like.
12. **Are there fields only this service would collect?** A subscription tier, a
    game character name, a loyalty number, an internal risk score. Their presence
    is the strongest positive evidence of a genuine source dump; their absence
    from something claiming to be an application database is a serious problem.

## Stage 3 — overlap with known material

13. **Test known records against prior corpora.** Take records from the sample
    and check them against breach data you can already search. If a large
    proportion appear in older, well-attributed breaches with the *same
    passwords*, you are looking at recycled data. Some overlap is expected —
    people reuse credentials and appear in many breaches — so what you are
    measuring is the rate, and near-total overlap settles it.
14. **Look for combolist artefacts.** Deduplicated and sorted ordering, a
    uniform `email:password` shape, no metadata at all, and the same record
    appearing in several circulating datasets under different names. Combolists
    also carry contamination from their sources: entries with obviously
    unrelated domains, and malformed rows preserved from a bad parse upstream.
15. **Check for a canary.** If the subject is your own organisation, you may
    have unique addresses or records seeded specifically to detect and date a
    leak. If you do not, create them now — a per-vendor unique email address is
    the cheapest attribution mechanism that exists, and it tells you which
    partner leaked rather than merely that someone did.
16. **Consider whether it is a scrape rather than a breach.** Datasets built by
    scraping public profiles get marketed as hacks routinely. The tell is that
    every field in the dataset is a field the platform displays publicly, and
    nothing else — no password, no email that was not already visible, no
    internal identifier. Reporting a scrape as a compromise is a factual error
    that will be found.

## Stage 4 — provenance and chain of custody

17. **Where did you get it, and where did that source get it?** Record the URL
    or channel, the timestamp, the poster identity, and any forwarding chain.
    Distribution provenance is separate from data provenance and both matter.
18. **Is there a first-appearance date you can establish?** Search the
    distinctive strings from the announcement — the exact record count, the file
    name, the seller's phrasing — across paste and forum corpora. An earlier
    appearance under a different name is decisive.
19. **Preserve what you observed, not what you took.** Capture the post,
    listing, sample and metadata. Hash whatever you retain. A finding you cannot
    show the origin of is not usable in a report.

## Grading the outcome

- **Confirmed** — the alleged victim or a regulator has disclosed the incident,
  and the sample's structure is consistent with that disclosure.
- **Probable** — no disclosure, but the sample carries service-specific fields,
  coherent internal identifiers, plausible timestamp and hash characteristics,
  and low overlap with prior corpora.
- **Unconfirmed** — a credible-looking sample with no disclosure and no
  distinguishing structure, or one you have only seen described.
- **Rejected** — high overlap with prior breaches at the same passwords; a
  two-column combolist shape; a record count exceeding the victim's plausible
  user base; a public scrape presented as a compromise; or a dataset whose
  earlier appearance under another name you have found.

## Reporting language

Distinguish three claims in writing, because conflating them is the most common
error in leak reporting:

- **A dataset exists and is being distributed** — usually easy to evidence.
- **The dataset contains records relating to the subject** — evidence this from
  the records you examined, quantified.
- **The subject's systems were compromised** — a much stronger claim. It needs
  the victim's disclosure, a regulator's notification, or structural evidence
  that the data could only have come from their systems. Do not assert it from
  the presence of records alone. A subject's data can leak from a supplier, a
  partner, an old acquisition, or an entirely unrelated service where they
  happened to register.
