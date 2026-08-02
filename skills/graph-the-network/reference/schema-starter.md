# Graph schema starter

Copy this, cut what the case doesn't need, and put the surviving vocabulary at
the top of the case file. Adding a type mid-case is fine; renaming one after
fifty edges exist is not.

## Entity (node) types

| Type | Represents | Natural key | Notes |
|---|---|---|---|
| `Person` | A human being | Case-assigned ID (`p-0001`) | Never key on name. Names collide and change. |
| `Account` | A platform account | `platform` + platform-issued numeric/immutable ID | Not the same thing as its handle, which is renameable. |
| `Handle` | A username string | The string | Optional. Useful when tracking a string across platforms before you know who holds it. |
| `Email` | A mailbox | Normalised address, lowercased | Note whether plus-addressing or dots were normalised, and how. |
| `Phone` | A number | E.164 | |
| `Domain` | A registrable domain | The apex domain | Subdomains as separate nodes only when they matter independently. |
| `Host` | A hostname / FQDN | The FQDN | |
| `IP` | An address | The address | Almost always a shared-service node — see the caution below. |
| `Certificate` | A TLS certificate | SHA-256 fingerprint | |
| `Company` | A legal entity | Jurisdiction + registration number | Never the trading name alone. |
| `Address` | A physical location | Normalised address string | Check occupancy count before treating as a link. |
| `Wallet` | A blockchain address | Chain + address | |
| `Document` | A filing, paste, post, archived page | Archive URL or exhibit ID | |
| `Media` | An image or video | Perceptual and cryptographic hash | |
| `Identifier` | Analytics ID, ad ID, API key, tracking pixel, favicon hash | The value | The highest-value discriminating node type there is. |

## Required attributes on every node

`id`, `type`, `label`, `aliases[]`, `first_seen`, `last_seen`, `source`,
`grade`, `notes`.

`aliases[]` is what stops duplicate nodes. Every spelling, transliteration,
former name, and handle variant goes in the alias list of the one node, never
into a new node.

## Edge types

Keep the direction fixed and the set closed.

| Edge | From → To | Meaning |
|---|---|---|
| `operates` | Person → Account | Person controls the account. |
| `uses_handle` | Account → Handle | |
| `owns` | Person/Company → Domain/Company/Wallet | Legal or beneficial ownership. |
| `registered` | Person/Company → Domain | Registrant of record. Weaker than `owns`. |
| `director_of` | Person → Company | Officer role. Time-bound. |
| `employed_by` | Person → Company | Time-bound. |
| `controls` | Person → Company | Beneficial control, distinct from a formal role. Usually inferred: mark it. |
| `resolves_to` | Host → IP | Time-bound and volatile. Always dated. |
| `serves_cert` | Host → Certificate | |
| `hosted_at` | Domain/Host → IP | Prefer `resolves_to`; keep only one of the two. |
| `contact_for` | Email/Phone → Domain/Company/Account | |
| `located_at` | Person/Company → Address | Time-bound. |
| `mentions` | Document → any | Weak by construction. |
| `posted` | Account → Document/Media | |
| `same_as` | any → any | An asserted identity merge that you have not yet performed. |
| `transacted_with` | Wallet → Wallet | Direction is value flow. Amount and timestamp required. |
| `shares_identifier` | any → any | Reserved for discriminating identifiers only. |
| `associate_of` | Person → Person | Last resort. If you can name the relationship, name it instead. |

## Required attributes on every edge

Non-negotiable — an edge without these is an unsourced assertion:

- `source` — URL, tool and query, or exhibit ID
- `retrieved` — UTC timestamp of collection
- `grade` — letter+digit source grade
- `confidence` — confirmed / probable / unconfirmed / rejected
- `valid_from`, `valid_to` — where the relationship can end (blank means
  unknown, not "always"; record which you mean)
- `method` — observed, or inferred; if inferred, the reasoning in one clause

## Alias and merge convention

1. Never create a second node for a name variant. Add to `aliases[]`.
2. To merge two existing nodes, write a merge record: the two IDs, the evidence,
   the confidence, the date, and who decided. Keep the retired ID as an alias of
   the survivor so old references still resolve.
3. Merge only on `confirmed`-grade identity evidence. `probable` identity gets a
   `same_as` edge instead, which keeps the two nodes separate while recording
   your belief — and keeps every metric honest if you turn out to be wrong.
4. Unmerging must be possible. If it isn't, you merged too early.

## Low-value nodes to model as attributes, not edges

These connect unrelated entities and create hairballs. Store as node attributes
so they remain searchable without polluting the topology:

- Shared CDN or cloud provider IPs and ASNs
- Popular webmail domains
- Registrars and registrar privacy/proxy services
- Nameservers of large hosts
- Company formation agents' registered addresses and mail-forwarding suites
- Country, language, and timezone
- Payment processors, and app-store publisher accounts of large platforms

The test before adding an edge: *if I picked two unrelated entities at random
from this population, how likely is it they'd share this?* Likely means
attribute. Unlikely means edge.

## Minimal CSV layout

`nodes.csv`

```
id,type,label,aliases,first_seen,last_seen,source,grade,notes
p-0001,Person,A. Kestrel,"Kestrel A.;a.kestrel",2019-04-02,2024-03-11,registry filing 09xxxxxx,B2,
```

`edges.csv`

```
source_id,target_id,edge_type,confidence,grade,source,retrieved,valid_from,valid_to,method
p-0001,c-0007,director_of,confirmed,A1,https://registry.example/company/09xxxxxx,2024-03-11T09:12Z,2019-04-02,2022-11-30,observed
```

Two files, diffable in git, importable everywhere. Rename the columns to
`Id`/`Label` and `Source`/`Target` on export when a tool requires it rather than
contorting the working files.
