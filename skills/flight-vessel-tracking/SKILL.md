---
name: flight-vessel-tracking
description: Track aircraft and ships from public ADS-B and AIS feeds. Use when tracking a flight or tail number, following a vessel or IMO/MMSI, investigating aircraft or ship ownership, or analyzing movement patterns of a plane or boat.
---

# Flight & Vessel Tracking

Aircraft broadcast ADS-B and ships broadcast AIS — public signals aggregated by
free trackers. Great for movement patterns and ownership.

## Aircraft

- **Trackers** — ADS-B Exchange (unfiltered, doesn't hide private jets),
  Flightradar24, FlightAware.
- **Selectors** — registration/tail number (`N…`, `G-…`), ICAO 24-bit hex,
  callsign, flight number.
- **Ownership** — national registries (FAA N-Number Registry, and equivalents)
  map a tail number to a registered owner or holding company →
  `corporate-registries`.
- **Patterns** — historical tracks reveal home base, frequent routes, and
  correlations (who flies where, when). Blocked registrations still often show
  on ADS-B Exchange by hex.

## Vessels

- **Trackers** — MarineTraffic, VesselFinder, and community AIS aggregators.
- **Selectors** — vessel name, IMO number (permanent hull ID), MMSI (radio ID),
  callsign.
- **Ownership** — IMO/registry databases, Equasis, and flag-state registers give
  registered owner, operator, and flag → `company-osint`.
- **Patterns** — port calls, loitering, and AIS gaps (a ship going dark) are
  investigative signals for sanctions and smuggling work.

## Method

1. Resolve any selector to the permanent ID (ICAO hex / IMO).
2. Pull current position and historical track.
3. Map the registered owner via the appropriate registry.
4. Analyze the pattern of movement against the objective; note data gaps.
