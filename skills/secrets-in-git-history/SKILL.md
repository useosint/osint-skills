---
name: secrets-in-git-history
description: >-
  Mine GitHub, GitLab and git history for identities, infrastructure and leaked credentials
  using commit author emails, GitHub code search, the commit .patch endpoint, trufflehog,
  gitleaks, git log pickaxe and full-ref history scans. Use when investigating a developer or
  organisation on GitHub, finding leaked API keys, AWS keys or tokens in code, enumerating org
  members and their personal repos, or recovering secrets deleted from HEAD but still present
  in history or forks. Applies to software supply-chain risk, credential exposure response,
  M&A technical diligence, and insider-threat investigation. Reference at
  useosint.com/skills/secrets-in-git-history.

---

# Secrets in git history

A repository is three intelligence products: a list of humans with real email
addresses, a map of the organisation's infrastructure, and a credential store
nobody meant to publish. The costly mistake is scanning the working tree.
Secrets deleted from HEAD stay in history forever, and commits deleted from a
branch stay reachable through the fork network — scan only what is checked out
and you are searching the one place the secret was definitely removed from.

## What you're holding, and where to start

| You have | Start with | Why |
|---|---|---|
| An organisation name | Public org members, then their personal repos | Corporate repos are reviewed; personal ones are not |
| A developer's name or handle | Commit emails across their repos | Yields an email nothing else gives you |
| A commit email | Reverse-search across hosts; resolve any noreply ID | Links accounts across orgs and platforms |
| A suspected credential leak | Both scanners over a mirror clone, all refs | HEAD-only scanning misses the point entirely |
| A specific string — hostname, key prefix | `git log -S` pickaxe across all refs | Tells you when it entered and when it left |
| A live domain | Check for an exposed `.git` — see the legal note | Full history from a web server, if authorized |
| Nothing but a company website | Code search the org's internal domain names | Finds repos with no obvious link to the org |

## The commit email leak

Git records an author identity on every commit, self-asserted rather than
verified. That cuts both ways: emails are trivially forged, and they are also
the most reliable public link between a code-host identity and a real mailbox.

```bash
git clone --mirror https://github.com/example-org/example-repo.git repo.git
git --git-dir=repo.git log --all --format='%an <%ae>' | sort -u
```

GitHub's web UI does not display commit emails, which leads people to assume
they are hidden. They are not. Append `.patch` to any commit URL for a
mail-format patch whose `From:` header carries the author name and email; the
API returns the same under `commit.author.email`.

```bash
curl -s https://github.com/example-org/example-repo/commit/<sha>.patch | head -5
curl -s https://api.github.com/repos/example-org/example-repo/commits/<sha> | jq .commit.author
```

**The noreply pattern is the part worth understanding properly.** Users with
email privacy enabled commit as `username@users.noreply.github.com`, or in the
newer form `12345678+username@users.noreply.github.com`. That second form leaks
the account's **numeric user ID**, which is immutable and survives every rename
the account ever makes, so an old commit resolves to whoever holds it today:

```bash
curl -s https://api.github.com/user/12345678 | jq '.login, .created_at'
```

That defeats a rename: an old commit under a long-abandoned handle points at the
person's current identity. The complementary failure on the subject's side is
enabling email privacy *after* years of committing — every commit before that
date carries the real address, so pull the author list across all history.

## Enumerating an organisation as a social graph

Corporate repositories are reviewed. Personal ones are not, and developers put
the same infrastructure in both. The pivot is org to human to personal account.

Public org membership is opt-in and therefore incomplete, so triangulate:
`https://api.github.com/orgs/<org>/public_members` gives the members who chose
to be visible, while the author list across every org repository gives everyone
who actually committed, including those who never went public and those who left.

From each human, pull repos, gists, followers, following, starred and watched
repositories. Stars and follows are the underused ones: nobody curates them for
privacy, and they map interests, employers, side projects and professional
relationships more honestly than any profile field. A cluster of developers all
starring the same obscure internal-looking tool are colleagues.

Public activity events cover a short recent window, but the public event stream
is also published as a historical archive dataset, extending the analysis back
years. Commit timestamps in aggregate give working hours and a timezone.

## Code search and its real limits

Host code search finds strings across public repositories. Search what only this
organisation would write: internal hostnames, private package names, cloud
account IDs, the email domain. The company name finds marketing copy; the
internal domain finds infrastructure.

The limits matter more than the syntax, because each is a silent gap. Code
search covers **the default branch only** — no history, no other branches — so
the deleted secret is invisible to it by construction. **Not every repository is
indexed**: very large ones, and forks with no independent activity, are commonly
excluded. Authentication is generally required and rate limits are tight. And
matching is token-based, so a substring inside a longer token may not match the
way you expect.

Treat code search as a discovery tool that tells you *which repositories* to
clone. The actual work happens locally.

## Everything that survives deletion

- **Secrets removed from HEAD remain in history.** Deleting a file is a commit,
  not an erasure; rewriting history does not reach clones, forks or caches; and
  almost nobody rotates afterwards, because deleting felt like fixing.
- **Commits in a fork network stay reachable by SHA**, even after a branch is
  deleted, a PR is closed unmerged, or the fork is removed. Making a repository
  private does not retract what reached forks, and force-pushed commits are
  dangling rather than gone.
- **Gists are unlisted, not private** — anyone with the URL reads a "secret"
  gist, and URLs leak into logs, chats and tickets.
- **CI logs are public on public repositories.** Masking of known secret values
  fails whenever a value is base64-encoded, concatenated, URL-encoded, or
  printed by a subprocess. Issue and PR attachments are likewise served by
  opaque URL and stay retrievable after the issue or repository is gone.

## Scanning properly

