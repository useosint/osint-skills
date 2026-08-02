# Per-platform public disclosure matrix

What an observer can see without a relationship to the subject, described by
mechanism rather than by menu location. UI moves constantly; the mechanisms
below change slowly. Verify current behaviour on a control account you own
before relying on any row.

Three observer postures matter throughout:

- **Logged out** — no account, no cookies. Lowest exposure, most gating.
- **Minimally authenticated** — a research account with no history, no
  followers, no profile photo. Sees more, but is itself a signal: brand-new
  empty accounts are what platforms and cautious subjects both watch for.
- **Established research persona** — an aged account with plausible activity.
  Sees the most, costs the most to build, and loses the most when burned. See
  `investigate-without-getting-made`.

## The disclosure axes

For each platform, ask the same seven questions:

1. Can the profile be read at all while logged out, or is there an auth wall?
2. Is the follower/following list enumerable, and in what order?
3. Are exact post timestamps exposed, or only relative ("3h ago")?
4. Is there a stable numeric ID, and does it encode a creation time?
5. Does the platform tell the subject that you viewed them?
6. Is EXIF stripped from uploaded media, and does that differ by upload path?
7. Does the platform expose an engagement graph (likes, reactions, comments)
   to non-connections?

## Cross-cutting mechanisms

**Auth walls are partial and inconsistent.** Most large platforms gate *some*
surfaces (search, follower lists, media tabs) while leaving the base profile
readable to crawlers, because they want search-engine indexing. That gap is the
reason a site's own search may show you nothing while a web search operator
scoped to the site shows you plenty — see `google-like-a-spy`. Search-engine
caches and archives also preserve the pre-gate version of a profile; see
`read-deleted-pages`.

**Numeric IDs outlive handles.** Platforms need an immutable primary key.
Where the ID is exposed in API responses, page source, or media URLs, capture
it: it survives renames, and it's how you prove a renamed account is the same
account.

**Snowflake-style IDs leak the signup time.** A 64-bit ID whose high bits are a
millisecond counter since a platform epoch decodes directly to a creation
timestamp. Where a platform uses plain auto-increment integers instead, the ID
gives you *ordering*, which you convert to a date range by finding accounts
with known creation dates on either side.

**Follower list ordering is an implementation detail with intelligence value.**
Where a platform returns followers in insertion order (oldest first or newest
first), the tail of the list is the earliest cohort. Where it returns them
ranked by an affinity model, ordering tells you about the *viewer*, not the
subject. Determine which you're looking at using a control account before
drawing conclusions.

**Relative timestamps defeat temporal analysis; absolute ones enable it.**
Where the UI shows "5h", the exact value is usually still present in the page
source or in the API response backing the view. Where it isn't, you can bracket
it by observing the same post repeatedly. Also check whether the rendered time
is localised to *your* session timezone — if it is, your histogram silently
measures your own offset unless you normalise to UTC.

**Read receipts and view telemetry.** Ephemeral content (stories, fleeting
posts) generally reports viewers to the poster by design, because that's the
product. Professional networks often report profile visits, sometimes with an
opt-out that also blinds you to who visited you. Ordinary feed posts generally
do not report views individually, but liking, following, saving or replying
always does. Assume any interaction is attributable and any ephemeral-content
view is logged.

**Recommendation feedback.** Even pure viewing feeds the graph. Repeatedly
loading one subject's profile can cause the platform to suggest your research
account to them, or them to your other accounts, because co-viewing is a
similarity signal. Separate personas across separate browser profiles, separate
egress IPs, and separate devices where the stakes justify it.

**EXIF handling differs by upload path, not just by platform.** The common
pattern: images posted through the normal media pipeline are re-encoded and
stripped; the same file sent as a generic file attachment or document is stored
byte-for-byte and retains everything. Profile pictures and banners are often
processed differently from feed media. Always test the specific path rather
than assuming "platform X strips EXIF."

## Platform-family notes

**Microblogging / short-post platforms.** Historically the most open to
logged-out reading; increasingly gated behind authentication, with the depth of
gating varying by surface and by region. Snowflake-style IDs are common, so
account age is derivable from the post or user ID even when the profile hides
it. Post IDs are also snowflakes, which means a post's ID gives you its
creation time independently of the displayed timestamp — useful when the
displayed time is relative or when the post was edited.

**Photo and short-video platforms.** Base profile and post grid frequently
readable logged-out; follower lists, tagged-media tabs and search usually
gated. Stable numeric user IDs are exposed in API responses and sometimes in
media URLs; the handle is mutable, the ID isn't. Ephemeral story viewing is
always attributable. Media is aggressively re-encoded, so EXIF is generally
gone, but the *filename and CDN path* can still carry structure worth reading.

**Full social networks with bidirectional friendship.** Friend lists are
commonly restricted, but the restriction is one-sided: a locked-down subject
appears in the *open* friend lists, tagged photos and public check-ins of their
less careful contacts. Mutual-friend enumeration from the outside in is often
the only route. Public pages, groups, marketplace listings and event RSVPs
under the same account are frequently far more open than the personal profile.

**Professional networks.** Employment history, education, and skills are
self-reported and semi-verified at best, but the *timeline* is high-value: date
ranges bracket where someone lived. Profile-view telemetry is a first-class
feature here — use the privacy mode that anonymises you, and understand it is a
platform-controlled promise, not a technical guarantee. Connection-degree
labels leak network structure even when the connection list is hidden.

**Pseudonymous discussion platforms.** Handles are the identity, real names are
rare, and the intelligence is in aggregate posting behaviour: subreddit or
board membership maps interests and geography, and a full comment history is
usually enumerable and timestamped, which makes these the best possible source
for temporal analysis. Usernames are typically immutable, which makes them
excellent selectors for `hunt-a-handle`. Deleted comments frequently survive in
third-party mirrors and archives.

**Messaging platforms with public surfaces.** Public channels, groups and
username lookups expose far more than users assume: joining a public channel is
usually not reported to other members, but posting is, and member lists may be
enumerable depending on group type and size. User IDs are numeric and broadly
increasing, so a raw ID brackets registration order. File-send paths commonly
preserve original metadata intact.

**Community chat platforms.** Snowflake IDs throughout, so account and message
creation times are derivable. Server membership is the network layer, and
membership overlap across servers is a strong linkage signal. Presence,
activity status and voice-channel occupancy are real-time pattern-of-life data
if you're already in the server — which is interaction, not observation, and
needs authorization.

## Recording template

For each platform in scope, record:

```
platform:
observer posture used:
profile readable logged-out:      yes / partial / no
numeric ID:                        value
ID encodes creation time:          yes / no / derived-by-ordering
creation date:                     value + how obtained
handle history observed:           values + sources
follower list enumerable:          yes / no / partial; ordering =
exact timestamps available:        yes / no; source = UI / page source / API
timestamps rendered in:            UTC / viewer locale / poster locale
view telemetry to subject:         none / stories / profile visits / unknown
EXIF retained on tested path:      yes / no; path tested =
```

Keep the "how obtained" column populated. In six months you will not remember,
and an unsourced creation date is not evidence.
