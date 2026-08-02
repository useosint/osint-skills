# Security & Responsible Use

## Reporting a vulnerability

Found a problem in the tooling, install script, or CI — or a skill that could
leak the investigator's own data or push someone toward an unsafe action? Open a
[GitHub security advisory](https://github.com/useosint/osint-skills/security/advisories/new)
(private) rather than a public issue, so it can be fixed before it's disclosed.

Please include what the skill/script does, the impact, and steps to reproduce.

## Reporting misuse

These skills are for lawful, authorized work only (see [ETHICS.md](ETHICS.md)).
If you find this repository being used or promoted for stalking, harassment,
doxxing, or unauthorized access, open an issue tagged `misuse` or contact the
maintainers privately.

## Handling case data

If you build on these skills, keep investigation material out of the repo:
`.gitignore` already excludes `cases/`, `evidence/`, and secrets. Store case data
encrypted, share on a need-to-know basis, and delete it when the work is done.
