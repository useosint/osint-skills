---
name: what-an-email-reveals
description: >-
  Investigate an email address — MX and syntactic validation, Gravatar lookup, corporate
  email-format inference, breach exposure, and full mail-header analysis covering the Received
  chain, Message-ID and SPF, DKIM and DMARC results. Use for email OSINT, verifying whether an
  address exists, finding accounts registered to it, guessing a company's email format, or
  tracing where a suspicious message actually came from. Applies to business email compromise
  and invoice-fraud investigation, phishing triage, vendor-payment verification, and
  pre-engagement research. Reference at useosint.com/skills/what-an-email-reveals.
disable-model-invocation: true
---

# What an email reveals

An email address is usually the highest-value selector in an investigation: it
carries a name, a domain, an account history, and a breach footprint. The
beginner error is trying to prove the address exists. Existence is the least
interesting thing about it, it is the hardest thing to establish passively, and
the techniques that establish it are the ones that expose you. Work the
structure and the footprint first; treat validation as a bonus.

Never send mail to the subject as a research technique.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Write down subject, objective,
in-bounds selectors, out-of-bounds actions, and the governing jurisdiction.
Decide in advance whether *interactive* probing — SMTP conversations,
password-reset flows, signup-form enumeration — is authorized. It usually is
not. Everything below is passive unless marked otherwise.

**Done when** scope is written and the interactive-probing decision is recorded.

## Step 2 — Parse and validate

Three different things get called "email validation". They are not
interchangeable.

| Method | What it proves | Cost |
|---|---|---|
| Syntactic | The string could be an address | Free, passive, proves nothing about the mailbox |
| Domain / MX | The domain exists and accepts mail | Free, passive, `dig MX example.com` |
| SMTP `RCPT TO` probe | The server claims the mailbox exists | Interactive, often blocked or lied to, and logged |

Do the first two. The third — opening an SMTP session and issuing `RCPT TO` to
see whether the server accepts the recipient — is a live conversation with the
subject's mail infrastructure from your IP. It gets logged, it gets your address
range blocklisted, and against a **catch-all domain** it is worthless: a
catch-all accepts every recipient, so every address "exists". Greylisting,
tarpitting, and accept-then-bounce policies produce the same useless answer.
Third-party validation APIs mostly wrap the same probe; the exposure moves to
the vendor, the accuracy limits do not change.

Then parse the local part. `first.last`, `flast`, `firstl`, `f.last` each imply
a name and, on a corporate domain, a company-wide convention — see
[reference/corporate-formats.md](reference/corporate-formats.md).

**Gmail normalisation matters.** Gmail ignores dots in the local part and
everything after a `+`. `j.doe+news@gmail.com`, `jdoe@gmail.com` and
`jd.oe@gmail.com` are one mailbox. Consequences: addresses that look different
in two breaches may be the same person, and a `+tag` frequently names the
service the address was given to, which is free intelligence about where the
subject holds accounts. Not every provider behaves this way — check before
assuming.

**Done when** the address is graded valid / invalid / unknown, the normalised
form is recorded, and the name hypothesis is written down.

## Step 3 — Gravatar

Gravatar maps an address to a public avatar by MD5 hash of the lowercased,
trimmed address. Compute the hash and request the avatar; a returned image
means the address was registered with the service, and the associated public
profile can carry a display name, a location, links to other accounts, and
verified accounts on other platforms.

```bash
printf '%s' "jdoe@example.com" | tr 'A-Z' 'a-z' | md5sum
```

Free, passive, no key. Run the avatar through `find-the-original-image`. Treat a
default fallback image as "no Gravatar", not as "address invalid".

**Done when** Gravatar presence is checked and any profile fields captured.

## Step 4 — Where is this address registered

The honest position: reliable account enumeration by email is an *oracle*
problem. Password-reset and signup forms disclose whether an address is
registered, which is exactly why tools exist to automate them — and exactly why
doing so is interactive, often against terms of service, and potentially
notifying (a reset request can email the subject). Flag it, get it authorized
explicitly, or don't do it.

Passive alternatives that cost you nothing:

- `google-like-a-spy` the full address in quotes, and the local part alone.
  Resumes, conference programmes, mailing-list archives, `WHOIS` history, and
  committed config files are full of addresses.
- Run `what-leaked-about-you`. Breach membership is the single best answer to
  "which services did this identity use", and it is retrospective rather than
  interactive.
- Push the local part into `hunt-a-handle` as a username seed.
- Search code hosting for the address in commit metadata via
  `secrets-in-git-history`.

**Done when** the service list is assembled and each entry is marked passive or
interactive in provenance.

## Step 5 — Read the headers, if you have the message

Only applies when you legitimately possess the message. Headers are where an
email stops being a selector and becomes evidence.