Mirror-clone, then run both scanners — their detector sets and false-positive
profiles differ and neither is a superset. Then pickaxe the strings they have no
detector for: internal domains, cloud account IDs, hostnames from config files.

```bash
trufflehog git file://./repo.git
gitleaks detect --source=. -v
git log --all --source -S'internal.example.com' --oneline
git log --all --diff-filter=D --name-only --format='%H %aI %an'
```

**One warning about verification.** TruffleHog can confirm a candidate is live
by calling the provider's API with it. That is an interaction with a third party
using someone else's credential, and it writes to their logs. Inside an
authorized assessment it is normally expected. Outside one, do not.

Commands in [reference/git-archaeology.md](reference/git-archaeology.md); what
to grep for and how to triage a hit in
[reference/high-signal-indicators.md](reference/high-signal-indicators.md).

## Exposed .git directories

A deployment that copies a working tree to a web root publishes `.git` with it,
and from `.git/config`, `.git/HEAD` and the object store the entire history is
reconstructible — source, credentials, author identities, everything.

Observing that such a path exists, through a search index or an existing scan
result, is passive. **Retrieving it is not.** Downloading a `.git` directory is
accessing a system and taking data from it, and no misconfiguration constitutes
permission. Only inside a written authorization; otherwise, report it.

## Where this goes wrong

- **Author identity is self-asserted.** Anyone can commit as anyone; an email in
  a commit is a claim, not proof of authorship. Signed commits are the exception
  and the signature is what you verify, not the string.
- **Bots dominate commit counts.** CI, dependency bots and merge automation
  produce huge volumes of commits under synthetic identities. Filter them before
  concluding anything about people.
- **Rebases and squash merges rewrite authorship.** The committer becomes
  whoever performed the merge, and squashing collapses many authors into one.
  Absence from the log is not absence from the project.
- **Timezone inference is soft.** Laptops travel, offsets get set by hand, CI
  commits at UTC. Corroboration only.
- **Test fixtures and documentation examples look exactly like credentials**,
  and provider examples propagate into thousands of repos. Search first.
- **Public-by-design keys are not leaks.** Publishable and referrer-locked
  browser keys are meant to ship; reporting one as a breach costs you
  credibility on the findings that are real.
- **A namesake org or typosquat is not your target**, and a history-only finding
  is often more live than a current one, because removal without rotation is the
  norm.

## Confidence grading

- **Confirmed** — an identity link where a noreply numeric ID resolves to the
  account, or the same commit email appears under multiple accounts already tied
  to the person. A credential exposure whose format is valid, whose scope the
  surrounding context establishes, with a commit SHA and date.
- **Probable** — a distinctive email or handle recurring across repositories
  with consistent commit timing, or a credential-shaped string in a real config
  file outside a test path.
- **Unconfirmed** — a single unsigned commit's author string; a common handle; a
  scanner hit in a fixture or documentation example; a credential of unknown
  scope.
- **Rejected** — a documented placeholder, a publishable key, or an expired
  temporary credential presented as a live exposure.

Record repository, commit SHA, date and file path for every finding. A SHA is an
immutable citation; a line number is not.

## Worked example

Objective: map the engineering team of a company whose site names only
executives.

Code search on the internal domain `svc.example-corp.net` returns three
repositories, none carrying the company's name. Mirror-cloning them gives
fourteen distinct author emails, eleven corporate and three personal.

One author commits as `48211903+dhaverford@users.noreply.github.com`. Resolving
the numeric ID returns a *different* current username — the account was renamed,
and the old handle links to conference talks and a personal blog the current one
does not.

The dead end: gitleaks flags an AWS-shaped key in a test fixture, and searching
the string finds it verbatim in AWS's own documentation. Discarded, and recorded
as discarded so nobody re-raises it.

The real finding is a `terraform.tfstate` added and deleted in the same week two
years ago, recovered from history. No live credential, but four internal
hostnames and a cloud account ID — infrastructure for `find-hidden-subdomains`.

Grade: team roster **probable**, since commit authorship is self-asserted and
uncorroborated. The rename link **confirmed** — the numeric ID is immutable.

## Pivots

| New selector | Goes to |
|---|---|
| Commit author emails | `what-an-email-reveals`, `what-leaked-about-you` |
| Handles, renamed accounts, numeric IDs | `hunt-a-handle` |
| Real names from commits and CODEOWNERS | `find-anyone` |
| Internal hostnames from config | `find-hidden-subdomains`, `who-owns-this-domain` |
| Cloud account IDs, buckets, IPs | `find-exposed-servers`, `google-like-a-spy` |
| Committed documents and images | `secrets-in-file-metadata` |
| Org structure and vendor stack | `x-ray-a-company` |
| Deleted repos and removed pages | `read-deleted-pages` |
| Credential appearing in a public dump | `find-leaks-in-the-wild` |
| The contributor network | `graph-the-network` |

## Legal, disclosure, and the one hard rule

**Never authenticate with a credential you find.** Not to check whether it
works, not read-only, not once. It is unauthorized access under computer-misuse
law in most jurisdictions, and publication does not confer permission. Establish
validity from format, context and metadata and nothing else. See
[../../ETHICS.md](../../ETHICS.md).

A live-looking credential creates an obligation to disclose. Report promptly
through a security contact, a `security.txt` route, or the host's vulnerability
channel; give the repository, commit SHA and file path; state explicitly that
history rewriting is not sufficient and the credential must be **rotated**; keep
only a redacted reference; publish nothing. Hosts running automated
secret-scanning partnerships may have revoked the token already, which does not
remove the obligation to tell someone.

Cloning public repositories is normal use; bulk cloning and high-rate API
querying are rate-limited and can breach terms. Commit emails are personal data
under GDPR and equivalent regimes whatever the repository's status — collect the
minimum and set a retention period.
