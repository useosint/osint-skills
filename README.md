<div align="center">

# 🕵️ OSINT Skills

### The open-source intelligence toolkit for AI coding agents

**28 battle-tested [Agent Skills](https://docs.cursor.com/) that turn Cursor, Claude, and other agents into a full OSINT investigation platform.**

Reconnaissance · Attribution · GEOINT · Threat Intel · Due Diligence · Digital Forensics

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-28-brightgreen.svg)](#-skill-catalog)
[![Ethics First](https://img.shields.io/badge/ethics-authorized%20use%20only-red.svg)](ETHICS.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-orange.svg)](CONTRIBUTING.md)
[![Works with](https://img.shields.io/badge/works%20with-Cursor%20%7C%20Claude%20%7C%20Codex-black.svg)](#-install)

</div>

---

## Why this repo

Open-source intelligence is a chain of **pivots**: you start with one
**selector** — a name, email, username, phone, domain, photo, or wallet — and
turn it into new ones until the picture is complete. Doing that well means
knowing dozens of tools and techniques and applying them in the right order.

**OSINT Skills packages that expertise into skills your AI agent invokes
automatically.** Ask it to "investigate this domain" or "geolocate this photo"
and it runs a real investigator's workflow — passive-first, sourced, and
ethical — pulling in the exact reconnaissance technique each step needs.

- 🔎 **10 workflow skills** you invoke by name to run a complete investigation.
- 🧠 **18 knowledge skills** the agent triggers automatically as it works.
- 🛡️ **Ethics baked in** — every workflow opens with an authorized-scope gate.
- 📎 **Everything sourced** — findings graded by confidence, cited, timestamped.
- 🧩 **Composable** — skills pivot into each other exactly like a real case.

> [!IMPORTANT]
> These skills are for **lawful, authorized, defensive** work only — threat
> intelligence, fraud investigation, due diligence, journalism, missing-persons,
> pentest recon, and personal digital self-defense. Read **[ETHICS.md](ETHICS.md)**
> before you start. No stalking, harassment, doxxing, or unauthorized access.

## Contents

- [Why this repo](#why-this-repo)
- [Install](#-install)
- [Quick start](#-quick-start)
- [Skill catalog](#-skill-catalog)
- [How the skills connect](#-how-the-skills-connect)
- [Who it's for](#-who-its-for)
- [FAQ](#-faq)
- [Contributing](#-contributing)
- [License & disclaimer](#️-license--disclaimer)

## 🚀 Install

```bash
git clone https://github.com/useosint/osint-skills.git
cd osint-skills
./install.sh            # symlinks all 28 skills into ~/.cursor/skills
```

| Command | Effect |
|---------|--------|
| `./install.sh` | Symlink into `~/.cursor/skills` (so `git pull` updates them) |
| `./install.sh --copy` | Copy instead of symlink |
| `./install.sh --claude` | Install into `~/.claude/skills` |
| `./install.sh --target DIR` | Install into any skills directory |

For a **single project**, copy the `skills/` folder into that repo's
`.cursor/skills/`. Restart your agent to load the skills.

## ⚡ Quick start

Type a workflow skill's name, or just describe the task and let the agent route:

```text
osint-investigation          → the start-here router; picks the right workflow
person-osint    "Jane Doe, Acme Corp, Berlin"
domain-osint    "example.com"
username-osint  "shadowfax_1990"
geoint-photo    <drag in a photo>       → where & when was this taken?
company-osint   "Acme Holdings Ltd"
osint-report                            → compile everything into a sourced brief
```

The workflow pulls in knowledge skills on its own — reverse image search, WHOIS,
certificate transparency, breach lookups, chronolocation, and more.

## 📚 Skill catalog

### 🧭 Workflow skills — you invoke these by name

Complete, step-by-step investigations with an authorized-scope gate and a report
handoff.

| Skill | What it does |
|-------|--------------|
| **`osint-investigation`** | Start-here router — picks the right workflow for your starting selector |
| **`person-osint`** | Build a sourced profile of an individual from public data |
| **`company-osint`** | Corporate intelligence & due diligence — entity, people, infra, risk |
| **`domain-osint`** | Passive recon of a domain/website/IP — DNS, subdomains, tech, history |
| **`username-osint`** | Enumerate a handle across hundreds of platforms |
| **`email-osint`** | Validate an email, find linked accounts & breaches, pivot to identity |
| **`phone-osint`** | Classify a number, find messaging apps & listings, attribute the owner |
| **`geoint-photo`** | Geolocate & verify a photo or video |
| **`social-media-osint`** | Deep-dive a profile — network, content, location, pattern of life |
| **`osint-report`** | Compile findings into a professional, sourced intelligence report |

### 🧠 Knowledge skills — the agent triggers these automatically

Focused reconnaissance techniques with real tools, commands, and sources.

| Skill | Domain |
|-------|--------|
| **`reverse-image-search`** | Find an image's source across Yandex, Lens, Bing, TinEye |
| **`exif-metadata-analysis`** | Extract EXIF/GPS/author metadata from files |
| **`whois-dns-recon`** | WHOIS/RDAP and DNS records (A, MX, TXT, SPF/DMARC) |
| **`certificate-transparency`** | Subdomain discovery from CT logs (crt.sh) |
| **`wayback-archives`** | Recover deleted/historical pages & posts |
| **`google-dorking`** | Advanced search operators to surface hidden content |
| **`github-git-recon`** | Mine repos & git history for people and leaked secrets |
| **`chronolocation`** | Geolocate & time-stamp imagery from visual clues |
| **`sockpuppet-opsec`** | Investigator OPSEC and research personas |
| **`breach-data-analysis`** | Data-breach exposure via HIBP and dumps |
| **`crypto-blockchain-tracing`** | Trace BTC/ETH wallets and transactions |
| **`flight-vessel-tracking`** | Track aircraft (ADS-B) and ships (AIS) |
| **`shodan-censys-recon`** | Internet-exposed hosts & services (passive) |
| **`paste-forum-monitoring`** | Search pastes, forums, and Telegram for leaks |
| **`media-verification`** | Detect deepfakes, edits, and misattributed media |
| **`people-search-engines`** | People-search aggregators & public records |
| **`corporate-registries`** | Companies, officers & beneficial ownership |
| **`link-analysis-graphing`** | Map selectors into a Maltego-style graph |

## 🔗 How the skills connect

```
                       ┌─────────────────────┐
                       │ osint-investigation │  (router)
                       └──────────┬──────────┘
        ┌──────────────┬──────────┼───────────┬──────────────┐
   person-osint   domain-osint  email-osint  geoint-photo  company-osint …
        │              │            │             │              │
        └── pivots into knowledge skills as needed ──────────────┘
   reverse-image-search · whois-dns-recon · certificate-transparency ·
   breach-data-analysis · chronolocation · github-git-recon · shodan-censys …
        │
        └────────────────────► osint-report  (sourced, graded, timestamped)
```

Each finding is a **selector**; each step is a **pivot**; every claim lands in
the report with a source, a date, and a confidence grade.

## 🧑‍💻 Who it's for

Threat intelligence analysts · fraud & AML investigators · penetration testers &
red teams · corporate due-diligence and KYC teams · journalists & fact-checkers ·
missing-persons and humanitarian researchers · CTF players · anyone auditing
their own digital footprint.

## ❓ FAQ

**What is an Agent Skill?** A markdown file (`SKILL.md`) that teaches an AI
agent a repeatable workflow. Cursor, Claude, and compatible agents load skills
from a skills directory and invoke them by name or automatically from context.

**Do I need to be a security expert?** No. Describe the task in plain language
("find everything about example.com") and the agent runs the investigator's
workflow for you, pulling in the right technique at each step.

**Is this legal?** OSINT — collecting *public* information — is legal in most
jurisdictions when done for a lawful purpose. Accessing private systems, using
leaked credentials, stalking, or harassment is **not**. Read [ETHICS.md](ETHICS.md)
and stay passive-first.

**Does it work offline / with API keys?** The skills are technique + tooling
guidance. Some tools (Shodan, HIBP, DeHashed) need their own API keys; free
alternatives are noted throughout. The skills themselves need no keys.

**Which agents are supported?** Anything that reads `SKILL.md`-style skills —
Cursor (`~/.cursor/skills`), Claude (`~/.claude/skills`), and similar. Use the
`--claude` / `--target` install flags.

**How do I add my own skill?** See [CONTRIBUTING.md](CONTRIBUTING.md) — one
folder, one `SKILL.md`, passive-first and sourced.

## ⭐ Star history

[![Star History Chart](https://api.star-history.com/svg?repos=useosint/osint-skills&type=Date)](https://star-history.com/#useosint/osint-skills&Date)

## 🤝 Contributing

New techniques and skills are welcome — see **[CONTRIBUTING.md](CONTRIBUTING.md)**.
Keep them passive-first, sourced, and honest.

## ⚖️ License & disclaimer

[MIT](LICENSE). Provided "as is" with no warranty. You are solely responsible for
using these skills lawfully and ethically — read **[ETHICS.md](ETHICS.md)**.

<div align="center">

**If this repo levels up your investigations, drop a ⭐ — it helps others find it.**

<sub>open-source intelligence · OSINT · reconnaissance · threat intelligence · digital forensics · GEOINT · SOCMINT · attribution · due diligence · Cursor skills · Claude skills</sub>

</div>
