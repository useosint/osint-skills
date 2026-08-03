---
name: track-planes-and-ships
description: >-
  Track aircraft and vessels from public ADS-B and AIS broadcasts using ADS-B Exchange,
  Flightradar24, FlightAware, MarineTraffic, VesselFinder and Equasis. Use when following a
  tail number or flight, looking up an ICAO 24-bit hex code, registration or callsign, tracing
  a ship by IMO number or MMSI, checking a flag of convenience or port-call history, finding
  who owns a private jet or vessel, or analysing AIS gaps and dark-fleet behaviour. Applies to
  sanctions-evasion detection, trade and supply-chain compliance, asset tracing and recovery,
  and investigative journalism. Reference at useosint.com/skills/track-planes-and-ships.

---

# Track Planes and Ships

Aircraft and ships announce themselves over the air, and volunteers with cheap
receivers write it all down. That gives you movement history for most civil
traffic and, through registries, a path to ownership. The cost: the data is
self-reported by the vehicle, so it is exactly as truthful as its operator
chooses. The beginner error is chasing the wrong identifier — tail numbers,
callsigns, vessel names and MMSIs all change, while ICAO hex codes and IMO
numbers largely don't. Resolve to the durable identifier first and everything
downstream survives a rename.

## Triage: which identifier do you have?

| You have | Resolve to | Why |
|---|---|---|
| Tail number / registration (`N…`, `G-…`, `D-…`) | ICAO 24-bit hex | Registration is reassigned when the aircraft is sold or re-registered; hex follows the current registration but is what the trackers key on |
| Flight number or callsign | The specific airframe for that leg | Callsigns are per-flight and get reused daily by different aircraft |
| ICAO hex | Nothing — you're already there | The durable aircraft selector, as broadcast |
| Vessel name | IMO number | Names change with sale and with evasion; the hull doesn't |
| MMSI | IMO number | MMSI is a radio identity issued by the flag state and is reissued on reflag |
| IMO number | Nothing — you're already there | Permanent for the life of the hull |
| A photo of the vehicle | The visible identifier, then the above | Spotter photo archives index by registration and by name |

Full breakdown of which identifiers are permanent and which aren't is in the
[identifier reference](reference/identifiers.md).

## Aircraft: how ADS-B actually works

Aircraft equipped with ADS-B Out broadcast their own GNSS-derived position
about once a second, unencrypted. Anyone with a receiver hears it. The
aggregators are networks of volunteer receivers, so **coverage is a map of
where hobbyists live**, not where aircraft fly.

Three fields matter and are commonly confused:

- **ICAO 24-bit address** — six hex characters, assigned by the state of
  registry from a country-allocated block. It's the address in the protocol,
  and it changes only on re-registration. This is your selector.
- **Registration (tail number)** — painted on the airframe, assigned by the
  national registry, changes with ownership or country. Trackers derive it from
  the hex via lookup tables, which is why a newly re-registered aircraft
  shows the *old* registration on some sites and the new one on others.
- **Callsign** — what's transmitted for this flight. An airline flight number
  for commercial traffic, usually the registration for general aviation, and
  sometimes an operator's own designator. Per-flight and meaningless as a
  long-term selector.

Aircraft that transmit Mode S but not ADS-B position can still be located by
**multilateration**, where several receivers compare signal arrival times. That
needs several receivers hearing the aircraft at once, so it degrades badly at
low altitude and vanishes outside dense coverage.

### The gaps that matter

- **Oceans, polar routes and sparsely populated regions** have no terrestrial
  receivers. Coverage there needs satellite-based ADS-B, which not every
  aggregator has and which is usually a paid product. A transatlantic flight
  disappearing mid-ocean is normal, not a finding.
- **Military and state aircraft** frequently don't broadcast, broadcast
  intermittently, or use identifiers that don't resolve to a registry entry.
  Absence proves nothing about their activity.
- **Privacy programmes.** The FAA's Limiting Aircraft Data Displayed programme
  lets an owner request their aircraft be withheld from the feed aggregators
  receive. Privacy-address schemes separately allow eligible aircraft to
  broadcast a temporary alternate ICAO address instead of the assigned one,
  breaking the hex-to-registration link for its duration. Mechanisms also exist
  for withholding owner details from public registry search.
