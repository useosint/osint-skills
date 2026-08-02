# Inferring a corporate email format

Most organisations issue addresses from a single template. Recover the template
from a few known addresses and you can generate a plausible address for any
employee whose name you have. The output is always a *hypothesis*, and must be
labelled inferred in any report.

## Common templates

Running example: Jane Q. Okonkwo at `northwind.example`.

| Pattern | Result |
|---|---|
| `first.last` | jane.okonkwo@ |
| `firstlast` | janeokonkwo@ |
| `first_last` | jane_okonkwo@ |
| `first-last` | jane-okonkwo@ |
| `flast` | jokonkwo@ |
| `f.last` | j.okonkwo@ |
| `firstl` | janeo@ |
| `first.l` | jane.o@ |
| `first` | jane@ |
| `last` | okonkwo@ |
| `last.first` | okonkwo.jane@ |
| `lastf` | okonkwoj@ |
| `fmlast` | jqokonkwo@ |
| `first.middle.last` | jane.q.okonkwo@ |
| `employee ID` | e40122@ |
| `first.last<n>` | jane.okonkwo2@ (collision suffix) |

Roughly in order of prevalence: `first.last`, `flast`, `firstlast`, `first`,
`f.last`. Start there.

## Deriving the pattern

You need two or three real addresses with known corresponding names. Sources
that are public and passive:

- Press releases, investor relations pages, and regulatory filings — media
  contacts are almost always real, individual addresses.
- Conference programmes, academic papers, and standards documents (PDFs).
- Job postings that name a hiring contact.
- Mailing-list archives, bug trackers, and public support forums.
- Commit metadata on code hosting: corporate laptops commit with corporate
  addresses. Use `secrets-in-git-history`.
- Domain registration and technical contacts, where not redacted: use
  `who-owns-this-domain`.
- `google-like-a-spy` with the domain plus an `@` and a common first name.

Two addresses that agree on a pattern are a weak inference. Three from
independent sources is workable. One is nothing.

## Complications that break the inference

**Multiple domains.** Large organisations run separate domains for corporate,
engineering, regional subsidiaries, and acquisitions. The pattern may be
consistent while the domain is not. Check MX records for candidate domains and
look for which one the known addresses actually use.

**Acquisitions.** Staff from an acquired company often keep legacy addresses,
which get forwarded. Someone's real address may follow the *previous* employer's
convention entirely.

**Collisions.** Two people with the same name force a deviation — a middle
initial, a number, a full first name where others get an initial. The deviation
is invisible from outside.

**Name normalisation.** Accents, hyphens, apostrophes, and non-Latin scripts get
transliterated or stripped, and different organisations do it differently.
Compound and multi-part surnames may be joined, hyphenated, or truncated.
Preferred names diverge from legal names ("Bob" for Robert), and the address may
use either.

**Aliases.** Many organisations issue several addresses per mailbox — a
`first.last` alias over an employee-ID mailbox, for example. Both work; only one
appears in the directory.

**Catch-all domains.** If the domain accepts everything, no amount of validation
will distinguish a real address from a generated one. Test with an obviously
invented name before believing any verification result.

## Role and functional addresses

`info@`, `sales@`, `support@`, `admin@`, `hr@`, `security@`, `abuse@`,
`postmaster@`, `noreply@`, `careers@`, `press@`, `legal@`.

These belong to a function and are usually read by a shared mailbox or a
ticketing system. Never attribute one to a named individual. They are still
useful: `abuse@` and `security@` are often required to be monitored and can
confirm a domain is actively administered, and the auto-reply from a ticketing
system fingerprints the vendor — though soliciting one is interaction, not
passive research.

## Using an inferred address

Do not treat it as confirmed by an SMTP probe — probing is interactive, and
catch-all domains make the result meaningless anyway. Instead, look for the
inferred string appearing independently: in a breach corpus via
`what-leaked-about-you`, in indexed documents via `google-like-a-spy`, in commit
history, or on Gravatar. An independent appearance upgrades the hypothesis to a
finding. Nothing else does.

Record inferred addresses in a separate column from observed ones. The
distinction gets lost the moment they share a table, and an inferred address
that leaks into a client report as fact is a serious error.
