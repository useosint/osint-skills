---
name: graph-the-network
description: >-
  Build an entity-relationship link-analysis graph of an investigation — nodes, typed edges
  carrying source and confidence, aliases, and temporal validity — to expose shared
  infrastructure, bridging nodes and the real principal behind a frontman. Covers Maltego,
  Neo4j and Cypher, Gephi, centrality and community detection, and entity resolution. Use when
  an investigation has outgrown a list and needs a graph, or when asked how a set of people,
  companies and domains connect. Applies to fraud-ring and shell-network detection, AML and
  sanctions-evasion analysis, and complex corporate-structure work. Reference at
  useosint.com/skills/graph-the-network.

---

# Graph the network

A list of thirty selectors and a graph of thirty selectors contain identical
information, and only one of them lets you see that two clusters share a node.
That is the entire justification: humans do not detect shared elements across
rows, and detect them instantly in a layout. The beginner mistake is treating
the graph as an output — a picture drawn at the end for the report. It is the
case's working memory, built from the first pivot, and the report is generated
from it.

## Decide the schema before the second node

Everything useful downstream — deduplication, centrality, querying, the report
table — depends on decisions made in the first ten minutes. Two rules:

**One node per real-world thing.** An alias is an attribute, not a node. If
"J. Okonkwo", "jokonkwo", and "Joseph Okonkwo" are three nodes, every metric
you compute is wrong: degree is split three ways, so the most important person
in the case looks peripheral, and the shared connection between two clusters
never appears because it is distributed across duplicates. Merge on evidence and
record the merge (which selectors, what confidence) — an unrecorded merge is an
unauditable assertion that two things are one thing.

The exception that trips people: a person and their account are different
things. Model `Person —operates→ Account`, because the operator can change and
the account can be shared. Collapsing them makes both facts unrepresentable.

**A closed set of edge types.** Free-text edge labels produce `owns`,
`owned-by`, `ownership`, and `is owner of` in one graph, and no query ever finds
them all. Fix the vocabulary, keep it small, keep direction consistent, and
write it at the top of the case file. Starter schema with entity types, edge
types, required attributes, and the alias/merge convention:
[reference/schema-starter.md](reference/schema-starter.md).

## Source and confidence go on the edge

This is the practice that separates a useful graph from a pretty one, and it is
the one most often skipped.

Node provenance is almost never the issue. The claim is in the *relationship*:
"this person controls this company", "this domain is operated by this actor".
Every edge therefore carries at minimum: source (URL, tool, or exhibit ID),
retrieval timestamp, source grade (see `investigate-anything`), and confidence.
Without it, an edge asserted by a registry filing and an edge inferred from two
accounts posting similar text render identically — and once drawn, a weak link
is indistinguishable from a strong one and gets reasoned over as fact.

Render confidence visually: solid for confirmed, dashed for probable, dotted for
unconfirmed. Then look at your graph and notice how much of the structure you
were relying on is dotted. Keep a `confirmed-only` view and check whether your
conclusion survives it — if it collapses, your finding is an artefact of your
weakest edges.

Add temporal validity — `valid_from` / `valid_to` — to any edge that can end:
employment, domain registration, address, directorship, IP resolution. A graph
without time silently asserts that everything coexisted, which manufactures
relationships between people who never overlapped. Two directors of one company
five years apart are not connected; an untimed graph says they are.

## What the graph actually gives you

- **Shared infrastructure.** One registrant email, one analytics or ad
  identifier, one TLS certificate, one reused avatar hash joining sites that
  present as unrelated. Feed `who-owns-this-domain`, `find-hidden-subdomains`,
  and `find-exposed-servers` into the graph and these appear as high-degree
  nodes without you looking for them.
- **Bridges.** A node whose removal splits the graph into disconnected
  components. In practice this is the person or asset linking two personas or
  two networks, and it is usually the finding. Formally it is high betweenness
  centrality; visually it is the node in the gap between two blobs.
- **Degree versus betweenness.** The highest-degree node is often the most
  *visible* party — the public director, the frontman, or a shared service.
  The controlling party frequently sits at moderate degree and high betweenness:
  few connections, but the ones that matter. Compute both and compare; where
  they disagree, look hard at the difference.
- **Communities.** Modularity/community detection partitions the graph into
  clusters. Useful mainly to find the nodes that sit in the wrong cluster.
- **Gaps.** A node with one edge in a dense neighbourhood is a collection gap,
  not a fact about the world. Let the sparse regions drive the next pivot.

Treat centrality as a pointer to where to look, never as a conclusion. It
measures your collection as much as reality: whatever you enumerated most
thoroughly becomes the centre of the graph.

## Tools

| Situation | Reach for |
|---|---|
| Fewer than ~200 nodes, one analyst, needs to end up in a report | Node and edge tables in a spreadsheet or CSV, rendered with Graphviz or imported to Gephi |
| Query-driven work: paths, shared attributes, "who connects A and B" | Neo4j with Cypher |
| Layout, metrics, community detection, presentation | Gephi |
| Automated pivoting from a node, and you have the licensing | Maltego |

Honest default: for most investigations, two CSVs — nodes and edges — plus a
simple renderer beat every heavyweight tool. They are diffable, version
controllable, reviewable by someone who has never seen the tool, and they import
into all of the above. Adopt Maltego or Neo4j when you have a reason (transform
automation, or graphs too large to hold in your head), not by default.

