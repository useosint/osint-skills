# Git archaeology cookbook

Commands for pulling identity, infrastructure and secrets out of a repository's
full history. All of it operates on a local clone — cloning a public repository
is a normal read, but everything downstream is analysis you do offline.

Clone so that you actually get everything. A default clone gives you one branch
at full depth and the remote-tracking refs; a mirror clone gives you every ref
the server will serve, including tags and, on some hosts, refs you would
otherwise never see:

```bash
git clone --mirror https://github.com/example-org/example-repo.git repo.git
cd repo.git
```

A mirror clone is a bare repository. Use `git --git-dir=repo.git <command>` or
work inside it directly.

## Identity extraction

Every commit carries two identities — the author who wrote it and the committer
who applied it. They differ on rebases, cherry-picks, merges applied through a
web UI, and anything a bot touched, and the difference is informative.

```bash
# Every distinct author across every ref
git log --all --format='%an <%ae>' | sort -u

# Authors and committers together
git log --all --format='%an <%ae>%n%cn <%ce>' | sort -u

# Ranked by commit count — tells you who actually built the thing
git log --all --format='%ae' | sort | uniq -c | sort -rn

# First and last commit per author, for tenure
git log --all --format='%ae %aI' | sort -u -k1,1
```

Commit timestamps carry a UTC offset in the author date. Collected across
hundreds of commits, the offsets give you a working timezone, and shifts in that
offset over time indicate relocation or travel. Hour-of-day distribution gives
you a working pattern. Neither is conclusive — laptops travel, offsets are
faked, and CI commits at UTC — but as a corroborating signal it is strong.

```bash
# Timezone offsets by frequency
git log --all --format='%ai' | awk '{print $3}' | sort | uniq -c | sort -rn

# Hour-of-day distribution in the author's own local time
git log --all --format='%ad' --date=format-local:'%H' | sort | uniq -c | sort -n
```

## Searching history for content

Three different searches, and people conflate them.

**Pickaxe (`-S`)** finds commits where the *number of occurrences* of a string
changed — that is, where it was added or removed. This is the one you want for
"when did this secret enter and leave the repository".

```bash
git log --all --source -S'AKIA' --oneline
git log --all --source -S'password' --pickaxe-all --oneline
git log --all -S'internal.example.com' -p        # with the diffs
```

**Regex diff search (`-G`)** finds commits whose diff text matches a pattern,
including changes that do not alter the occurrence count:

```bash
git log --all -G'api[_-]?key\s*=\s*["'"'"'][A-Za-z0-9]{20,}' --oneline
```

**Grep across a tree (`git grep`)** searches file contents at a given revision,
not the diff. To search all of history, drive it over the revision list:

```bash
git grep -n 'BEGIN RSA PRIVATE KEY' $(git rev-list --all)
git grep -In --heading 'AKIA' $(git rev-list --all -- '*.tf')
```

That last form gets slow on large repositories. Scope it with a pathspec or a
date range before you run it on anything substantial.

## Files that no longer exist

The whole point of the exercise: what was deleted.

```bash
# Every path that has ever existed in any ref
git log --all --pretty=format: --name-only --diff-filter=A | sort -u

# Deletions only, with the commit that removed them
git log --all --diff-filter=D --name-only --format='%H %aI %an'

# Full history of one path, including across renames
git log --all --full-history --follow -p -- config/database.yml

# Recover the last version of a deleted file
git show <commit>^:config/database.yml
```

`--diff-filter=D` is the fastest first pass on an unfamiliar repository. A file
that was added and then deleted three commits later is almost always something
someone realised they should not have committed.

## Enumerating every object

Refs are only one way into a repository's objects. Everything reachable can be
listed and inspected directly, which catches content in trees no branch points
at any more.

```bash
# Every object with its path, largest first — big blobs are dumps and archives
git rev-list --all --objects \
  | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
  | awk '$1=="blob"' | sort -k3 -rn | head -50

# Read one object
git cat-file -p <sha>
```

Unreachable and dangling objects survive in a local clone after a branch is
deleted or force-pushed over, until garbage collection removes them:

