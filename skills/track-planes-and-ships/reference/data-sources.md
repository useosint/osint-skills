# Data-source catalogue: coverage and access

Grouped by what the source actually is, because that determines how it fails.
Access models change; the categories don't. Always record which source you used
and when — two aggregators disagreeing is common and is itself evidence.

## Source types and their failure signatures

- **Volunteer receiver aggregator** — coverage follows hobbyist population.
  Fails silently over water, deserts, oceans and poor countries.
- **Commercial aggregator** — volunteer network plus purchased satellite and
  authority feeds. Better coverage, and more likely to honour suppression
  requests. Historical depth behind a paywall.
- **Research network** — open data with permissive access for research, thinner
  polish, sometimes deep historical archives.
- **National registry** — authoritative for the paperwork, lagging on reality,
  varying wildly in searchability and reuse terms.
- **International or intergovernmental database** — authoritative identity and
  compliance data, often free but behind a registration wall.
- **Commercial fleet/ownership database** — the beneficial-ownership work is
  done for you, at a price, with methodology you can't inspect.
- **Spotter photo archive** — human-captured, timestamped, location-tagged
  ground truth. Underused, and the single best corroboration for a track.

## Aircraft: tracking

| Source | Access | Coverage and notes |
|---|---|---|
| ADS-B Exchange | Free web; API access is paid | Built its reputation on not filtering blocked aircraft. Ownership of tracking sites changes, and with it policy — verify current filtering behaviour rather than assuming |
| adsb.lol, airplanes.live | Free, community-run | Volunteer-fed unfiltered networks. Coverage is thinner than the commercial sites but they show things the commercial sites won't |
| Flightradar24 | Free tier; paid tiers for history and API | Widest consumer coverage, including purchased satellite ADS-B. Honours suppression programmes. History depth is the paid product |
| FlightAware | Free tier with account; paid API | Strong on North American commercial traffic and on flight status derived from authority data as well as ADS-B |
| RadarBox, Plane Finder | Free tier; paid API | Useful as third and fourth opinions when two sites disagree |
| OpenSky Network | Free for research; account required; REST API | Research-oriented network with historical archives. The right choice for bulk or reproducible analysis |
| Your own receiver | Hardware cost only | An SDR dongle and open-source decoder software gives you unfiltered local reception and, crucially, evidence you generated yourself |

Coverage reality check before you interpret any gap: ask whether *other*
aircraft were being reported in that area at that time. If nothing was, it's
coverage. Most aggregators let you view an area rather than a single aircraft,
which is how you run that check.

## Aircraft: registration and ownership

| Source | Access | Notes |
|---|---|---|
| FAA aircraft registry | Free web search; the releasable registry is also published as a downloadable dataset | Search by N-number, serial, or owner name. Owner is very often a trust or LLC. Registry also shows the mark's history and deregistrations |
| UK CAA aircraft register (G-INFO) | Free web | Registered keeper, not necessarily owner — a distinction the register itself makes |
| Transport Canada civil aircraft register | Free web | |
| National registers elsewhere | Varies; some free web search, some published datasets, some request-only | European registers are per-state, not centralised |
| Offshore registries (Isle of Man, Aruba, Bermuda, Cayman Islands, San Marino) | Varies; typically free search | Their existence is the finding as often as their contents. Corporate and trust ownership is the norm here |
| Fleet databases (planespotters.net, airfleets.net and similar) | Free web | Best route from a serial number to a full registration history across countries |

When ownership resolves to an entity, stop here and go to `who-really-owns-it`.

## Vessels: tracking

| Source | Access | Coverage and notes |
|---|---|---|
| MarineTraffic | Free tier with account; paid for history, satellite AIS and API | The default. Port calls, vessel particulars, and a large user-contributed photo archive |
| VesselFinder | Free tier; paid tiers | Second opinion; different receiver mix means different gaps |
| FleetMon, MyShipTracking | Free tier; paid | Further independent views |
| Global Fishing Watch | Free, account required | AIS plus analytic layers built for fishing-fleet work: apparent fishing effort, encounters between vessels, loitering, and AIS gap events. Its encounter and gap detection is directly useful for dark-fleet questions well beyond fishing |
| Satellite AIS providers | Commercial | Open-ocean coverage sampled on orbital revisit. Usually reached through a tracking site's paid tier rather than directly |
| Community AIS sharing networks | Free, contribute-to-access | Raw feeds if you run your own receiver |

## Vessels: identity, ownership and compliance

| Source | Access | Notes |
|---|---|---|
| Equasis | Free, registration required | The single best free source. Particulars by IMO, registered owner, ISM manager, classification society, and port state control inspection and detention history |
| IMO GISIS | Free, registration required | Intergovernmental shipping information, including ship particulars and company records |
| Paris MoU and Tokyo MoU inspection databases | Free web | Port state control inspections, deficiencies and detentions by IMO. Independent of what the owner says about the vessel |
| Flag state registries | Varies by flag; open registries are often searchable, some are not | Registration status and dates. Open registries vary enormously in transparency |
| ITU maritime databases | Registration may be required | Ship station and MMSI allocation records |
| Commercial shipping intelligence (Lloyd's List Intelligence, Clarksons, and similar) | Paid | Beneficial ownership, charter and casualty data. The paid answer to questions Equasis leaves open |
| Shipspotting archives | Free | Photographs by date and port. Prime corroboration material |

## Sanctions and designations

- **OFAC Sanctions List Search** and the equivalent UK, EU and UN lists.
  Vessels are designated by name *and* IMO number; aircraft by registration and
  by owner entity.
- **OpenSanctions** aggregates many national and international lists into one
  searchable dataset, which is faster than checking each regime individually —
  though for a compliance decision you check the authoritative list itself.
- **NGO and journalistic trackers** maintain public lists of vessels associated
  with specific evasion networks. Useful leads, not authoritative designations.

## Corroboration with imagery

A track is a claim. Imagery is an observation. Free optical and radar satellite
imagery from open Earth-observation programmes is coarse for small vessels but
routinely sufficient to confirm a large ship at a berth or an anchorage on a
given date, and synthetic-aperture radar sees through cloud and at night, which
is when interesting things happen. Commercial high-resolution tasking exists if
someone is paying.

Ground-level photography is the other half: spotter archives, port webcams
where publicly published, and social media posts from crew, dockworkers and
enthusiasts. Take any photograph you find to `geolocate-from-pixels` to fix the
place, and to `secrets-in-file-metadata` for a capture timestamp — that is what
turns a probable track into a confirmed one.
