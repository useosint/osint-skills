---
name: follow-the-crypto
description: >-
  Trace cryptocurrency addresses and transactions on public blockchains using block explorers
  including Etherscan, Blockchair, mempool.space and Blockscout. Covers common-input
  clustering, ENS resolution, exchange deposit addresses, mixers, CoinJoin, Tornado-style
  pools, cross-chain bridges, and OFAC sanctions screening. Use when following a Bitcoin or
  Ethereum wallet, investigating where a ransom or scam payment went, or checking an address
  against sanctions listings. Applies to ransomware incident response, AML and sanctions
  compliance, fraud recovery and asset tracing, and financial-crime investigation. Reference
  at useosint.com/skills/follow-the-crypto.

---

# Follow the Crypto

Public chains are pseudonymous, not anonymous. Every transfer is permanently
visible to anyone; what's missing is the mapping from address to human. So the
whole game is attribution, and attribution almost always happens at an
off-ramp — the point where value converts to fiat through a service that
collected identity documents. Everything between the crime and the off-ramp is
just plumbing you have to follow.

The beginner error is treating a clustering heuristic's output as fact. "These
addresses belong to the same entity" is a probabilistic inference with known
failure modes, and commercial attribution labels are proprietary guesses you
cannot audit. Trace confidently; attribute carefully.

## Triage: what are you holding?

| You have | Start with | Why |
|---|---|---|
| An address string | Identify the chain from its shape, then a block explorer | Format alone usually determines chain and script type — see the [address-format table](reference/address-formats.md) |
| A transaction hash | Explorer's transaction view | Gives you both sides, the fee, the block time, and any contract calls |
| An ENS or naming-service name | Resolve to an address, then check the *reverse* record | Forward resolution is set by the name owner; reverse is set by the address owner and is the stronger claim |
| A `0x…` address | Check the same address on every major EVM chain | One private key, one address, many chains. Activity on a chain the subject thought nobody looked at is common |
| A payment demand from a ransom note or scam | Explorer plus scam-report aggregators | Others may already have reported it, giving you victim count and a first-seen date |
| A screenshot of a wallet | Extract the address by hand and verify the checksum | Screenshots get transcribed wrongly, and lookalike addresses are deliberately planted |

## The method

**1. Establish the chain and address type.** The string tells you. Bitcoin
legacy pay-to-public-key-hash addresses begin with `1`; pay-to-script-hash,
historically multisig and wrapped SegWit, with `3`; native SegWit bech32 with
`bc1q`; Taproot with `bc1p`. Ethereum and every EVM chain use `0x` plus 40 hex
characters, with mixed-case acting as an EIP-55 checksum. Full table in the
reference file above.

**2. Open the address in a block explorer and read it properly.** Balance is
the least interesting field. What matters: first-seen and last-seen timestamps
(activity lifespan), total received versus current balance (a swept address is
a conduit, a holding address is a destination), transaction count, and the
counterparty set. On EVM chains also read the internal transactions, the token
transfer tab, and whether the address has code — an address with bytecode is a
contract, not a person's wallet, and its behaviour is defined by that code.

**3. Choose the right mental model for the chain.** UTXO chains like Bitcoin
have no accounts: a transaction consumes discrete unspent outputs and creates
new ones, so "the balance of an address" is a derived aggregate and value
visibly splits and merges. You trace *coins* through a graph of outputs.
Account-model chains like Ethereum have balances mutated by transfers, so you
trace *account-to-account edges*, and a single transaction can trigger a cascade
of internal transfers and token movements that don't appear in the top-level
view. Confusing the two is the most common source of nonsense conclusions.

**4. Cluster, and know what each heuristic is worth.**

- **Common-input ownership** is the strong one: if a UTXO transaction spends
  several inputs, whoever built it had to hold the keys for all of them, so
  those addresses share a controller. This is the backbone of every Bitcoin
  clustering engine.
