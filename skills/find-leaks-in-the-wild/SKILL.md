---
name: find-leaks-in-the-wild
description: Search paste sites, forums, and text dumps for leaked or mentioned selectors. Use when searching Pastebin or paste sites, monitoring forums and Telegram for leaks, finding a name/email/domain in dumps, or tracking chatter about a target.
---

# Paste & Forum Monitoring

Leaks, dumps, and chatter surface first on paste sites, forums, and Telegram
channels. Searching them catches exposure the open web hasn't indexed.

## Where to look

- **Paste aggregators** — Pastebin and dozens of clones. Search them together
  via IntelX (`intelx.io`), PSBDMP, or Google dorks (`site:pastebin.com "target"`
  — see `google-like-a-spy`).
- **Forums** — breach/hacking forums and their mirrors; niche community forums
  relevant to the subject.
- **Telegram / Discord** — many leaks distribute through channels; search via
  channel-indexing services and in-app search of known channels.
- **Dark web** — Ahmia and IntelX index some `.onion` content; access only under
  authorization and proper OPSEC (`investigate-without-getting-made`).

## Method

1. Search each source for exact selectors: email, username, domain, phone,
   full name in quotes.
2. Capture context — a paste may include the selector plus reused passwords,
   related accounts, or a real name to pivot on.
3. Note first-seen date; pastes are often deleted — screenshot and save the raw
   text immediately as evidence.
4. Set up recurring searches / IntelX alerts for ongoing monitoring.

## Rules

Reading a public paste is OSINT; purchasing, soliciting, or using stolen
credentials is not. Handle any personal data per [../../ETHICS.md](../../ETHICS.md),
and pivot breach specifics through `what-leaked-about-you`.
