---
name: whose-number-is-this
description: >-
  Investigate a phone number — E.164 normalisation with libphonenumber, phoneinfoga scanning,
  carrier and line-type identification, VoIP and burner detection, messaging-app registration
  checks, and reverse-lookup and caller-ID sources. Use for phone OSINT and reverse phone
  lookup, "who owns this number", identifying a burner or VoIP number, or checking whether a
  number is registered on WhatsApp, Telegram or Signal. Applies to vishing and business email
  compromise investigation, verifying a counterparty before sending payment, recruitment and
  marketplace scam checks, and fraud triage. Reference at
  useosint.com/skills/whose-number-is-this.
disable-model-invocation: true
---

# Whose number is this

A phone number is a strong selector: expensive to acquire, hard to change, and
used as an account-recovery anchor almost everywhere. It is also the selector
investigators get most wrong, because the metadata everyone quotes — the carrier
— is frequently stale, and because a large share of numbers now belong to
software rather than to a SIM in someone's pocket. Do not call or text the
subject; that is contact, not research.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Write down subject, objective,
in-bounds selectors, out-of-bounds actions, and the governing jurisdiction —
which matters more here than in most skills, because reverse phone lookup is
specifically regulated in many places. Decide now whether messaging-app
contact-discovery checks are authorized; they are interactive.

**Done when** scope is written and the contact-discovery decision is recorded.

## Step 2 — Normalise to E.164 first

Everything downstream breaks on a badly parsed number. E.164 is `+`, country
calling code, national number — no spaces, punctuation, or trunk prefix.

The trap is the national trunk prefix. A UK number written `07700 900123` is
`+447700900123`: the leading `0` is dropped, not kept. Italy keeps its leading
zero for landlines. Guessing wrong shifts every subsequent lookup onto a
different subscriber.

Use `libphonenumber` (Google's parsing library, with bindings for most
languages) rather than a regex. It knows per-country trunk prefixes, valid
length ranges, and which prefix ranges are assignable, so it distinguishes a
number that is well-formed from one that is actually possible in that country.

