# Explorer and tooling catalogue

Grouped by chain and by job. Anything requiring an account, an API key, or
payment is marked. Tools appear and disappear; the *categories* are stable, so
if a named tool is gone, find its replacement in the same category rather than
abandoning the step.

## Categories, and why you need more than one tool

- **Block explorer** — canonical chain data, one address or transaction at a
  time. Free, authoritative for facts, weak for analysis.
- **Multi-chain explorer** — one interface across many chains. Best first stop
  when you don't know which chain an address belongs to.
- **Clustering / flow analysis** — applies heuristics and draws the graph.
  Powerful, and the place where probabilistic claims sneak in as facts.
- **Query and analytics platform** — SQL or GraphQL over indexed chain data.
  The right tool for "every address that did X in this window."
- **Attribution / labelling** — entity names attached to addresses.
  Proprietary, unauditable, sometimes wrong. Always cite the labeller.
- **Abuse and sanctions reporting** — has anyone else already flagged this
  address, and is it designated?
- **Node access** — your own node or a hosted RPC endpoint. The only way to be
  certain nobody filtered what you're seeing.

## Bitcoin and UTXO chains

| Tool | Access | Good for |
|---|---|---|
| mempool.space | Free, no account; public REST API | Best default. Transaction detail, fee context, mempool state, address history. Also serves other UTXO chains and has self-hostable code. |
| Blockstream.info | Free, no account; public REST API | Solid second opinion, useful when cross-checking one explorer against another. |
| Blockchain.com explorer | Free | Long-established, widely cited; adequate for basics. |
| Blockchair | Free tier; keyed API for volume | Multi-chain, and its strength is *search across chains* plus structured filtering rather than pretty transaction pages. |
| WalletExplorer | Free | Bitcoin clustering with service labels. Coverage is historically weighted, so treat absence of a label as meaningless and presence as a dated claim. |
| OXT | Free | Bitcoin-focused clustering and flow visualisation with an explicit analytic bent. |
| GraphSense | Open source, self-hosted | Auditable clustering when you need to show your method rather than cite a vendor. Requires real infrastructure. |
| Bitcoin Core RPC on your own node | Self-hosted | Ground truth. Slow to set up, unbeatable for defensibility. |

Working notes for UTXO chains: read transactions, not addresses. The
transaction is the unit of evidence — its input set is what supports
common-input clustering, and its output structure is what a change heuristic
operates on. An explorer's address page hides that structure behind an
aggregate balance.

## Ethereum and EVM chains

| Tool | Access | Good for |
|---|---|---|
| Etherscan and its per-chain siblings | Free web; API needs a free key, rate-limited | The default. Read the Internal Txns, Token Transfers (ERC-20), NFT Transfers, Contract and Events tabs — the main list alone hides most of what happened. |
| Blockscout | Open source; hosted instances per chain | The explorer of record on many chains that lack an Etherscan-family deployment. |
| Otterscan | Open source, runs against your own archive node | Fast local tracing, no third-party rate limits or filtering. |
| Public JSON-RPC endpoints | Free tiers and paid providers | Direct `eth_getBalance`, `eth_getTransactionByHash`, `eth_getLogs` and trace calls when the UI won't give you what you need. |

Working notes for account-model chains: a single transaction can move value
through many internal calls, and token transfers are contract events rather
than native value transfers. If you only read the top-level transaction you
will miss both. Check for contract bytecode before you call an address a
wallet, and check verified source before you assert what a contract does.

## Other chains

| Chain family | Explorers |
|---|---|
| Solana | Solana Explorer, Solscan, Solana Beach. Remember token balances live in derived token accounts, not the wallet address. |
| Tron | Tronscan. High stablecoin transfer volume makes it a common laundering leg. |
| XRP Ledger | XRPSCAN, Bithomp. Capture destination tags. |
| Cosmos ecosystem | Mintscan and per-chain explorers; IBC transfers cross chains and need following on both sides. |
| Substrate / Polkadot ecosystem | Subscan. |
| Litecoin, Dogecoin, Bitcoin Cash | Blockchair covers all of them in one interface. |

## Clustering, flow and attribution

| Tool | Access | Notes |
|---|---|---|
| Breadcrumbs | Free tier; account required | Build and share flow graphs. Good for producing something a non-specialist can read. |
| Arkham | Account required | Entity labelling and flow visualisation. Labels are its product; treat them as claims. |
| MetaSleuth | Account required | Multi-chain flow tracing with an emphasis on incident investigation. |
| Nansen | Paid | Wallet labelling and behavioural cohorts, oriented to trading rather than investigation. |
| Chainalysis, TRM Labs, Elliptic, Crystal, Merkle Science, Scorechain | Enterprise, paid | The compliance-grade tools. Their attributions carry weight with banks and regulators and have also been challenged in litigation. Methods are not disclosed. Never launder a vendor label into your own voice. |

If you use any of these, record which tool produced which label and on what
date. Labels change silently.

## Query and analytics

| Tool | Access | Notes |
|---|---|---|
| Dune | Free tier; account required | SQL over decoded chain data, with a large library of community queries you can fork. Best tool for population-level questions. |
| Flipside | Free tier; account required | Similar model, different data coverage. |
| Bitquery | Free tier; keyed API | GraphQL across many chains, including cross-chain queries that are painful elsewhere. |
| The explorers' own APIs | Keys, rate limits | Fine for scripted address-by-address collection; not for aggregate analysis. |

## Abuse reports and sanctions

- **Chainabuse** — community scam and abuse reports keyed by address. A prior
  report gives you a first-seen date, a victim narrative, and sometimes related
  addresses. Absence of a report means nothing.
- **Ransomware payment trackers** — public datasets of ransom addresses by
  strain. Useful for tying a payment to a family and to other victims.
- **OFAC Sanctions List Search** — the US Treasury list includes digital
  currency addresses as explicit entries under designated persons. Check it
  before you interact with anything, and check the current list rather than
  relying on what you remember: designations are added and removed, and mixing
  services in particular have been both designated and litigated over.
- **Other sanctions regimes** — UK, EU, UN and national lists also designate
  entities that hold crypto, though address-level granularity varies. If your
  work touches sanctions compliance, check every applicable regime, not just
  the US one.

## Choosing quickly

- Unknown chain, bare address → multi-chain explorer.
- Bitcoin, need clustering → mempool.space for facts, a clustering tool for
  hypotheses, and never conflate the two.
- EVM, need everything a transaction really did → Etherscan-family tabs, then
  an archive-node trace if it's still unclear.
- "Who else did this?" → an analytics platform with SQL.
- "Has anyone seen this address before?" → abuse aggregators, plus a verbatim
  string search via `google-like-a-spy` and archives via `read-deleted-pages`.
- Anything heading toward a court or a regulator → node-derived facts,
  transaction IDs and block heights, with vendor labels attributed by name.