- **Change-address identification** is the weak one. The heuristics — output
  with an unrounded amount, output whose script type matches the inputs while
  the other doesn't, output to a never-before-seen address, and the
  unnecessary-input rule — are individually fallible and compound their errors
  across hops. A single wrong change call sends the whole downstream trace to a
  stranger.
- **Address reuse** collapses activity into one identity for free and is
  common among people who don't consider themselves targets.

**5. Find the off-ramp.** Exchanges assign each customer a unique deposit
address, then periodically sweep those deposits into consolidated hot wallets.
That sweep is the giveaway: many independent addresses funnelling into one
large wallet, on a schedule, is an exchange deposit structure. Reaching a
deposit address is the single most valuable outcome of a trace, because the
exchange holds KYC records for whoever it belongs to — obtainable by law
enforcement through legal process, not by you. Document the deposit address,
the amount, the timestamp, and the exchange identification basis, and hand it
over.

**6. Recognise service and contract interaction by pattern.** Equal-denomination
outputs with many participants in one transaction is CoinJoin. Fixed-denomination
deposits and later withdrawals from the same contract are a Tornado-style
shielded pool. A transfer into a contract followed by an event on a different
chain is a bridge. Repeated round-number transfers between two addresses on a
schedule looks like payroll or a subscription, not a market operation. Peel
chains — a large amount that repeatedly spends a small piece out and forwards
the remainder — are a classic laundering and cash-out pattern.

## Where the trail breaks, and what you can still say

**CoinJoin** breaks common-input ownership by design: the inputs belong to
different people. Naïve clustering that ignores this merges unrelated users
into one giant false cluster — a well-known and serious failure mode.

**Shielded mixing pools** break the deposit-withdrawal link cryptographically.
What survives are the metadata leaks: an anonymity set that's small at low
volume, deposit and withdrawal timing, a withdrawal whose gas is paid from an
address that also funded the deposit, and users who withdraw to an address
already linked to them.

**Cross-chain bridges and swap services** don't break linkage cryptographically
but do break it *practically*, because they move the trail to another chain
with different tooling. Amount-and-timing correlation across the two chains
often re-establishes it. Instant no-account swap services are the same problem
with an added custodial hop that keeps its own logs.

**Privacy coins** are a hard stop, not a slowdown. Ring signatures, stealth
addresses and confidential amounts mean there is no public sender, no public
recipient and no public amount to follow. Say so plainly rather than implying
you could have gone further. On chains with optional shielding, most activity
is transparent, and the leaks are at the shielded/transparent boundary.

**Taint analysis** after any of these is a modelling choice, not a measurement.
Poison, haircut, FIFO and last-in-first-out give materially different answers
on the same data, and courts in some jurisdictions impose their own rule for
mixed funds. Always state which model you used. "40% tainted" without a named
model is meaningless.

## Where this lies to you

- **Address poisoning.** Attackers send zero-value or dust transfers from
  addresses crafted to match the first and last characters of a legitimate
  counterparty. These appear in the victim's history and will pull a careless
  analyst onto a completely unrelated address. Compare full strings, always.
- **Dusting.** Unsolicited tiny amounts sent to many addresses, intended to be
  spent and thereby merge clusters. A received transfer proves nothing about
  the receiver's intent or relationships.
- **Explorer labels are third-party claims.** Public name tags, self-submitted
  contract verifications and community-sourced entity labels vary in quality
  and are sometimes simply wrong or stale. A label is a lead. Cite the labeller.
- **Commercial attribution is unauditable.** Chain-analytics vendors' entity
  labels derive from proprietary undisclosed methods and have been challenged
  in court. Never present a vendor label as ground truth; present it as that
  vendor's assessment.
- **Contracts move value for people who never touched it.** A DEX router, a
  multisig, a custodial wallet or an NFT marketplace shows up as a
  counterparty. It is infrastructure, not a suspect.
- **Timestamps are block times.** They approximate when the transaction was
  mined, not when the human acted, and they say nothing reliable about
  timezone.