```bash
git fsck --unreachable --dangling --no-reflogs
```

On a fresh clone this returns little, because the server only sends reachable
objects. It matters when you have a repository that was handed to you, a backup,
or a copy taken before a history rewrite.

## Automated secret scanning

Two tools do the bulk of this work. Run both — their detector sets and their
false-positive profiles differ.

```bash
# Local clone, full history
trufflehog git file://./repo.git

# A remote repository or a whole organisation
trufflehog github --org=example-org

# Verified findings only
trufflehog git file://./repo.git --results=verified
```

**Understand what "verified" means before you use it.** TruffleHog verifies a
candidate credential by making a live API call to the provider to see whether it
authenticates. That is enormously useful for cutting false positives, and it is
an interaction with a third-party service using a credential you found. It
generates log entries on the credential owner's account. Inside an authorized
assessment this is usually fine and often expected; outside one, think hard, and
disable verification if you have any doubt.

```bash
gitleaks detect --source=. -v
gitleaks detect --source=. --report-format json --report-path gitleaks.json
gitleaks detect --source=. --log-opts='--all --since=2020-01-01'
```

Gitleaks is rule-driven and pattern-based, with no verification step, which
makes it the safer default when you must not touch the provider. Its
`--log-opts` passes arguments straight through to `git log`, so you can scope a
scan to a ref, a path, or a date range instead of rescanning everything.

Neither tool finds a secret it has no detector for. Custom formats, internal
token schemes, and plain hostnames and connection strings need your own regexes
and a manual pass. The indicator catalogue in
[high-signal-indicators.md](high-signal-indicators.md) is what to grep for by
hand.

## Host API pivots

Once you have a repository, the host's API gives you the social graph around it.
These are ordinary public reads; authenticate with your own token for a sane
rate limit.

```bash
# The commit's author email, even where the web UI does not display it
curl -s https://github.com/example-org/example-repo/commit/<sha>.patch | head -5

# Same data as JSON
curl -s https://api.github.com/repos/example-org/example-repo/commits/<sha> \
  | jq '.commit.author, .commit.committer, .author.login'

# Numeric user ID to current username — survives renames
curl -s https://api.github.com/user/12345678 | jq '.login, .created_at'

# Public org membership, and the repos and gists of each member
curl -s https://api.github.com/orgs/example-org/public_members | jq -r '.[].login'
curl -s https://api.github.com/users/jdoe/repos | jq -r '.[].full_name'
curl -s https://api.github.com/users/jdoe/gists | jq -r '.[].html_url'

# The social graph
curl -s https://api.github.com/users/jdoe/followers | jq -r '.[].login'
curl -s https://api.github.com/users/jdoe/following | jq -r '.[].login'
curl -s https://api.github.com/users/jdoe/starred | jq -r '.[].full_name'
curl -s https://api.github.com/users/jdoe/subscriptions | jq -r '.[].full_name'

# Recent public activity, with timestamps
curl -s https://api.github.com/users/jdoe/events/public | jq -r '.[] | "\(.created_at) \(.type) \(.repo.name)"'
```

The events endpoint holds only a recent window of activity. For anything older,
the public GitHub event stream is published as a historical archive dataset, and
querying that gets you years of a user's public activity rather than weeks.

GitLab exposes the equivalent surface under its own versioned API: project
commits, project members, user activity, and snippets. The pivots are identical;
only the paths differ.

## Assembling the picture

Work in this order and you waste the least time:

1. Mirror-clone. Enumerate authors, committers and their timezone distribution.
2. `--diff-filter=D` for deleted paths. Read anything that looks like config.
3. Both scanners over full history. Triage findings by whether they are still
   valid formats, not by tool confidence alone.
4. Pickaxe the specific strings that matter: the org's internal domain, cloud
   account identifiers, hostnames from the config files you found.
5. Largest blobs — dumps, archives, and databases someone committed once.
6. Pivot every distinct author email and username through the host API, then out
   to `hunt-a-handle` and `what-an-email-reveals`.
