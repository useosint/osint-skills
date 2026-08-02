---
name: link-analysis-graphing
description: Organize investigation findings into an entity-relationship graph to reveal connections. Use when mapping links between people, accounts, and infrastructure, building a Maltego-style graph, visualizing selectors and pivots, or untangling a complex network.
---

# Link Analysis & Graphing

Once selectors multiply, a graph makes hidden connections obvious. Model the
investigation as **entities** (nodes) and **relationships** (edges).

## Model

- **Nodes** — each selector/entity: person, username, email, phone, domain, IP,
  wallet, company, address, device.
- **Edges** — the relationship and its evidence: `owns`, `registered`,
  `posted-from`, `employed-by`, `same-photo-as`, `transacted-with`. Label edges
  with source and confidence.

## Tools

- **Maltego** — the standard; transforms auto-pivot from a node (e.g., domain →
  subdomains → IPs → certs). Community edition for light use.
- **Graph DBs / viz** — Neo4j, Gephi, or Obsidian's graph for a manual approach.
- **Spreadsheet fallback** — an entity table + a relationship table (source,
  target, type, evidence) is enough for most cases and exports to any tool.

## Method

1. Log every selector as a node the moment you find it, with its source.
2. Draw an edge for each confirmed relationship; keep unconfirmed ones dashed.
3. Look for **high-degree nodes** (a reused email or photo linking many
   accounts) — these are the strongest attribution pivots.
4. Look for **bridges** connecting otherwise separate clusters — often the key
   finding (the link between two personas).
5. Let gaps in the graph drive the next pivot.

## Payoff

The graph both guides the investigation and becomes the **entity map** in
`osint-report`. Keep confidence on every edge so the picture stays honest.
