# High-signal indicators

What to grep for by hand, and what a hit actually means. Automated scanners
cover the well-known credential formats; this list exists for the things they
miss and for the triage decision after they fire.

Prefixes and formats change as providers rotate their token schemes. Treat this
as a starting set and confirm the current format from the provider's own
documentation before you assert what a string is.

## Filenames worth searching for directly

A filename hit is worth more than a content hit, because the file's *presence*
in history is the finding regardless of whether the scanner recognised what was
inside it.

**Environment and application config**

`.env`, `.env.local`, `.env.production`, `.env.backup`, `settings.py`,
`local_settings.py`, `wp-config.php`, `config.php`, `application.properties`,
`application.yml`, `web.config`, `appsettings.json`, `database.yml`,
`secrets.yml`, `credentials.yml`, `parameters.yml`

**Cloud and infrastructure state**

`terraform.tfstate`, `terraform.tfstate.backup`, `*.tfvars`, `kubeconfig`,
`.kube/config`, `serviceAccount.json`, `gcloud-service-key.json`,
`.aws/credentials`, `.aws/config`, `.s3cfg`, `.boto`

**Key material and certificates**

`id_rsa`, `id_ed25519`, `id_dsa`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.jks`,
`*.keystore`, `*.ppk`, `*.ovpn`, `*.kdbx`

**Registry, tooling and shell state**

`.npmrc`, `.pypirc`, `.netrc`, `.git-credentials`, `.dockercfg`,
`.docker/config.json`, `.bash_history`, `.zsh_history`, `.mysql_history`,
`.psql_history`, `.irb_history`, `sftp-config.json`, `.idea/dataSources.xml`,
`.vscode/settings.json`

**CI and deployment**

`Jenkinsfile`, `.travis.yml`, `.circleci/config.yml`, `.gitlab-ci.yml`,
`.github/workflows/*.yml`, `docker-compose.yml`, `docker-compose.override.yml`,
`ansible/*.yml`, `deploy.sh`, `fabfile.py`

**Data that should never have been in a repository**

`*.sql`, `*.dump`, `*.bak`, `*.sqlite`, `*.db`, `*.csv` in an unexpected
directory, `*.xlsx` under anything named `data`, `backup` or `export`

Two heuristics that pay off. A filename with `backup`, `old`, `copy`, `tmp`,
`orig`, `local`, `test`, `prod` or a date in it, where a non-suffixed version
also exists, is somebody's working copy and is more likely to hold real values
than the sanitised original. And a `.example`, `.sample` or `.template` file is
a *map*: it names every variable the application expects, which tells you
exactly what to search for in history even when the real file was never
committed.

## Credential prefixes and shapes

| Pattern | What it is |
|---|---|
| `AKIA…` / `ASIA…` | AWS access key ID. `ASIA` is a temporary session key and expires; `AKIA` is long-lived |
| `-----BEGIN … PRIVATE KEY-----` | A private key of some kind. Check the next line for an encryption header — an unencrypted key is far more serious |
| `ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_`, `github_pat_` | GitHub tokens: personal, OAuth, user-to-server, server-to-server, refresh, and fine-grained |
| `glpat-` | GitLab personal access token |
| `xox…-` | Slack tokens. The character after `xox` distinguishes bot, user and app tokens |
| `sk_live_`, `rk_live_`, `pk_live_` | Stripe secret, restricted, and publishable keys. `pk_live_` is *meant* to be public; do not report it as a leak |
| `AIza…` | Google API key. Often genuinely public and restricted by referrer — check before escalating |
| `SG.` | SendGrid API key |
| `npm_` | npm access token |
| `shpat_` | Shopify access token |
| `sq0atp-`, `sq0csp-` | Square tokens |
| `eyJ…` | Base64url-encoded JSON — usually a JWT. Decode the payload for issuer, subject, scopes and expiry; check `exp` before you call it live |
| `DefaultEndpointsProtocol=…;AccountKey=…` | Azure storage connection string. The `AccountKey` is the credential |
| `"type": "service_account"` | Google Cloud service-account JSON. If `private_key` is populated this is a full credential |
| `mongodb://`, `postgres://`, `mysql://`, `redis://`, `amqp://` with a password | A connection string. The hostname is often as valuable as the password |

## Strings that are not credentials but are worth as much

These rarely trip a scanner and consistently produce pivots.

- **Internal hostnames and domains.** `*.internal`, `*.corp`, `*.local`,
  `*.lan`, and the org's own internal naming scheme. They map the network and
  frequently resolve in public DNS by accident. Take them to
  `find-hidden-subdomains` and `who-owns-this-domain`.
- **Cloud account identifiers.** AWS account numbers, GCP project IDs, Azure
  tenant and subscription GUIDs. Not secret, and they tie disparate repositories
  and organisations to one owner — that is a strong linkage signal.
- **Bucket and storage names.** `s3://`, `gs://`, and bare bucket names in
  config. Check whether they are publicly readable via `google-like-a-spy`.
- **Email addresses in config, ownership files and code comments.** `CODEOWNERS`
  and issue templates name the responsible humans. Into
  `what-an-email-reveals`.
- **Webhook URLs.** A Slack, Teams or Discord webhook URL *is* a credential —
  possession alone allows posting into the channel — and scanners often treat it
  as a low-severity finding. It is not.
- **Absolute filesystem paths** in build scripts and IDE config, which leak
  usernames, machine names and directory structure.
- **`TODO`, `FIXME`, `HACK`, `XXX` comments.** Developers write down what is
  broken, and the security-relevant ones say so plainly.
- **Comments naming people, tickets, or systems.** Ticket identifiers imply the
  issue tracker; the issue tracker is often public.

## Triage: is this finding real

Work down this list before you escalate anything.

1. **Is it a real format?** Check length, character set and prefix against the
   provider's documented shape. Most false positives fail here.
2. **Is it a placeholder?** `example`, `changeme`, `xxxx`, `your_key_here`,
   `AKIAIOSFODNN7EXAMPLE`, repeated characters, or a value that appears in the
   provider's own documentation. Search the string on the web — documentation
   examples propagate into thousands of repositories.
3. **Is it in a test fixture?** Test data, mock servers and recorded HTTP
   fixtures are full of credential-shaped strings. Some are real, because
   someone recorded a fixture against production. Do not dismiss on path alone,
   but weight it down.
4. **Is it public by design?** Publishable keys, client IDs, and referrer-locked
   API keys are meant to ship in a browser. Reporting one as a breach damages
   your credibility.
5. **Is it still in the current tree, or only in history?** Only in history means
   somebody noticed and removed it — and almost certainly did not rotate it,
   because removing the file feels like fixing it. History-only findings are
   frequently *more* live than current ones.
6. **What is the blast radius?** Read the surrounding config for what the
   credential grants. A read-only analytics key and a cloud root credential are
   different findings and warrant different urgency.
7. **Is it expired?** Session tokens, temporary credentials and JWTs carry
   expiry. A `exp` in the past makes it evidence of past practice, not a live
   exposure.

**You determine validity from format, context and metadata. You do not
authenticate with it.** No test call, no "just checking whether it still works",
no read-only operation to confirm. That is unauthorized access, and the
credential having been published does not change it.

## Where the leak lives besides the repository

- **Gists.** A secret gist is unlisted, not private — anyone with the URL reads
  it, and URLs leak. Enumerate a user's gists through the host API.
- **CI logs.** Public repositories have public build logs. Platforms mask known
  secret values, but masking fails when a value is base64-encoded, concatenated,
  URL-encoded, printed by a subprocess, or set outside the platform's secret
  store. Debug and verbose modes are where this happens.
- **Build artefacts.** Uploaded artefacts frequently include config files, and
  compiled bundles often embed values that were injected at build time.
- **Issue and pull-request attachments.** Files attached to issues are served
  from a content host by opaque URL and typically remain retrievable after the
  issue itself is deleted or the repository is made private.
- **Pull requests to a fork network.** A PR opened and closed without merging is
  still in the network's object store, reachable by commit SHA.
- **Wikis and project boards**, which are separate repositories and separate
  data stores with their own permissions, and are commonly forgotten in an
  access review.
- **Exposed `.git` directories on web servers.** A deployment that copies the
  working tree publishes `.git/config`, `.git/HEAD` and the object store, from
  which the full history is reconstructible. Finding an exposed `.git` is
  passive; retrieving it is active, is unambiguously accessing a system, and
  belongs only inside an authorized engagement.
