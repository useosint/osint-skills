---
name: find-leaks-in-the-wild
description: >-
  Find leaked or mentioned selectors circulating in pastes, leak forums, Telegram channels and
  dump markets, and judge whether a claimed leak is genuine or a recycled combolist. Covers
  paste aggregators, site: searches over paste hosts, channel indexes and leak-search
  services. Use when checking whether a name, email, domain or credential is circulating,
  verifying a breach claim made against your organisation, or setting up ongoing leak
  monitoring. Applies to incident response and breach triage, threat intelligence, brand and
  executive protection, and extortion-claim validation. Reference at
  useosint.com/skills/find-leaks-in-the-wild.

---

# Find leaks in the wild

This is where data surfaces before anything indexes it, and where most of what
you find is a recombination of things that leaked years ago. Two mistakes cost
people most: assuming a paste host's own search will find pastes, and reporting
a combolist as a breach. The first wastes a day; the second is a factual error
in a deliverable and it will be found.

## Where to start with what you're holding

| You have | Start with | Why |
|---|---|---|
| An email or username | A curated breach service first | Cheap, attributed, and answers most questions — `what-leaked-about-you` |
| A selector you think is circulating now | `site:` sweep of paste hosts, then a paste aggregator | Engines are shallow but free; aggregators reach what was never crawled |
| A paste that has been deleted | A historical paste corpus | Deletion is the norm; some services retain the content |
| A claimed breach of a named company | The company's own disclosure, then a regulator notification | One authoritative source beats any amount of forum chatter |
| A dataset being advertised | Structural analysis of the sample | You almost never need the full dataset to answer the question |
| A domain you're defending | Vendor monitoring plus your own canary selectors | One-off searches miss everything posted between them |

Source-by-source access model and risk:
[reference/source-catalogue.md](reference/source-catalogue.md).

## Why paste-site search doesn't work

Pastes are unlisted by default. No index page, no directory, reachable only by
URL — so there is nothing for the host to search and nothing for a crawler to
follow. Where a host offers a firehose or scraping interface at all, it is
typically restricted to paid accounts with IP allowlisting, because the open
version got abused. Volume is enormous and retention is short.

So people find pastes four other ways, in rough order of yield: third-party
aggregators that continuously scrape paste hosts and index the content;
historical paste corpora that retain content after the original was deleted;
search-engine `site:` queries, which are shallow because the pages are unlinked
and short-lived but cost nothing; and curated breach services that index pastes
alongside breaches.

Run the free ones first; query shapes are in `google-like-a-spy`. Note that the
paste ecosystem is far wider than the obvious hosts: minimal modern paste
services, code sandboxes, gists, published-to-web documents, and
client-side-encrypted paste software whose content the server itself cannot
read, making it invisible to every aggregator that exists.

## Forums: a category with a life cycle

Do not learn site names; learn the pattern. A forum accumulates users and data,
becomes the recognised marketplace, attracts law enforcement, gets seized or its
operator arrested — and within weeks a successor appears claiming continuity,
often with the same staff and the imported user database. The names change. The
category does not.

Three consequences that change how you behave:

- **A forum "restored" after a seizure may be operated or monitored by law
  enforcement.** This has happened. Registering puts your details into an
  evidence set.
- **Registration is a durable risk.** Forum databases leak, get seized, and get
  published. Assume any account you create becomes public eventually, with its
  email, IP history and posts attached.
- **What an unregistered visitor can see is the marketing, not the data.**
  Reputation tiers and paywalls gate the actual datasets, which is exactly why
  paying for access is where the legal exposure escalates.

Many organisations prohibit investigators from touching these sites at all and
buy the intelligence from a vendor who has accepted the risk contractually. That
is a legitimate answer, not a cop-out.

## Telegram is the distribution layer

Structural reasons, not fashion: channels broadcast to unlimited subscribers,
large files attach directly, a banned channel is recreated in minutes, and
public channels are reachable without an invitation.

**Read public channels in a browser through the platform's public preview.** No
account, no joining. Joining is an account action that exposes you, and for
reading a public channel it buys you nothing. Do this first and, in most
investigations, only.

Discovery is the hard part — in-app search is weak for finding channels you do
not already know about. Third-party channel indexes and channel-search services
are the practical route, and they additionally give you subscriber history and
post archives that the channel itself will not.

Two platform specifics worth knowing. **Forwarded messages carry attribution to
the originating channel**, so a forward chain reconstructs the distribution path
and often reaches the source. And **bots are used as retrieval front-ends for
leak databases** — querying one exposes your account and hands your selectors to
its operator, so treat any such bot as an intelligence collector pointed at you.

Channels vanish and take their archive with them. Capture posts, file listings
and metadata the moment you see them.

If you need an account, it must be dedicated, on a number that is not yours,
with discovery and contact-sync settings locked down before first launch.
`investigate-without-getting-made` covers the whole environment; do not
improvise it here.

## Genuine leak or recycled combolist

The default hypothesis for anything presented as a new breach is that it is a
recombination of older material, because most of it is. Make the claim earn its
way past that.

The strongest evidence is external: the alleged victim's own disclosure, or a
regulator or CERT notification. Check those before touching the data.

Structurally, a genuine source dump inherits its schema from the application it
came from: consistent column order, coherent internal identifiers with gaps
where records were deleted, registration timestamps spread across the service's
actual lifetime, a hash scheme plausible for that era, email-domain distribution
matching the user base, and — the strongest positive signal — fields only this
service would collect, like a subscription tier or a game character name.

A combolist looks like none of that: two columns, no metadata, sorted and
deduplicated, a suspiciously round record count, several hash formats mixed
together, and heavy overlap with older well-attributed breaches at the same
passwords. Some overlap is normal because people reuse credentials — what you
are measuring is the rate.