- **Same address, different chain, different person is possible** — but the
  reverse is the practical risk: assuming the chains are unrelated when the key
  is the same.
- **Chain reorganisations and unconfirmed transactions.** Something you saw in
  the mempool may never confirm. Cite confirmed transactions with block heights.

## Grading a finding

- **Confirmed** — on-chain facts: this transaction moved this amount from this
  address to that address in this block. These are cryptographically verifiable
  and you should say so without hedging. Also confirmed: an address published
  by the entity itself in a signed message or on a domain you've verified via
  `recon-a-domain-passively`.
- **Probable** — a cluster built on common-input ownership with no CoinJoin
  pattern present; a service identified by structural behaviour that matches
  multiple independent labels; an ENS name with matching forward *and* reverse
  records tied to a social profile.
- **Unconfirmed** — anything resting on change-address heuristics, a single
  commercial label, an unsigned claim of ownership, timing correlation alone,
  or a cluster spanning a mixing event.

Attribution to a named human is never confirmed on-chain evidence alone. It
becomes confirmed when an off-chain record — a subpoena return, a court filing,
a signed message, an entity's own disclosure — closes the gap.

## Worked example

A victim reports paying an extortion demand to `bc1q…` and provides the
transaction ID.

The explorer shows one input from the victim and two outputs: 0.4137 BTC to a
fresh `bc1q` address and a smaller amount to another. Change heuristic says the
unrounded larger output is the payment and the smaller is the victim's change —
but the victim confirms the demanded amount was the *smaller* figure, so the
heuristic was backwards here. Dead end avoided only because a human corroborated
it; note that in the file.

Following the extortion output: within a day it merges with eleven other inputs
into a single transaction. Common-input ownership means all twelve are one
controller, and the equal-value structure that would indicate CoinJoin is
absent. The consolidated output forwards to an address that receives from
thousands of unrelated addresses and sweeps outward on a fixed schedule — an
exchange hot-wallet structure. The address immediately before it, which
received only from our cluster, is the deposit address.

Graded: transaction facts confirmed; the twelve-address cluster probable; the
exchange identification probable, on structure plus two independent labels; the
account holder's identity unknown and only obtainable by legal process.
Reported that way, with the deposit address and timestamps flagged for the
victim's counsel.

## Pivots

| You now have | Take it to |
|---|---|
| ENS name, handle or nickname on-chain | `hunt-a-handle` |
| Address published on a website | `recon-a-domain-passively`, `read-deleted-pages` |
| Exchange, custodian or issuer entity | `x-ray-a-company`, `who-really-owns-it` |
| A named individual | `find-anyone` |
| Address posted on a forum, paste or channel | `find-leaks-in-the-wild` |
| Address in a source repo or commit | `secrets-in-git-history` |
| Address string to search verbatim | `google-like-a-spy` |
| NFT image used as an avatar | `find-the-original-image` |
| Multi-hop flow to visualise | `graph-the-network` |
| Email or handle tied to an exchange account | `what-leaked-about-you` |

Tools and explorers by chain, with what each is actually good for, are in the
[explorer and tooling catalogue](reference/explorers-and-tools.md).

## Legal and compliance

Reading a public ledger is not regulated. Acting on it can be. Sanctions
authorities publish specific digital-currency addresses on their designated
persons lists — the US OFAC SDN list carries them as explicit address entries —
and transacting with a designated address is a strict-liability matter in many
jurisdictions. Check listings before you interact with anything, and never send
a "test transaction" to a subject address: it is interaction, it marks you, and
it may be a violation.

Naming a person as the owner of an address is a serious public accusation with
defamation exposure, and the underlying inference is probabilistic. Bulk
purchase or handling of leaked exchange customer data brings data-protection
obligations regardless of how it reached you; see `what-leaked-about-you`.
Where the objective is asset recovery or a criminal referral, preserve the
chain of custody: record block heights, transaction IDs and capture
timestamps, not screenshots of an explorer.
