# Leak source catalogue

Organised by category, because individual sites disappear constantly and the
categories do not. For each, what it is, how you get at it, and what it costs
you to look.

Three columns of judgement apply to every entry: **access model** (open web,
registration, paid, invite, closed), **risk** (to your OPSEC, your legal
position, and your device), and **provenance quality** (can you tell where the
data came from). A source that is easy to reach is usually a source whose
provenance has already been destroyed by the time it got there.

Set up your working environment before you visit anything in the second half of
this document. `investigate-without-getting-made` covers it.

## Paste sites

Short-lived text dumps, usually unlisted rather than private, and the classic
dead drop for a sample of a leak.

| Category | Examples | Access | Notes |
|---|---|---|---|
| Mainstream paste hosts | Pastebin and its many clones | Open web | Enormous volume, minimal moderation, no usable public search |
| Modern minimal hosts | Rentry, ControlC, JustPaste.it, Ghostbin-style services | Open web | Popular because they are simple, unauthenticated and durable |
| Self-hostable, client-encrypted | PrivateBin instances and similar | Open web, per-instance | Content is encrypted in the URL fragment, so the server cannot read it and neither can an indexer. Invisible to every aggregator |
| Terminal paste services | Command-line paste endpoints | Open web | Favoured for tool output; URLs leak into chat logs and tickets |
| Code sandboxes | JSFiddle, CodePen, Replit and equivalents | Open web | Used as dead drops precisely because nobody monitors them for leaks |
| Gists | Code-host gist services | Open web | "Secret" means unlisted, not private. See `secrets-in-git-history` |

**Why the host's own search does not help.** Pastes are unlisted by default —
no index page, no directory, reachable only by URL. Where a host offers a
firehose or scraping interface at all, it is typically restricted to paid
accounts with IP allowlisting, precisely because the free-for-all version was
abused. What is left is a site search that covers a fraction of content, if the
host offers one at all. Do not plan around it.

**What works instead**, in order of yield:

1. **Third-party paste aggregators.** Services that continuously scrape paste
   hosts and index the content, letting you search by selector. This is the only
   route that reaches content the search engines never crawled. Coverage depends
   entirely on which hosts the aggregator monitors and when it started.
2. **Historical paste corpora.** Some breach-notification and leak-search
   services retain pastes long after the original was deleted. This is the only
   way to read a paste that is already gone, and deletion is the norm.
3. **Search-engine `site:` queries.** Cheap, immediate, and shallow — engines
   crawl paste hosts poorly because the content is unlinked and short-lived.
   Worth doing first because it costs nothing. Query shapes in
   `google-like-a-spy`.
4. **Curated breach services that index pastes alongside breaches**, which give
   you the paste as a data point attached to an identity. See
   `what-leaked-about-you`.

## File and dump hosting

Where the actual data goes when the paste is only the advertisement.

- **Anonymous file hosts** with no-registration upload and short retention.
- **Mainstream cloud storage** shared by link, which is common because it is
  fast and the account is disposable.
- **Torrents and magnet links**, used for large corpora. A magnet link in a
  forum post is a strong signal the dataset is genuinely large.
- **Content-addressed and distributed storage gateways**, which are difficult to
  take down by design.

Treat every one of these as hostile. Do not download from them outside an
authorized engagement with a decision recorded about why you needed the file,
and never onto a machine that matters. Archives from these sources carry
malware, and password-protected archives — the norm on leak forums — defeat
scanning by design.

## Leak forums

A category with a life cycle, not a list of sites.

The pattern repeats: a forum accumulates users and data, becomes the recognised
marketplace, attracts law-enforcement attention, gets seized or its operator
arrested, and within weeks a successor appears claiming continuity, often
recruiting the same staff and importing the old user database. Names and domains
change; the category persists.

What that means for you:

- **A "restored" forum after a seizure may be operated or monitored by law
  enforcement.** This has happened. Registration on such a site puts your
  details in an evidence set.
- **Registration is itself a risk.** Forum databases leak, get seized, and get
  published. Assume any account you create will eventually be public, along with
  its email, IP history, and posts.
