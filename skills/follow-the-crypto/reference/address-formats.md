# Address-format identification

Given a bare string, work out which chain it belongs to and what kind of thing
it is. Get this wrong and you will search the wrong explorer, conclude the
address "doesn't exist," and drop a live lead.

## Read the string in this order

1. **Does it start with `0x` and contain exactly 40 hex characters after it?**
   Ethereum-style account address. Ambiguous across every EVM chain — check all
   of them.
2. **Is it 64 hex characters (with or without `0x`)?** That's a hash, not an
   address: a transaction ID, a block hash, or a private key. Treat an
   unexpected 64-hex string as potentially a key and handle it accordingly.
3. **Does it have a human-readable prefix followed by `1`?** Bech32 or bech32m.
   The prefix names the network (`bc`, `tb`, `ltc`, `cosmos`, and so on).
4. **Is it Base58 with no `0`, `O`, `I` or `l`?** A legacy-style address; the
   leading character encodes the version byte and therefore the network and
   script type.
5. **Does it end in a naming-service suffix?** `.eth` and similar are names,
   not addresses. Resolve them and treat the resolution as a claim to verify.

## Bitcoin

| Prefix | Encoding | Type | Notes |
|---|---|---|---|
| `1` | Base58Check | P2PKH (legacy) | Oldest format. Long-lived reused addresses are common here. |
| `3` | Base58Check | P2SH | Multisig, and also wrapped SegWit — you cannot tell which from the address alone, only from a spend. |
| `bc1q` | Bech32 | P2WPKH / P2WSH | Native SegWit. Always lowercase in canonical form; mixed case is invalid, not a checksum. |
| `bc1p` | Bech32m | P2TR (Taproot) | Key-path spends look identical regardless of the underlying policy, which reduces what a spend reveals. |
| `m`, `n`, `2`, `tb1` | — | Testnet | If you're seeing these in a real case, someone pasted the wrong thing. |

Bitcoin addresses carry a checksum, so a transcription error almost always
produces an invalid address rather than a valid wrong one. An address that
validates but has no history is far more likely to be freshly generated than
mistyped.

## Ethereum and EVM chains

- 20-byte account, rendered as `0x` plus 40 hex characters.
- **EIP-55 checksum**: mixed upper/lower case in the hex encodes a checksum
  derived from the hash of the lowercase address. An all-lowercase address is
  valid but unchecked; a mixed-case address that fails the checksum is a
  corrupted or fabricated string.
- **The same address exists on every EVM chain.** One key pair controls it
  everywhere. Mainnet, layer-2 rollups, and EVM-compatible sidechains all
  accept it, so always sweep the address across chains — subjects routinely
  keep tidy behaviour on the chain they expect to be watched and messy
  behaviour elsewhere.
- **Contract versus externally owned account**: if the address has bytecode, it
  is a contract. Explorers show this. A contract's "behaviour" is its code, and
  a verified source listing tells you what it does. Contract addresses are
  deterministic — derived from the deployer address and nonce, or from a salt
  in the case of `CREATE2` deployments — so the deployer is a pivot.
- The zero address `0x0000…0000` is a burn sink and appears constantly as the
  counterparty for token mints and burns. It is not an entity.

## Other common chains

| Chain | Shape | Notes |
|---|---|---|
| Litecoin | `L`, `M`, `ltc1` | `M` is its P2SH range; visually similar to Bitcoin, easy to misroute. |
| Bitcoin Cash | Legacy Base58, or CashAddr with a `bitcoincash:` prefix | The same underlying hash renders in two incompatible formats. |
| Dogecoin | `D` | Base58, Bitcoin-derived. |
| Tron | `T`, 34 characters Base58 | Hosts a very large volume of dollar-stablecoin transfers. |
| Solana | Base58, roughly 32–44 characters, no `0x` | Token balances live in separate token accounts derived from the wallet, so the wallet address alone understates activity. |
| Ripple / XRP | `r` | Many holdings sit at exchange addresses distinguished only by a destination tag; the address alone may identify the exchange rather than the customer. |
| Cosmos ecosystem | bech32 with a chain-name prefix (`cosmos1`, and per-chain equivalents) | The same underlying key renders with different prefixes on different chains in the ecosystem. |
| Monero | `4`, or `8` for subaddresses, ~95 characters | Public address is not traceable on-chain. See the privacy section. |
| Zcash | `t`-prefixed transparent, `z`-prefixed shielded | Transparent addresses trace like Bitcoin. Shielded do not. |

## Destination tags, memos and shared addresses

Several chains and many custodial services use one address for all customers
and separate them with a numeric tag or memo field. XRP destination tags and
memo fields on other chains work this way. Consequence: an address may
represent an entire exchange rather than one user, and the identifying detail
lives in a field most explorers display separately from the address. Always
capture the tag or memo alongside the address.

## Naming services

- Forward resolution (`name → address`) is controlled by the name's owner. A
  name can point anywhere, including at an address the owner does not control.
- Reverse resolution (`address → name`) must be set from the address itself,
  which requires the private key. A matching forward-and-reverse pair is a
  meaningfully stronger claim of control than forward alone.
- Names are transferable assets. Historical ownership matters: an
  investigation-relevant name may have changed hands since the events you care
  about. Registration and transfer are on-chain events with timestamps — read
  them.
- Names are used as social-profile handles, which makes them a direct bridge
  from a wallet to `hunt-a-handle`.

## Validation and lookalikes

- Verify the checksum before you trace anything. A Base58Check or bech32
  failure means transcription error; an EIP-55 case mismatch means the same.
- **Compare full strings.** Address-poisoning attacks generate addresses whose
  first and last few characters match a real counterparty precisely so that a
  human eyeballing a truncated display picks the wrong one. Explorer UIs
  truncate by default, which is exactly the weakness being exploited.
- Case matters differently by chain: bech32 is case-insensitive but must not be
  mixed; Base58 is case-sensitive; EVM hex is case-insensitive but the case
  carries a checksum. Never "normalise" case without knowing which rule
  applies.
- When copying from a screenshot, PDF or scanned document, expect substitution
  errors between visually similar glyphs. Base58 deliberately excludes the
  worst offenders, which is why an invalid Base58 address is usually a
  transcription failure rather than a fake.
