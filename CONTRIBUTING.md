# Contributing

New skills and improvements are welcome. Keep them sharp and honest.

## Add a skill

1. Create `skills/<skill-name>/SKILL.md` (lowercase, hyphens, max 64 chars).
   Name it for the outcome, not the taxonomy — `find-hidden-subdomains`, not
   `certificate-transparency`. It's what a human reads on skills.sh.
2. Add YAML frontmatter:
   - `name` — matches the directory.
   - `description` — third person, what + when, packed with trigger terms.
     Because the names are outcome-led, the description carries all the routing
     weight: name the tools, record types, and jargon a user would actually type
     (WHOIS, RDAP, EXIF, ADS-B, crt.sh, Shodan…).
   - `disable-model-invocation: true` **only** for user-invoked workflow skills
     (the ones a human types by name). Omit it for auto-triggered knowledge
     skills.
3. Keep `SKILL.md` between 120 and 250 lines. Push long lookup material into a
   sibling `reference/` folder (query cookbooks, per-jurisdiction catalogues,
   format tables) and link each file once from `SKILL.md`.
4. Use the shared vocabulary: **selector** (an identifiable data point) and
   **pivot** (turning one selector into new ones).
5. Every workflow skill must open with an **authorized scope** gate pointing at
   [ETHICS.md](ETHICS.md).

## Quality bar

- Real tools, real commands, real source URLs — no hand-waving. Never invent a
  flag, an endpoint, or a statistic. If you can't verify it, describe the
  capability in prose instead.
- Every skill needs a "where this goes wrong" section: the concrete failure
  modes, coverage gaps, and ways the source misleads you. It's the part that
  makes a skill worth installing.
- Say how to grade a finding for *that* technique — confirmed, probable,
  unconfirmed — with criteria tied to its evidence types.
- Prefer passive, ToS-respecting techniques. Flag anything intrusive.
- Give each step a checkable completion criterion.
- No time-sensitive phrasing ("as of 2026…"); write durable instructions.
  Describe mechanisms, then name the current implementations.

## Test

Run `./install.sh --copy --target /tmp/skills-test` and confirm every skill
appears and loads without frontmatter errors.