From the normalised form, read off the **country calling code** (the country,
not the subscriber's location), the **national destination code** — area code or
mobile prefix, giving the geographic region for landlines or the *originally
allocated* operator for mobiles — and the **line type**: fixed, mobile, VoIP,
toll-free, premium, shared cost, or unknown. Line type is the most
decision-relevant field.

`phoneinfoga` wraps normalisation, format generation and lookup scanners:

```bash
phoneinfoga scan -n "+15551234567"
```

**Done when** the E.164 form, country, national destination code, and line type
are recorded.

## Step 3 — Carrier, VoIP, and why both lie

An HLR query for a mobile number reaches the subscriber's home register and
returns the network the number is *currently* homed on, whether it is reachable,
and often whether it is roaming. That is live data and the only carrier answer
worth much. Everything else — prefix-to-carrier tables, most free lookup sites —
maps the number's original allocation block. **Portability breaks this.** A
subscriber keeps the number and changes networks; the allocation table still
names the original operator. So "carrier: X" from a prefix lookup means "this
block was issued to X", not "this person is a customer of X". Say which kind of
lookup produced your answer, every time.

Then classify VoIP. For fraud, trust-and-safety, and sockpuppet work this is
usually the highest-signal finding in the whole skill: a number resolving to a
virtual-number provider rather than a mobile network operator was cheap,
disposable, obtainable without identity verification in many jurisdictions, and
possibly one of hundreds held by the same party. Indicators are a VoIP line
type, an allocated operator that hosts numbers rather than serving consumers,
and an area code unrelated to any other location evidence. Interpretation and
the per-app disclosure matrix:
[reference/line-types.md](reference/line-types.md). A VoIP result is not proof
of bad faith — most businesses use VoIP — but it does mean the number is a weak
identity anchor.

**Done when** carrier is recorded with its lookup method and portability caveat,
and the number is classed likely-SIM, likely-VoIP, or unknown.

## Step 4 — Messaging-app disclosure

Contact discovery on messaging platforms reveals whether a number is registered
and, depending on the user's privacy settings, a display name, an avatar, an
about line, and sometimes last-seen. It is genuinely informative — registration
is a fact about a person, and an avatar pivots straight to
`find-the-original-image`.

It is also **interactive and privacy-sensitive**. You are querying the platform
about a named individual, usually from an account, and contact-list sync uploads
that list to the platform. Most platforms restrict automated or bulk lookup. Do
it only with explicit authorization, one number at a time, from an account and
device managed under `investigate-without-getting-made`, and record it as an
interactive step. The reference above lists what each app exposes.

**Done when** app presence is recorded, or marked not-attempted with the reason.

## Step 5 — Search the number as a string, in every format

This is the highest-yield passive step and it is the one most often skipped.
Numbers are written in a dozen conventions and search engines do not normalise
between them. Search each format, quoted, with and without the country code:

```
"+1 555 123 4567"  "+15551234567"  "(555) 123-4567"  "555-123-4567"
"555.123.4567"     "555 123 4567"  "5551234567"      "001 555 123 4567"
```

Full permutation guide, including national conventions and obfuscated forms:
[reference/format-permutations.md](reference/format-permutations.md).

Run these through `google-like-a-spy` across multiple engines — coverage of the
same number differs sharply between them — plus `find-leaks-in-the-wild`,
`read-deleted-pages`, and `what-leaked-about-you`. Classified ads, business
directories, resumes, and old forum signatures are where numbers live in public.

Crowd-sourced caller-ID apps and reverse-lookup databases will also offer a
name. Treat these as leads, never attribution: their name data comes from other
users' address books and submitted labels, so it inherits every mislabel, stale
contact, and deliberate poisoning. Spam scores are gameable, and many of these
services demand your own contacts as the price of entry.

**Done when** every format has been searched across two engines and each
candidate name is recorded with its source, marked unverified.

## Where this goes wrong

- **Portability makes carrier data stale** silently: a confident wrong answer,
  not an error. It also breaks area code as a location proxy, along with VoIP
  allocation and people who kept a number through three moves.
- **Recycling.** Disconnected numbers get reassigned. A number in an old breach
  may belong to someone unconnected today — who may still be receiving the
  previous owner's account-recovery codes.
- **Caller-ID spoofing** is trivial, so a number on a call log is not evidence
  its owner called. **SIM swap** transfers control while ownership records stay
  unchanged: in fraud work the registered owner and the person receiving the SMS
  may be different people, and that is the attack.
- **Shared and business numbers.** One number, many people.
- **Aggregator staleness.** Reverse-lookup data is copied between vendors and
  rarely re-verified; two sites agreeing usually means one source.

## Confidence grading

- **Confirmed** — published by the subject on a source they control, or in an
  authoritative record (filing, licence, registration) tied to the subject, or
  two genuinely independent sources agree.
- **Probable** — messaging-app registration with a display name consistent with
  the subject, plus one corroborating public listing.
- **Unconfirmed** — a name from a caller-ID or reverse-lookup service, an
  aggregator record, or a single breach row, however confident the vendor's UI
  looks.
- **Rejected** — line type, allocation, or timeline contradicts the subject, or
  it is a shared business line with no individual attribution possible.

Show line type next to the grade — naming an owner for a VoIP number is always
the weaker claim.

## Worked example

Given `07700 900123`, claimed to belong to a UK supplier contact. Normalised to
`+447700900123`; libphonenumber classes the prefix as a mobile range. A prefix
lookup names one operator, an HLR-based lookup a different one — the number was
ported. Record the current network, flag the prefix answer as historical.

The dead end: reverse-lookup sites return a name that does not match the
supplier contact, and two other services return the identical string. One source
echoed three times, not corroboration. Dropped.

Searching every written format via `google-like-a-spy` finds the number in a
cached trade-directory listing under a company name, with a different registered
address than the invoices show. That company goes to `x-ray-a-company` and the
discrepancy becomes the finding. Number attribution stays probable; the
corporate link is what gets reported.

## Pivots

| New selector | Skill |
|---|---|
| Owner name | `find-anyone` |
| Business name from a listing | `x-ray-a-company`, `who-really-owns-it` |
| Messaging-app avatar | `find-the-original-image` |
| Display name or handle | `hunt-a-handle` |
| Email alongside the number | `what-an-email-reveals` |
| Number in breach records | `what-leaked-about-you` |
| Number in pastes or channels | `find-leaks-in-the-wild`, `dig-through-data-brokers` |

## Legal and ToS notes

Phone lookup is more regulated than most OSINT. Several jurisdictions restrict
who may run reverse lookups and for what purpose, and consumer-reporting rules
in some countries govern using this data for employment, tenancy, or credit
decisions regardless of how public the source was. Numbers are personal data
under GDPR and UK law, and contact-list uploads and automated app-registration
checks breach most platforms' terms. Using a number to locate a private
individual's home or to enable unconsented contact is out of bounds; the
legitimate uses are fraud work, due diligence, authorized skip tracing, and
self-audit.

## Step 6 — Report

Run `write-the-intel-brief`. State the E.164 form, line type, carrier with
lookup method and portability caveat, app presence with an interactive-step
flag, and the owner attribution with its confidence grade and sources.

**Done when** no carrier claim appears without its lookup method, and every
interactive check is labelled as one.
