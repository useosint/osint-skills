# Identifier reference: what's permanent and what isn't

The whole discipline turns on this. Pin your case to an identifier that
changes, and a sale, a reflag or a rename silently splits your subject into two
entities — or worse, merges it with somebody else's.

## Aircraft

| Identifier | Format | Assigned by | Changes when | Durability |
|---|---|---|---|---|
| ICAO 24-bit address | Six hex characters | State of registry, from a country-allocated block | Re-registration, including to a new country; temporarily, under a privacy-address scheme | **High.** The selector to build on |
| Registration ("tail number") | Country prefix plus letters/digits, e.g. `N` for the US, `G-` UK, `D-` Germany, `VP-` various British overseas territories, `M-` Isle of Man, `P4-` Aruba, `T7-` San Marino | National civil aviation authority | Sale, export, owner request; and marks are released and reissued to other airframes | **Medium.** Correct at a point in time; always date it |
| Callsign | Airline three-letter designator plus flight number, or the registration, or an operator designator | Operator, per flight | Every flight | **None.** Never a long-term selector |
| Flight number | Marketing code, two-letter airline code plus digits | Airline | Schedule changes; codeshares mean several numbers for one physical flight | **None** |
| Serial number (MSN / construction number) | Manufacturer-specific | Manufacturer at build | Never | **Highest.** Ties every past registration together, and the way to prove two registrations are the same airframe |
| Mode S "flight ID" | Up to eight characters | Crew enters it | Per flight; frequently mistyped | **None**, but typos are a fingerprint |

Key relationships:

- Hex → registration is a lookup, not a computation, for most of the world.
  Some states derive the hex algorithmically from the registration, which means
  a valid-looking hex can be converted back without any database — but don't
  assume that outside those blocks.
- Registration → serial number is the pivot that survives everything. Ask any
  registry or fleet database for the serial, then search the serial to recover
  the aircraft's full registration history across countries.
- A privacy address is temporary and alternate: the airframe still exists in
  registries under its real hex. It breaks live correlation, not historical
  research.

## Vessels

| Identifier | Format | Assigned by | Changes when | Durability |
|---|---|---|---|---|
| IMO number | `IMO` plus seven digits, last digit a check digit | IMO scheme administrator, at build | Never, for the life of the hull | **Highest.** The anchor for maritime work |
| MMSI | Nine digits; first three are the Maritime Identification Digits identifying the flag state | Flag state's radio authority | Reflagging, and reissue of the number to another vessel later | **Low.** A new MMSI against a constant IMO is a reflag event with a date |
| Vessel name | Free text | Owner, with flag-state approval | Any time; renaming is routine and is also an evasion technique | **None.** Names are not unique |
| Radio callsign | Alphanumeric, allocated within the flag state's block | Flag state | Reflagging | **Low** |
| Flag / registry | Country of registration | Owner's choice among registries that will accept the vessel | Any time; multiple reflags in short order is itself a signal | **Low**, and analytically interesting precisely because it changes |
| Hull / yard number | Shipyard-specific | Builder | Never | **High**, useful for build-history research |

Two things worth knowing about these:

- **The IMO check digit is verifiable.** Multiply the first six digits by 7, 6,
  5, 4, 3 and 2 respectively, sum the products, and the last digit of that sum
  must equal the seventh digit. A number that fails this is transcribed wrong
  or fabricated — check before you go looking for a database error.
- **MMSI first three digits give you the flag** at the time of transmission,
  which is how you spot a reflag in a historical AIS feed without any registry
  access at all. It is also why an MMSI alone can be misleading: it tells you
  where the paperwork is, not where the ship or its owners are.

## What each identifier is good for

| Question | Use |
|---|---|
| Follow this specific aircraft over time | ICAO hex, verified against serial number |
| Prove two registrations are the same airframe | Serial number |
| Find who owns it today | Current registration, in the national registry |
| Reconstruct ownership history | Serial number plus registry history for each mark |
| Follow this specific ship over time | IMO number |
| Detect a reflag | MMSI change against constant IMO |
| Detect an identity swap attempt | Name and MMSI changed, IMO unchanged — or, more suspiciously, an AIS broadcast whose name and IMO don't match any consistent record |
| Search photos and spotter archives | Registration for aircraft, name and IMO for ships |
| Check sanctions designations | IMO for vessels; registration and owner entity for aircraft |

## Failure modes specific to identifiers

- **Reissued marks.** A registration freed by an aircraft's deregistration can
  be reassigned. Any pre-reassignment reference to that mark belongs to a
  different airframe. Registries usually publish the history — read it.
- **Fabricated MMSIs.** Because AIS is unauthenticated, an MMSI in a broadcast
  is a claim. Values that don't correspond to a real allocation, or that
  duplicate another live vessel, occur both by error and by intent.
- **Name collisions.** Multiple ships legitimately share a name. Never treat a
  name match as identification; resolve to IMO first.
- **Transcription.** Hex codes get confused with other hex strings, `0`/`O` and
  `1`/`I` swap in registrations, and IMO numbers lose their check digit in
  free-text sources. Validate before you conclude an identifier is unknown to
  the databases.
- **Aggregator-derived fields.** Registration and owner as shown on a tracking
  site are looked up from a database snapshot the site maintains, not
  broadcast. They lag reality and differ between sites. The broadcast hex and
  the broadcast MMSI are the only identity fields actually coming off the air.