- **Reputation systems and paid tiers exist to gate the good data**, which
  means the material visible to an unregistered visitor is the marketing, not
  the dataset.
- **Mirrors and clones are frequently phishing or malware**, targeting exactly
  the population that arrives via a search engine looking for the new domain.

**The legal position, stated plainly.** Reading a publicly accessible web page
is generally lawful. Creating an account, posting, requesting data, downloading
stolen data, and above all purchasing it are progressively more exposed, and
purchase or solicitation is a criminal offence in many jurisdictions as well as
directly funding the trade. Possession of certain categories of stolen data is
an offence in itself in some jurisdictions, independent of how you obtained it.
Get written authorization and take local legal advice before going past reading.

Many organisations, correctly, prohibit their investigators from touching these
sites at all and buy the intelligence from a vendor who has accepted that risk
under contract. That is a legitimate answer, not a cop-out.

## Messaging platforms

Telegram is the dominant distribution channel for leaked data and has been for
some time. The reasons are structural: channels broadcast to unlimited
subscribers, files up to a large size attach directly, channels are trivially
recreated after a ban, and public channels are reachable without an invitation.

How to work it:

- **Public channels are readable in a browser** through the platform's public
  preview, without an account and without joining. Do this first and possibly
  only. Joining a channel is an account action that exposes you.
- **Third-party channel indexes and channel-search services** are how you find
  relevant channels at all — the in-app search is weak for discovery and only
  matches channel names and public content it has indexed. External indexers
  additionally give you subscriber history and post archives.
- **Forwarded messages carry attribution** to the originating channel, which is
  the single most useful provenance feature on the platform. A chain of forwards
  reconstructs distribution.
- **Bots** are used as retrieval front-ends for leak databases. Interacting with
  one exposes your account and sends your query selectors to its operator.
  Treat any bot as an intelligence collector pointed at you.
- **Channels vanish.** Capture posts, file listings and metadata when you see
  them, because a banned channel takes its archive with it.

If you must use an account, it must be a dedicated one on a number that is not
yours, with discovery settings locked down. Contact-list upload and
phone-number visibility have both burned investigators. See
`investigate-without-getting-made`.

Discord operates similarly at smaller scale — invite-gated servers, files served
from a content CDN by opaque URL, and the same disposability.

## Onion and closed sources

Some material appears only on hidden services or in closed communities. A small
number of search services index onion content and can be queried from the
clear web, which is the low-risk way to establish whether something exists
before deciding whether reaching it is worth the exposure.

Direct access needs a purpose-built environment, an explicit authorization, and
a clear-headed assessment of what happens if you are wrong about the legality.
Closed communities generally require vouching, which means building a persona
over time — a substantial commitment with its own ethics, covered in
`investigate-without-getting-made`.

## Commercial and defensive sources

Often the right answer, and consistently underrated by investigators who enjoy
the hunt more than the result.

- **Leak-search and threat-intelligence vendors** ingest paste, forum and
  channel content continuously and expose it through a search interface. You are
  buying their risk appetite and their infrastructure. Their coverage window
  begins when they started collecting, which is the question to ask before
  buying.
- **Curated breach-notification services** answer "has this identity been
  exposed" with attribution and data classes, and index pastes as well. Start
  here for anything person-centric — `what-leaked-about-you`.
- **National CERTs and sector ISACs** publish notifications naming incidents and
  affected data categories. Authoritative attribution, and the correct way to
  test a dump's claimed origin.
- **The alleged victim's own disclosure.** Check it first, always. If a company
  has confirmed an incident with a date and a scope, that single source outranks
  everything else in this document.

## Choosing quickly

- Does an identity appear in known breaches: curated breach service.
- Is a selector sitting in a paste right now: search-engine `site:` sweep, then
  a paste aggregator, then a historical paste corpus.
- Is a dataset being distributed: Telegram channel indexes, read without joining.
- Is a claimed breach real: the victim's disclosure, then a regulator or CERT
  notification, then structural analysis of the sample.
- Do you need continuous coverage: buy it from a vendor, and add your own canary
  selectors so you can measure their coverage independently.