Two other failure modes to rule out: a **public scrape marketed as a hack**,
where every field is one the platform already displayed; and a **dataset that
already circulated under another name**, found by searching the announcement's
distinctive strings — exact record count, file name, seller's phrasing — across
paste and forum corpora.

Full checklist and grading:
[reference/authenticity-triage.md](reference/authenticity-triage.md).

## Monitoring versus searching once

A one-off search answers "is it out there now" and misses everything posted
between searches, which given typical paste retention is most of it. Ongoing
exposure needs continuous collection, and practically that means buying vendor
monitoring, since running your own collection against these sources is exactly
the risk you were avoiding. Ask one question before buying: **when did their
collection start**, because coverage begins there and nobody backfills what they
never captured.

Then measure them. Seed canary selectors — unique email addresses and
identifiers, distinct per vendor and per partner — into the systems you are
protecting. A canary tells you not just that a leak happened but *which*
downstream party leaked it, making it the only mechanism here that produces
attribution rather than detection. It also independently measures whether your
monitoring vendor sees what they claim.

## Where this goes wrong

- **Combolists destroy provenance.** A hit tells you a pair appeared somewhere,
  not which service it came from — which was the entire investigative value.
- **Claimed dates are marketing.** Breach date, first-circulation date, and the
  date your source ingested it are three different things, often years apart.
- **Absence is uninformative.** Not finding a selector means it is not in the
  corpora you can reach. Most leak material is never posted publicly at all.
- **Sellers lie about scope in both directions**, inflating for price and
  understating to avoid attention. Scrapes get relabelled as breaches
  constantly, including by vendors.
- **Your searches are logged** — by vendor platforms, by bots, by forum search
  boxes. Assume every selector you look up is retained by someone.
- **Announcement volume is not incident volume.** The same dataset gets
  re-announced by many resellers, and counting posts overstates activity.
- **Malware and phishing are the point** on mirrors and clones of leak sites,
  which specifically target people arriving via search for a new domain.

## Confidence grading

- **Confirmed** — the alleged victim or a regulator has disclosed the incident,
  and the sample's structure is consistent with that disclosure.
- **Probable** — no disclosure, but service-specific fields, coherent internal
  identifiers, plausible timestamps and hashes, and low overlap with prior
  corpora.
- **Unconfirmed** — a credible sample with no disclosure and no distinguishing
  structure, or a dataset you have only seen described by a seller.
- **Rejected** — high overlap with prior breaches at the same passwords, a
  two-column combolist shape, a record count exceeding the victim's plausible
  user base, a scrape presented as a compromise, or an earlier appearance under
  another name.

Keep three claims separate in writing: that a dataset exists and is circulating;
that it contains records relating to your subject; and that your subject's
systems were compromised. The third is much stronger, and a subject's data leaks
from suppliers, partners, old acquisitions and unrelated services too.

## Worked example

A client's domain appears in a Telegram post advertising a "fresh 2.4M breach"
of a named SaaS provider they use.

The vendor has published no disclosure and no regulator notification exists. The
seller's sample, read from the channel's public web preview without joining, is
two columns of `email:password`, sorted, with no user IDs, no registration
dates, and no fields specific to that product.

The dead end: searching the exact record count and file name across paste corpora
turns up nothing earlier, so the "already circulated under another name" test is
inconclusive rather than confirming.

Overlap settles it. Twelve sample records checked against a curated breach
service appear in three older, well-attributed breaches with identical
passwords. Round count, no schema, near-total overlap: a combolist marketed
under a recognisable brand name.

Reported as: records relating to client staff are circulating — **probable**;
the named provider was compromised — **rejected**, with reasoning recorded. The
client's remediation is password rotation regardless, since the credentials are
in circulation whatever their origin.

## Pivots

| New selector | Goes to |
|---|---|
| Email addresses in a dump | `what-an-email-reveals`, `what-leaked-about-you` |
| Usernames and handles | `hunt-a-handle` |
| Phone numbers | `whose-number-is-this` |
| Domains and hostnames in a listing | `who-owns-this-domain`, `find-hidden-subdomains` |
| Wallet addresses in a sale post | `follow-the-crypto` |
| Seller or channel-operator persona | `find-anyone`, `graph-the-network` |
| Attached documents and images | `secrets-in-file-metadata`, `is-this-photo-real` |
| Credentials or keys traced to a repository | `secrets-in-git-history` |
| A post or channel that has since been deleted | `read-deleted-pages` |

## Legal and handling notes

**Never use a leaked credential to authenticate to anything.** Not to verify the
account exists, not once, not with a client's verbal blessing. Credential
stuffing is unauthorized access under computer-misuse law in most jurisdictions
and public availability of the password is not a defence. The same applies to
password resets and recovered security-question answers.

**Never purchase, solicit, or trade for leaked data.** Beyond funding the trade,
purchase and solicitation are criminal in many jurisdictions where reading a
public page is not, and this is the line that turns an investigation into an
offence.

**Possession is jurisdiction-dependent.** Some jurisdictions criminalise
possession of certain categories of stolen data irrespective of how it was
obtained, and others treat it as lawful processing subject to data-protection
rules. Know which regime applies to you before you download anything, and get
that decision in writing on any engagement where downloading is contemplated.

Practically: analyse samples rather than acquiring full datasets, retain the
minimum, store encrypted at rest with access logged, never retain credentials,
delete on a schedule written down at the start, and record why each retained
item was necessary. Under GDPR and equivalent regimes this is personal data and
often special-category data, and processing it needs a lawful basis. See
[../../ETHICS.md](../../ETHICS.md).
