---
name: chronolocation
description: Determine where and when a photo or video was captured from visual clues alone. Use when geolocating an image without GPS, verifying a claimed location, estimating time of day or date from shadows, or matching scenery to satellite and street imagery.
---

# Chronolocation

Establish **place** (geolocation) and **time** (chronolocation) from the pixels
when there's no metadata. This is core GEOINT tradecraft.

## Geolocate — read the frame

Inventory every clue and search on it:

- **Text** — signs, ads, license-plate formats, phone numbers, business names.
  Translate; a business name + region is often an instant pin.
- **Built environment** — architecture, road markings, curb/utility-pole styles,
  bollards, traffic-light design, guardrails — these vary by country/region.
- **Natural** — vegetation, terrain, mountains on the horizon (match skyline
  profiles), coastlines.
- **Infrastructure** — power lines, antennas, bridges, rail.

Match candidates against **satellite/aerial** (Google Earth, Bing, Yandex,
Sentinel Hub) and **street-level** (Google Street View, Yandex Panoramas,
Mapillary, KartaView). Yandex often wins outside North America.

## Chronolocate — pin the time

- **Shadows** — direction gives compass bearing of the sun; length + known
  location gives time of day and rough date (use SunCalc or Suncalc.org).
- **Season** — foliage, snow, crops, daylight length.
- **Events** — construction stages, banners, weather; cross-check against dated
  satellite imagery and weather archives (e.g., historical METAR).

## Method

1. List clues, ranked by how location-specific each is.
2. Narrow to a region from the strongest clues.
3. Find the exact site in satellite/street imagery.
4. **Confirm** by matching a second independent feature (building shape + sign +
   terrain all aligning). One match is a guess; three is a location.

Feed confirmed coordinates and confidence to `geoint-photo` / `osint-report`.
