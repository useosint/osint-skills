# Link-analysis tool comparison

## Summary

| Tool | Best at | Weak at | Cost model | Data leaves your machine? |
|---|---|---|---|---|
| CSV + Graphviz | Small cases, version control, report figures | Interactivity, metrics, large graphs | Free | No |
| Gephi | Layout, visual exploration, network metrics, community detection | Being a database; editing data; provenance | Free, open source | No |
| Neo4j | Path and pattern queries, attributes, scale, temporal filtering | Presentation-quality layout | Free community edition; paid/managed tiers | No, unless you use the managed service |
| Cytoscape | Detailed visual styling driven by attributes | OSINT-specific workflows | Free, open source | No |
| yEd | Hand-arranged diagrams that must look right | Analysis; it is a diagram editor | Free desktop app | No |
| Maltego | Automated pivoting via transforms, entity-native OSINT workflow | Cost; opacity of transform sources; lock-in | Tiered, most useful transforms are paid | Yes — transforms are server-side lookups |
| Commercial analyst platforms (i2-class) | Institutional casework, timelines, disclosure workflows | Cost, procurement, and learning curve | Enterprise | Depends on deployment |
| Obsidian graph view | Note-linking while you work | Anything analytic — it is not a link-analysis tool | Free tier | No |

## CSV plus a renderer

The default for a reason: `nodes.csv` and `edges.csv` are readable by a
colleague, diffable in git so the graph's history is the case's history, and
importable by everything below.

Graphviz renders them once you emit DOT. `dot` for hierarchical layouts, `neato`
and `sfdp` for force-directed ones, `-Tsvg` or `-Tpng` for output. Map
confidence to `style=solid|dashed|dotted` and keep the mapping in a legend on
the graph itself.

```
dot -Tsvg case.dot -o case.svg
sfdp -Tpng case.dot -o case.png
```

Generate the DOT from the CSVs with a short script. Never hand-edit the DOT —
the CSVs are the source of truth, and a hand-edited figure is an unsourced
claim.

## Gephi

Import CSVs through the Data Laboratory. Gephi expects specific column headers:
a node table with `Id` and `Label`, and an edge table with `Source` and
`Target`, optionally `Type` (`Directed`/`Undirected`), `Id`, `Label`, and
`Weight`. Additional columns are imported as attributes.

What it is good for:

- **ForceAtlas2** layout, which pulls densely connected groups together and
  pushes unrelated ones apart. Enable "prevent overlap" and "dissuade hubs"
  before drawing conclusions about who sits where.
- **Modularity** for community detection, then colour by the resulting class.
  The interesting nodes are the ones whose community assignment contradicts your
  expectation.
- **Centrality metrics.** Degree is immediate; betweenness and closeness are
  computed by the average-path-length statistic. Size nodes by betweenness and
  colour by community and the picture answers "who bridges what" directly.
- **Filters** on attributes — restrict to confirmed-confidence edges, or to a
  date range, and re-run layout to see whether your finding survives.

What it is not: a place to store the case. Edits made in Gephi drift from your
CSVs. Treat it as read-only over exported data.

## Neo4j and Cypher

Worth the setup when you need queries rather than pictures. Load CSVs with
`LOAD CSV WITH HEADERS`, then ask structural questions:

Everything a person touches, two hops out:

```cypher
MATCH (p:Person {id:'p-0001'})-[*1..2]-(n)
RETURN p, n
```

Shortest connection between two entities, restricted to confirmed edges:

```cypher
MATCH p = shortestPath(
  (a:Person {id:'p-0001'})-[r*..5]-(c:Company {id:'c-0007'})
)
WHERE ALL(x IN r WHERE x.confidence = 'confirmed')
RETURN p
```

Shared discriminating identifiers between otherwise separate domains:

```cypher
MATCH (d1:Domain)-[:shares_identifier]->(i:Identifier)<-[:shares_identifier]-(d2:Domain)
WHERE d1.id < d2.id
RETURN i.label, collect(d1.label + ' / ' + d2.label) AS pairs
ORDER BY size(pairs) DESC
```

That last query, sorted descending, is also your hairball detector: an
identifier shared by dozens of pairs is a shared service, not a relationship —
demote it to an attribute.

Neo4j's plugin ecosystem provides graph-algorithm procedures including
centrality and community detection, so you can compute betweenness in the
database rather than exporting to Gephi. Check what your installation actually
has before relying on it.

Temporal filtering is Neo4j's real advantage over the picture-first tools: store
`valid_from`/`valid_to` on relationships and constrain queries to an interval,
so you stop discovering connections between people who never overlapped.

## Maltego

The model: **entities** (typed nodes) and **transforms** (server-side lookups
that take an entity and return related entities). Chains of transforms can be
saved as macros. It is the fastest way to go from one domain to a populated
graph, and that is both its value and its risk.

Understand three things before relying on it:

1. **Transforms are collection actions.** They run against third-party
   services, they are attributable, and they tell that service what you are
   investigating. Not passive in the sense your scope statement probably means.
2. **The transform's data source has its own accuracy and coverage.** Maltego
   renders results identically regardless of whether they came from an
   authoritative registry or a scraped aggregator. Record which transform
   produced each edge, and grade the underlying source, not Maltego.
3. **Free tiers are limited** in transform availability and in results returned
   per run, so a graph built on a free tier is truncated in ways that are not
   displayed. Never infer absence from an unpopulated Maltego graph.

Export before you conclude. Getting the data out and grading it by hand is where
the analysis actually happens.

## Interchange formats

| Format | Use |
|---|---|
| CSV | Working files. Diffable. Universal. |
| GraphML | Attribute-rich interchange between Gephi, Cytoscape, yEd. Verbose but lossless for attributes. |
| GEXF | Gephi's native format; supports dynamic (time-varying) graphs. |
| DOT | Graphviz rendering. Generate, never hand-write. |
| JSON | Whatever your scripts and web renderers want. |

Keep CSV as the master and treat every other format as a derived artefact, the
same way you treat a rendered figure. When a tool cannot round-trip your
attributes — and most cannot round-trip `grade`, `confidence`, and `method` —
the tool is a viewer, not a store.

## Choosing

- Under ~200 nodes, one analyst: CSV plus Graphviz, and stop there.
- You keep asking "how are these two connected": Neo4j.
- You need to *show* the structure to someone: Gephi for the analysis, then a
  generated figure for the report.
- You are pivoting infrastructure at volume and have the licence: Maltego, with
  every transform result exported and graded.
- The case may go to court or a regulator: whatever you use, the authority is
  the CSVs plus the exhibit register in `write-the-intel-brief`. A graph
  application's internal file is not an evidence store.
