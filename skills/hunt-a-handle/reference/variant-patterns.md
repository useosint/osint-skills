# Handle variant generation cheatsheet

Enumerating one handle finds the accounts a person created carelessly.
Enumerating their *naming habit* finds the rest. Work in both directions: from a
handle to the underlying name, and from a name to the handles it would produce.

Throughout, the running example is a subject named John Doe, born 1992, seed
handle `jdoe_92`.

## Direction 1: handle to name

Decompose the seed before you mutate it.

| Fragment | Reading | Test |
|---|---|---|
| `jdoe` | first-initial + lastname | Look for `johndoe`, `john.doe`, `j.doe` elsewhere |
| `_92` | birth year, or a graduation year, or a disambiguating counter | Cross-check against any stated age or school year |
| A dictionary word | Interest, pet, band, in-joke — not a name | Search the word with the other fragments |
| A repeated non-name string across platforms | A persistent alias predating the real-name accounts | Often the oldest and least curated identity |

A number suffix is the single most useful fragment because it is usually
meaningful: birth year, birth date, house number, jersey number, or the count of
times the preferred handle was already taken. `johndoe3` implies `johndoe`,
`johndoe1`, and `johndoe2` exist somewhere — and one of them may be the same
person on an older platform.

## Direction 2: name to handles

Given "John Doe", generate systematically rather than ad hoc.

**Order and joining**

```
johndoe   john.doe   john_doe   john-doe
doejohn   doe.john   doe_john   doe-john
```

**Initials and truncation**

```
jdoe   j.doe   j_doe   jd   doej   johnd   jodo   jdo
```

**Numeric suffixes** — append to each of the above:

```
92  1992  0192  92xx  1  01  2  3  7  99  007  123  420  69  2020
```

Birth year in two-digit and four-digit form is the highest-yield pair. Then
try the year with a separator: `johndoe.92`, `john_doe_1992`.

**Prefixes and affixes**

```
the<handle>   real<handle>   its<handle>   im<handle>   iam<handle>
official<handle>   <handle>official   mr<handle>   <handle>hq
x<handle>x   xX<handle>Xx   _<handle>_   .<handle>.
```

**Character substitution (leetspeak)**

| Letter | Substitutes |
|---|---|
| a | 4, @ |
| e | 3 |
| i | 1, ! |
| o | 0 |
| s | 5, $ |
| t | 7, + |
| b | 8 |
| g | 9, 6 |
| l | 1, or a pipe character |

Apply one substitution at a time before applying several — single-substitution
variants are far more common than fully leeted strings.

**Keyboard and typo neighbours** — deliberate misspellings people adopt when the
clean handle is taken: doubled letters (`johnndoe`), dropped vowels (`jhndoe`),
and homophone swaps.

**Locale and script** — transliteration variants of a non-Latin name
(`aleksandr`/`alexander`/`sasha`), accented characters stripped or retained, and
patronymic or maternal surnames used as the handle base.

## Direction 3: email local part

The email local part and the handle are frequently the same string, and the
crossover is bidirectional.

- Handle → email: try the handle at the major free providers and at any personal
  or employer domain you know. Validate via `what-an-email-reveals` rather than
  by sending mail.
- Email → handle: the local part of a known address goes straight into the
  enumerator as a seed. Strip Gmail dots and `+tags` first — `j.doe+shop@` is the
  mailbox `jdoe@`, and `jdoe` is the handle worth searching.
- Corporate address formats (`first.last@`, `flast@`, `firstl@`) also tell you
  which naming convention the person is used to typing, which sometimes carries
  over to their personal handles.

## Prioritising

Do not enumerate the full cross-product; it is thousands of strings and it will
get you rate-limited before it gets you an answer. Rank by:

1. Exact seed handle.
2. Separator variants of the seed.
3. Name-derived forms with the seed's number suffix (the suffix is the strongest
   signal of personal habit).
4. Name-derived forms with no suffix.
5. Single-substitution leetspeak of the top performers.
6. Everything else, only if the earlier tiers were thin.

After each tier, look at what actually hit. If the subject consistently uses
underscores and a two-digit year, generate more of that shape and drop the rest.
The point of tiering is to learn the habit early and spend the remaining budget
on it.

## Recording

Keep the full list of strings tried, including misses. A miss is a finding: it
bounds the search and stops the next analyst repeating it. Note which strings
were untestable because a platform rate-limited you mid-run — those are not
misses, they are unknowns, and they need re-running.
