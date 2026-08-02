# Contributing

New skills and improvements are welcome. Keep them sharp and honest.

## Add a skill

1. Create `skills/<skill-name>/SKILL.md` (lowercase, hyphens, max 64 chars).
2. Add YAML frontmatter:
   - `name` — matches the directory.
   - `description` — third person, what + when, packed with trigger terms.
   - `disable-model-invocation: true` **only** for user-invoked workflow skills
     (the ones a human types by name). Omit it for auto-triggered knowledge
     skills.
3. Keep `SKILL.md` under ~150 lines. Push long reference material into a sibling
   file (`reference.md`, `sources.md`) and link to it once.
4. Use the shared vocabulary: **selector** (an identifiable data point) and
   **pivot** (turning one selector into new ones).
5. Every workflow skill must open with an **authorized scope** gate pointing at
   [ETHICS.md](ETHICS.md).

## Quality bar

- Real tools, real commands, real source URLs — no hand-waving.
- Prefer passive, ToS-respecting techniques. Flag anything intrusive.
- Give each step a checkable completion criterion.
- No time-sensitive phrasing ("as of 2026…"); write durable instructions.

## Test

Run `./install.sh --copy --target /tmp/skills-test` and confirm every skill
appears and loads without frontmatter errors.
