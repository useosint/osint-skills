---
name: crypto-blockchain-tracing
description: Trace cryptocurrency addresses and transactions on public blockchains. Use when following a Bitcoin or Ethereum wallet, investigating crypto payments, clustering addresses, identifying exchanges or mixers, or attributing on-chain activity.
---

# Crypto & Blockchain Tracing

Public blockchains are permanent, transparent ledgers. Every transaction is
visible; the challenge is attribution — linking an address to a real entity.

## Explore

- **Block explorers** — Blockchair (multi-chain), Etherscan (ETH + tokens),
  Blockstream/mempool.space (BTC). Show balances, full transaction history,
  counterparties, and timestamps.
- **Analytics** — Arkham, Breadcrumbs, and OXT map flows visually and label
  known entities; Chainalysis/TRM are the professional-grade tools.

## Technique

- **Follow the flow** — trace inputs/outputs across hops. Note the direction,
  amount, and time of each transfer.
- **Cluster** — heuristics (common-input ownership on BTC; address reuse) group
  addresses likely controlled by one entity.
- **Identify service addresses** — deposits to labeled **exchange** addresses
  are a key attribution point: the exchange knows the KYC identity (accessible
  only via lawful process). **Mixers/tumblers** (and privacy coins like Monero)
  break the trail — flag where it goes dark.
- **Timing & amounts** — round numbers, regular intervals, and timezone of
  activity are behavioral signals.

## Attribution pivots

- Addresses posted publicly (donation pages, forums, ENS names) tie to
  identities → `person-osint` / `username-osint`.
- ENS/`.eth` names, NFT profiles, and tip jars link wallets to social accounts.
- Reused addresses across sites are strong cross-links.

## Caveat

On-chain data is fact; attribution is inference. State confidence explicitly and
corroborate before naming an owner.
