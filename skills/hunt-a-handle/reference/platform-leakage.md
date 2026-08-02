# What a public profile leaks, by platform

Use this to decide which candidate accounts are worth the confirmation effort.
Platforms that expose a stable numeric identifier and a creation date are worth
disproportionately more than platforms that expose only a name and a bio,
because they let you time-bound an account independently of what it claims.

Platform behaviour changes. Treat every row as a mechanism to check, not a
guarantee, and confirm against the live profile before relying on it.

## The four things worth extracting

**Join / creation date.** Anchors the account in time. Clusters of accounts
created within days of each other across platforms are a strong correlation
signal. A creation date that predates the subject's plausible online life is a
rejection signal.

**Numeric or structured ID.** Where identifiers are issued monotonically,
ID order approximates registration order. That gives you two things: an
independent estimate of creation date for accounts that hide it, and a way to
detect a renamed account (the handle changes, the ID does not). Always record
the ID alongside the handle — handles are rented, IDs are permanent.

**Last-seen / last-activity.** Tells you whether the account is live enough to
be worth monitoring, and whether a person went quiet at a meaningful moment.

**Contact discovery.** Whether the platform lets someone find this account from
an email address or phone number. This is what makes an account reachable from
a different selector — and it is the setting privacy-conscious subjects most
often forget to turn off.

## Identifier mechanics worth knowing

| Mechanism | What it gives you |
|---|---|
| Sequential integer IDs | Registration order; interpolate a creation date from two accounts of known date bracketing the ID |
| Snowflake-style IDs | Creation timestamp embedded in the identifier itself; no lookup needed |
| UUID / random IDs | Stable across renames, but no time information |
| Slug-only (handle is the ID) | Nothing survives a rename; archive the profile immediately |

Two concrete cases worth memorising:

- **GitHub** — `https://api.github.com/users/<login>` returns a numeric `id` and
  an ISO `created_at`, unauthenticated. The `id` persists across username
  changes, so an old link that redirects tells you a rename happened.
- **Discord** — user IDs are snowflakes: the creation timestamp is encoded in
  the high bits of the integer, so the ID alone dates the account.

## Category-level expectations

| Category | Typically exposes | Notes |
|---|---|---|
| Code hosting | Join date, numeric ID, activity timeline, commit emails, starred repos, org membership | Highest-yield category. Commit metadata often exposes a real name and email — pivot to `secrets-in-git-history` |
| Microblogging | Join month/year, numeric ID, follower graph, post timestamps | Timestamps in aggregate give a timezone; see `pattern-of-life-from-socials` |
| Link-in-bio / linktree-style | A curated list of the subject's own accounts | Self-declared cross-links: the strongest cheap evidence there is |
| Q&A and forums | Join date, post count, sequential member ID, sometimes an "about" with a real name | Old forums leak the most and are indexed least — reach for `google-like-a-spy` |
| Photo sharing | Upload timestamps, sometimes retained camera metadata, geotags | Pivot to `secrets-in-file-metadata` and `where-was-this-taken` |
| Gaming and streaming | Persistent account ID, friends list, achievement timeline | Handles here are often the oldest a person owns, and the least curated |
| Professional networks | Employer history, education, real name, location | Usually the identity anchor, but heavily curated and hostile to automation |
| Music and media | Public playlists, follow graph, sometimes a linked social account | Low identity value, high pattern-of-life value |
| Marketplaces and classifieds | Approximate location, join date, seller history | Contact selectors are often in the listing body rather than the profile |
| Developer package registries | Maintainer email, other packages, publish timestamps | An email in package metadata is a direct pivot to `what-an-email-reveals` |

## Contact discovery

Some platforms allow lookup of an account by email or phone; some let the user
disable it; some rate-limit it heavily. Where it exists, it converts an email or
phone selector directly into an account — which is why `what-an-email-reveals`
and `whose-number-is-this` both route back here.

Two cautions. First, contact-discovery probing is *interactive* — you are asking
the platform a question about a specific person, from an account. Treat it as
out of scope unless your authorization explicitly covers it. Second, uploading a
contact list to a platform to test membership discloses that list to the
platform, which is its own data-protection problem.

## Capture discipline

For every confirmed account, record at minimum: platform, canonical URL, handle,
numeric ID if any, display name, creation date, last activity, avatar URL and a
local copy of the avatar, and the retrieval timestamp. Profiles get edited and
deleted. If you did not archive it, you cannot prove it — see
`read-deleted-pages` for recovering what you missed.