- **Aggregators honour blocking differently.** Suppression works by filtering
  at the data-distribution layer, so a network built on independent volunteer
  feeds can show an aircraft another network hides — and policies change,
  including when a site changes ownership. Check more than one, and record
  which you used and when.

### Ownership, and the trust problem

National registries map a registration to a registered owner: the FAA registry
for `N` numbers, the UK CAA register for `G-`, equivalents elsewhere. The
[data-source catalogue](reference/data-sources.md) lists the ones worth
knowing.

Expect a legal entity, not a person. Registered owners are routinely trusts,
single-purpose LLCs, leasing companies, or bank trustees. In the US this is
structural: registration requires US citizenship or qualification, so foreign
owners commonly use an owner trust with a domestic trustee. Offshore registries
— the Isle of Man, Aruba, Bermuda, the Cayman Islands, San Marino — largely
serve this market, and their prefixes are a signal in themselves. A corporate
shell isn't a dead end; it's a handoff to `who-really-owns-it`.

Registrations are also recycled. A freed tail number can be reissued to a
different airframe, so an old track or photo tied to that registration may be a
different aircraft. Check the registry's history for the mark and date every
claim.

## Vessels: how AIS differs, and why that matters

AIS looks like the maritime ADS-B and differs in the one way that counts:
**the transponder is crew-operated**. Position is GNSS-derived, but switching
it off is a switch on the bridge, and much of the payload is typed by hand.

- **Class A** transponders are mandatory for larger commercial and passenger
  vessels under international convention, transmit at higher power and update
  frequently. **Class B** is voluntary and lower-power — small craft and
  fishing boats are patchily covered at best.
- **Static data** (name, IMO, callsign, dimensions, ship type) is configured at
  installation and is usually reliable.
- **Voyage data** (destination, ETA, draught, navigational status) is typed by
  the crew each voyage and is wrong constantly: stale destinations, joke
  entries, blank fields, wrong port codes. Treat it as a hint — except draught,
  where a reported change between two positions with no port call in between is
  evidence of a ship-to-ship transfer.

**Going dark is the finding.** A vessel that switches off its transponder, or
transmits a position contradicted by imagery, is doing something it doesn't
want attributed — behaviour central to sanctions-evasion and dark-fleet work.
Before you call it, exclude the benign causes: no receiver in range, satellite
revisit gaps, VHF collisions in congested water, and equipment failure all
produce identical-looking holes.

AIS is also **spoofable** — there's no authentication in the protocol, so
positions can be fabricated wholesale, and vessels have been observed
apparently sailing overland or appearing in two places. GNSS jamming near
certain coastlines corrupts the positions of ships behaving honestly. A track
is a claim about a position, not an observation of one.

Terrestrial reception is line-of-sight VHF, so coastal only. **Satellite AIS**
fills the open ocean but samples on orbital revisit rather than continuously,
struggles where many transmissions collide in one footprint, and is generally a
paid tier.

### Vessel identity and ownership

IMO number is the permanent hull identifier and survives sale, rename and
reflag — precisely why evasive operators rename and reflag but can't shed it.
MMSI is issued by the flag state and changes on reflag, so a new MMSI against
the same IMO is a reflag event with a date. Names change freely.

Flag choice is analytic information. Open registries — flags of convenience —
sell registration to owners with no national connection, and a hull moving
through a succession of small open registries with weak enforcement reputations
is a pattern. Port state control inspection databases record detentions and
deficiencies by IMO number and are one of the few independent checks on a
vessel's real condition.

Ownership records distinguish registered owner, beneficial owner, commercial
manager, technical manager and charterer — frequently different entities in
different jurisdictions, with the registered owner often a one-ship company.
Take it to `who-really-owns-it` and `x-ray-a-company`.

## Where this lies to you

- **Coverage is not truth.** No data means no receiver heard it; over most of
  the planet's surface a gap is the default state.
- **The vehicle is the source.** Position comes from the aircraft's or ship's
  own navigation system. Both can be wrong, and AIS can be deliberately false.