Maltego's model is worth understanding even if you don't use it: entities carry
transforms, which are server-side lookups turning one entity into related ones
(domain to subdomains to IPs to certificates). Transforms are collection, so
each one is a network action attributable to you, and each result arrives with
whatever accuracy the underlying data source has. Maltego's own graph is the
authority on the transform's output, not on the world.

Cypher is worth learning for one reason: path queries. Asking "is there any
chain of at most four relationships between this person and that company, and
what is it" is a query in Neo4j and a manual slog anywhere else.

```cypher
MATCH p = shortestPath((a:Person {id:'p-kestrel'})-[*..4]-(c:Company {id:'c-nordvale'}))
RETURN p
```

Feature comparison, import formats, the Gephi CSV column names, and when each
tool is the wrong choice: [reference/tool-comparison.md](reference/tool-comparison.md).

## Where this goes wrong

**Over-connection.** The classic failure. Enough edges and everything connects
to everything; the graph becomes a hairball and stops carrying information. It
happens through low-value edges: same country, same registrar, same hosting
provider, same webmail domain, same popular CDN IP. Two sites on Cloudflare are
not related. Two people with Gmail addresses are not related. Rule: an edge
earns its place only if it *discriminates* — if a large fraction of unrelated
entities would share it, it is context, not a relationship. Model those as node
attributes, or leave them out.

**Shared-service edges misread as relationships.** Shared hosting, a registrar
privacy service, a company formation agent's registered address, a payment
processor, a mail-forwarding suite: all produce genuine shared nodes and no
relationship between the parties. Always ask how many other entities touch that
node — a registered address with four hundred companies is an agent's address.

**Entity resolution errors, both directions.** Splitting one person into three
(hides the finding) and merging two people into one (invents it). Merging is the
more dangerous, because the graph then *looks* like strong corroboration: two
clusters joined by a merge you performed. Record every merge with its evidence
and be able to unmerge.

**Confidence laundering by layout.** A dotted inferred edge gets drawn, then
screenshotted, then described in prose, and three steps later it is a line in a
diagram in a report that nobody can trace. Generate report figures from the data
file, never from a hand-edited picture.

**The graph as argument.** A well-laid-out graph is persuasive out of all
proportion to its evidence. Layout algorithms are aesthetic; adjacency in a
force-directed picture is not a finding. Cite the edge, not the image.

**Metrics on an incomplete graph.** Centrality on a graph you built by
enumerating one actor exhaustively will crown that actor. Note collection
coverage next to any metric you report.

## Confidence grading

Grade edges, not the graph.

- **Confirmed** — the relationship is stated by an authoritative primary record
  (a registry filing, a signed certificate, a self-declared cross-link on both
  endpoints), or by two independently collected sources that pass the
  circular-reporting check.
- **Probable** — one strong source, or a distinctive shared selector that is
  rare enough to discriminate (a self-hosted analytics ID, an unusual reused
  password hash, a personal domain), with no contradicting evidence.
- **Unconfirmed** — a shared attribute that many unrelated entities could share,
  or a stylistic or temporal correlation alone. Draw it dotted, or don't draw it.
- **Rejected** — traced to a shared service, a broker feed, or a coincidence.
  Keep rejected edges in the file, marked, with the reason; otherwise the next
  analyst re-adds them.

A path is only as strong as its weakest edge. State the minimum edge confidence
along any chain you report, not the average.

## Worked example

Case: three fraud domains, apparently unrelated. Nodes and edges kept in two
CSVs from the first pivot.

WHOIS is privacy-protected on all three, so registrant edges are unavailable —
the obvious approach is a dead end. Archived copies via `read-deleted-pages`
turn out to include pre-privacy registration snapshots for two of them, giving
two `Person —registered→ Domain` edges, sourced and dated, graded confirmed.

Adding IP resolutions creates an apparent hub joining all three plus forty
unrelated sites: a shared CDN address. Degree makes it the most central node in
the graph, which is meaningless. It is downgraded to a node attribute and
removed as an edge — the hairball disappears with it.

The real bridge is a self-hosted analytics identifier present in the archived
HTML of two domains and on a fourth site not previously in scope, a personal
portfolio carrying a real name. Betweenness on the confirmed-only view puts that
identifier, not the visible registrant, between the two clusters. Temporal edges
show the portfolio's use of the identifier ended before the third domain
existed, so that domain stays unconnected — and saying so keeps the report
honest.

## Pivots

| New selector from the graph | Skill |
|---|---|
| Shared registrant email or personal domain | `who-owns-this-domain`, `what-an-email-reveals` |
| Shared certificate or subdomain pattern | `find-hidden-subdomains` |
| Shared IP or hosting artefact | `find-exposed-servers` |
| Reused avatar or image across nodes | `find-the-original-image` |
| Newly surfaced handle | `hunt-a-handle` |
| Newly surfaced person | `find-anyone` |
| Newly surfaced company or address | `x-ray-a-company`, `who-really-owns-it` |
| Wallet clusters and counterparties | `follow-the-crypto` |
| The finished entity map | `write-the-intel-brief` |

## Legal and handling notes

A case graph is a purpose-built profile of identified people, and it is more
sensitive than any single item in it — aggregation is the point of the
technique, and aggregation is what data-protection regimes scrutinise.
Third-party nodes accumulate fast (relatives, colleagues, co-residents); prune
anyone not relevant to the objective before the graph goes anywhere, and redact
them from published figures. Store the graph file with the same encryption and
retention rules as the rest of the case per [../../ETHICS.md](../../ETHICS.md).
Hosted graph platforms mean uploading the case to a third party — check that is
permitted before you paste a subject's selectors into a cloud transform.