Read the `Received:` chain **bottom-up**: the bottom-most is the earliest hop,
and the originating host is there unless the sending platform strips it.
Everything below the first server you trust can be forged wholesale.

- `Message-ID` — the domain part and the ID's shape often identify the sending
  platform or mail client even when the visible headers are cosmetic.
- `Authentication-Results` — the receiving server's SPF, DKIM, and DMARC
  verdicts. A DKIM `pass` is the strongest thing in the header block: it is a
  cryptographic signature over content, so it survives forwarding claims.
- `X-Mailer` / `User-Agent` — client fingerprint, frequently left in place by
  bulk-mail tooling.
- `Return-Path` vs `From` — a mismatch is normal for mailing lists and
  suspicious in direct correspondence.

Field-by-field guide:
[reference/header-fields.md](reference/header-fields.md).

**Done when** the originating infrastructure is identified or explicitly stated
as unrecoverable.

## Where this goes wrong

- **Catch-all domains defeat verification outright.** Everything validates.
  Detect one by testing an address you invented; if a random string validates,
  every result from that domain is meaningless.
- **Disposable and forwarding services.** Throwaway domains mean the address was
  never meant to persist; relay and alias services (including provider-issued
  private-relay addresses) mean the visible address is a wrapper around a
  mailbox you cannot see. Both cap how far the address can take you — recognise
  them early rather than burning hours.
- **Role addresses** (`info@`, `sales@`, `admin@`) belong to functions, not
  people. Attributing one to an individual is the most common serious error in
  email OSINT, and it survives into reports because it looks like a finding.
- **Inferred addresses are hypotheses.** Deriving `j.doe@company.com` from a
  company pattern gives a plausible address, not a real one. Label it inferred,
  permanently.
- **Breach data is not proof of current ownership.** Addresses get abandoned,
  recycled by providers, and reassigned to new staff at the same company.
- **Forwarding is indistinguishable from forgery** at a glance. Mailing lists
  and security gateways rewrite headers in ways that look like tampering.

## Confidence grading

- **Confirmed** — a DKIM-passing message from the address, or the address
  published by the subject on a source they control, or an authenticated
  Gravatar profile matching a separately confirmed identity.
- **Probable** — MX-valid, appears in a breach alongside a corroborating
  selector, and the local part matches the subject's name pattern.
- **Unconfirmed** — inferred from a corporate format, or found in a single
  aggregator or combolist with no second source.
- **Rejected** — proven catch-all with no supporting evidence, a known
  disposable domain with no linked activity, or a role address attributed to an
  individual on no basis but the domain.

## Worked example

Given `j.okonkwo@northwind-eng.example`. `dig MX` returns records at a hosted
provider — the domain takes mail. Gravatar: no avatar, so no profile pivot.

Two employee addresses in a conference PDF are `t.mwangi@` and `s.aldridge@`, so
the convention is `first-initial.lastname`. That makes `j.okonkwo@`
structurally consistent — evidence about the *format*, not evidence the person
exists. No SMTP probe is run; interactive steps are out of scope here.

The dead end: `what-leaked-about-you` returns nothing for the address, which
initially reads as "not a real user". Re-running against the Gmail-normalised
personal address recovered from a code-hosting commit gives three breaches, one
of them a developer forum with the handle `sunfish_ada`. That handle goes to
`hunt-a-handle`. The corporate address stays graded inferred; the personal one
is the working selector.

## Pivots

| New selector | Skill |
|---|---|
| Name from local part or Gravatar | `find-anyone` |
| Local part as username | `hunt-a-handle` |
| Email domain | `who-owns-this-domain`, `recon-a-domain-passively` |
| Employer from a corporate domain | `x-ray-a-company` |
| Breach appearances | `what-leaked-about-you` |
| Address in commits or config | `secrets-in-git-history` |
| Originating IP from headers | `find-exposed-servers` |
| Gravatar or profile avatar | `find-the-original-image` |
| Address posted in dumps or channels | `find-leaks-in-the-wild` |

## Legal and ToS notes

SMTP probing and password-reset enumeration are interactive, commonly prohibited
by terms of service, and in some jurisdictions arguably unauthorized
interrogation of a system. Get them in writing before you use them. Under GDPR
and UK data protection law an email address is personal data on its own —
collect only what the objective needs, store it encrypted, and set a deletion
date with the case file. Message content you possess may carry separate
confidentiality or privilege obligations independent of the OSINT question.

## Step 6 — Report

Run `write-the-intel-brief`. State validity and how it was established, whether
the domain is catch-all, the service list with passive/interactive provenance,
breach exposure, and the identity attribution with its confidence grade.

**Done when** every address is marked observed or inferred, and no inferred
address is stated as fact.
