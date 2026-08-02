---
name: secrets-in-git-history
description: Mine GitHub, GitLab, and git history for people, infrastructure, and leaked secrets. Use when investigating a developer or org on GitHub, finding leaked API keys or credentials in code, or pivoting from commits, emails, and repos.
---

# GitHub & Git Recon

Code hosts leak identities (commit emails), infrastructure (configs), and
secrets (keys). All public and passive.

## People from commits

Every commit carries an author name + email. Pull them:

```bash
git clone <repo> && git log --all --format='%an <%ae>' | sort -u
```

GitHub API exposes a user's repos, orgs, gists, followers, and starred repos:
`https://api.github.com/users/<user>/events/public` shows recent activity and
timezone (from commit timestamps). Reused commit email → `what-an-email-reveals`; handle →
`hunt-a-handle`.

## Secret hunting

Scan repos, history, and gists for leaked credentials:

```bash
trufflehog github --org=<org>        # verified secrets across an org
gitleaks detect --source=. -v        # local clone incl. full history
```

Deleted secrets often survive in git history and forks — always scan `--all`
history, not just HEAD. GitHub code search (`/search?type=code`) finds keys
across all public repos: search the org domain, internal hostnames, or key
prefixes (`AKIA` for AWS, `ghp_` for GitHub tokens).

## Org & infra mapping

- Org members, repos, and dependencies reveal the tech stack and team.
- Config files (`.env.example`, CI YAML, Terraform) leak hostnames, buckets, and
  service names → `recon-a-domain-passively` / `find-exposed-servers`.
- Issues, PRs, and wikis contain internal discussion and real names.

## Ethics

Finding a leaked key does not authorize using it. Report exposures responsibly;
never access systems with found credentials — see [../../ETHICS.md](../../ETHICS.md).