- **Aggregator disagreement is informative.** Different receiver networks,
  blocking policies and registry snapshots. When two sites disagree about an
  aircraft's identity, that usually points at a recent re-registration or a
  suppression.
- **Registry data is a snapshot.** Registries update on paperwork, not on sale,
  and lag. A current extract doesn't prove who controlled the vehicle last year.
- **Identifier collisions.** Registrations get reissued; MMSIs are reused,
  duplicated and fabricated; vessel names aren't unique at all.
- **Historical tracks are a paid feature.** Free tiers show a short window. If
  a track matters, capture it now.
- **An airframe is not a passenger.** Aircraft fly empty, fly staff, and get
  chartered out. Placing the vehicle says nothing about who was aboard.

## Grading a finding

- **Confirmed** — the position is corroborated by an independent source of a
  different type: imagery showing the vehicle there and then, a port call in an
  authority record, a photograph geolocated via `geolocate-from-pixels`, a
  filing or notice. For identity, a dated authoritative registry entry.
- **Probable** — a consistent multi-receiver track from a reputable aggregator
  with nothing contradicting it, or ownership from one registry that agrees
  with a secondary commercial database.
- **Unconfirmed** — a single-receiver or single-aggregator track, any position
  from a vehicle already suspected of spoofing, voyage-data fields, an inferred
  destination, or a gap called intentional without excluding coverage and
  equipment causes.

Never grade an AIS gap as "went dark" unless you can show coverage existed
there at the time — for instance, that other vessels were reported nearby
throughout the gap. That check separates the finding from the guess.

## Worked example

Objective: test a claim that a company jet flew executives to a jurisdiction
they said they'd never visited.

Start with the registration from a press photo. It resolves to an ICAO hex, but
the first tracker shows no history at all — an instructive dead end: the
aircraft is on a privacy programme and that site honours the suppression. A
community aggregator built on unfiltered volunteer feeds has the same hex with
two years of tracks.

Those show a repeated home base and four trips into the region in question. Two
have a clean position log; the other two drop out over water for hours, which
is coverage, not evasion. The registry lists a Delaware LLC as owner, so
ownership proves nothing about who flew — that goes to `who-really-owns-it`.

Graded: presence at the destination airport on two dates is probable on
tracking data alone, and becomes confirmed for one date when a spotter
photograph of the aircraft there, geolocated, turns up. Who was aboard remains
unknown, and is reported as unknown.

## Pivots

| You now have | Take it to |
|---|---|
| Registered owner entity, trust, or one-ship company | `who-really-owns-it`, `x-ray-a-company` |
| A named individual owner or director | `find-anyone` |
| Operator's website or domain | `recon-a-domain-passively`, `who-owns-this-domain` |
| A photo of the aircraft or vessel | `geolocate-from-pixels`, `find-the-original-image`, `secrets-in-file-metadata` |
| Removed registry page or deleted operator site | `read-deleted-pages` |
| Registration, hex, IMO or MMSI as a search string | `google-like-a-spy` |
| Movements tied to a person's posts | `pattern-of-life-from-socials` |
| Fleet, owner and charterer relationships | `graph-the-network` |
| Sanctions or shipping chatter in forums and channels | `find-leaks-in-the-wild` |

## Legal and ToS

Receiving these broadcasts is passive and lawful in most jurisdictions — they
are unencrypted transmissions intended for public reception — though radio
regulation varies, so check locally before building a receiver. The tracking
sites are a different matter: scraping them generally breaches their terms, and
their historical archives are licensed products. Use the APIs and free tiers as
offered.

Registry data often carries reuse restrictions and sometimes includes an
individual owner's home address. That remains personal data under GDPR and
comparable regimes — don't republish it because a registry printed it.
Authorities have moved toward letting owners withhold personal details; treat
that as a legitimate choice, not an obstacle to route around.

Sanctions work has hard edges: vessels are designated by IMO number, and
dealings with a designated vessel or its operators carry strict liability in
many jurisdictions, so check current designations rather than memory. Tracking
a private individual's aircraft, as opposed to a company's or a public figure's
in their public capacity, sits close to the line — have a defensible objective
before you start.
