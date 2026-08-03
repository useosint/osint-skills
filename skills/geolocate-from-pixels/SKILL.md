---
name: geolocate-from-pixels
description: >-
  Geolocate and chronolocate a photo or video from visual evidence alone — plate and phone
  number formats, road markings, utility poles, bollards, signage typefaces, architecture and
  vegetation for place; shadow direction and length with SunCalc for time and date. Use when
  asked where or when a picture was taken, to verify a claimed location without GPS or EXIF,
  or to match a scene against Google Earth, Street View, Yandex Panoramas, Mapillary or
  KartaView. Applies to GEOINT and conflict monitoring, insurance and claims verification,
  journalism fact-checking, and evidence review. Reference at
  useosint.com/skills/geolocate-from-pixels.

---

# Geolocate from pixels

Every photograph taken outdoors contains enough information to place it. The
constraint is never the image; it is your patience and your reference knowledge.

The beginner mistake is searching before inventorying. People see a mountain,
type "mountain with two peaks" into a search box, and get nothing. The method is
the opposite: extract every clue first, rank them by how much of the planet each
one eliminates, and only then start searching — because the clue that pins the
country is usually not the one your eye went to.

## Rank your clues before you search

Work down this list. Each row eliminates far more of the world than the one below
it, so a single row-one clue is worth twenty row-six clues.

| Tier | Clue | What it buys you |
|---|---|---|
| 1 | Readable proper nouns — business names, street names, municipal logos, school names | Often an instant pin. A business name plus a country is a map query, not an investigation. |
| 1 | Phone numbers on signage and vehicles | Country and frequently city, from prefix and digit-grouping convention. |
| 1 | Language *and script*, then orthography | Script narrows to a family; specific diacritics, letter forms and spelling conventions narrow to one country and sometimes one region. |
| 2 | Licence plate format — shape, colour, band, character layout | Country, often issuing region. Visible from a long way off, survives compression. |
| 2 | Driving side | Splits the world roughly a third to two thirds. Read it from parked-car steering wheels, not just from traffic. |
| 2 | Road markings — centre-line colour, dash rhythm, edge lines | Yellow versus white centre lines alone cuts most of the world. |
| 3 | Utility pole construction and insulator style | Regionally conservative and rarely changed. One of the most reliable tells in the frame. |
| 3 | Bollards, guardrails, kerb painting, chevron markers | Nationally standardised, nationally distinctive. |
| 3 | Traffic signal mounting, lens arrangement, backboards | Overhead versus pole-side, horizontal versus vertical, extra lenses — all national conventions. |
| 4 | Signage typeface and road-sign standard | Which sign standard a country adopted, and its specific alphabet. |
| 4 | Satellite dish elevation and azimuth | Constrains latitude, and the orbital slot indicates which service region. |
| 5 | Architecture, roofing material, window and balcony conventions, rooftop tanks and heaters | Region and climate band. |
| 5 | Vegetation and biome | Latitude band, climate, hemisphere. Careful: ornamental planting is global. |
| 6 | Terrain and horizon profile | Only useful once you have a candidate region — then it is decisive. |

Every variation and what it implies:
[reference/regional-indicators.md](reference/regional-indicators.md).

## Method

1. **Inventory.** Write a numbered list of every clue in the frame before you
   search anything. Include the negatives — no snow, no palms, no overhead wires
   — because negatives eliminate regions just as well. Zoom in on every sign,
   every vehicle, every pole. Run the preprocessing recipes in
   `find-the-original-image` to read underexposed or small detail.
2. **Fix the country.** Combine your tier-1 and tier-2 clues until they agree. If
   two contradict — Cyrillic signage with right-hand-drive cars — that
   contradiction is a finding: an imported-vehicle market, a border region, or a
   composited image.
3. **Read the text properly.** Transcribe, then translate, then search the
   transcription verbatim in the local language. Searching a translation loses
   you the match. If the script is unfamiliar, get the script identified before
   you attempt letters — Georgian, Armenian, Amharic, Khmer, Thai, Lao and
   Sinhala are all frequently misidentified as each other's neighbours by people
   guessing.
4. **Narrow to a locality.** Named businesses go into a mapping search restricted
   to the country. Chains are useful in reverse: a chain that only operates in
   three provinces eliminates the rest of the country.
5. **Query the map for the geometry, not the place.** When you have no names but
   you do have structure — a water tower next to a rail crossing next to a
   football pitch — query OpenStreetMap features directly with Overpass rather
   than panning around. This is the step most people skip and the one that most
   often works.

```
[out:json][timeout:90];
area["ISO3166-1"="RO"]->.a;
nwr["man_made"="water_tower"](area.a)->.t;
foreach.t -> .w (
  nwr(around.w:400)["leisure"="pitch"]["sport"="soccer"];
  out center;
);
```

6. **Confirm in imagery.** Match the candidate against satellite/aerial *and*
   street-level sources. Compare invariants: building footprint shape, roof
   colour, the count and spacing of windows, kerb line, tree positions, the exact
   arrangement of a fence. Do not match on things that change — parked cars,
   awnings, signage, foliage density.
7. **Chronolocate.** Sun position for time of day and date band, season from
   vegetation, weather archives for corroboration. Procedure in
   [reference/chronolocation.md](reference/chronolocation.md).
8. **Score it.** Three independent features aligning, or stop.

## Imagery sources and where each one wins

| Source | Reach for it when |
|---|---|
| Google Earth (desktop) | Default satellite work. The historical-imagery timeline is the reason to use the desktop client over the browser: it dates construction, demolition and earthworks. |
| Google Street View | Default street-level, in the countries it covers. Time-machine feature gives you dated captures of the same spot. |
| Yandex Maps and Panoramas | Russia, Belarus, Kazakhstan, Central Asia, the Caucasus, Turkey. Panorama coverage and satellite detail there routinely exceed Google's, and Yandex's imagery is sometimes from a different date, which is useful on its own. |
| Mapillary | Crowdsourced street-level. Covers roads, tracks and countries Street View cars never drove. Often the only street-level imagery for rural areas and much of Africa, South Asia and the Balkans. |
| KartaView | Second crowdsourced street-level set with different contributor geography. Check it when Mapillary is empty. |
| Bing Maps aerial and Streetside | A different capture date and sometimes a better angle. Oblique views help with building heights. |
| Apple Maps | Look Around coverage and high-quality 3D in major cities. |
| Esri World Imagery, with its Wayback archive | Versioned historical basemap imagery — a second, independent historical timeline when Google's is thin. |
| Copernicus/Sentinel browsers | Sentinel-2 optical at ten-metre resolution with a revisit measured in days. Too coarse for a building, ideal for dating a change: a fire scar, a flood, a new dirt road, a filled reservoir. |
| Landsat archive (USGS) | Thirty-metre resolution but a multi-decade record. For "when did this quarry appear". |
| NASA FIRMS | Thermal anomaly detections with timestamps. Dates fires, flares and large explosions to within hours. |
| Declassified historical imagery via USGS EarthExplorer | Pre-satellite-era-commercial coverage for very old questions. |
| National and municipal orthophoto portals | Frequently far higher resolution than any global provider, and dated. Search for the country's cadastral or survey agency viewer. |
| OpenStreetMap plus Overpass | Query by feature type rather than browsing. Also the only source for many footpaths, power lines and small structures. |
| Panorama generators from elevation models | Synthesises the horizon as seen from a given coordinate and bearing, for ridgeline matching. |

## Where this goes wrong

- **Confirmation bias is the failure mode of this discipline.** You will find a
  building that looks right and then start explaining away the differences. Set
  your falsification criteria *before* you look: "if the pole on the left is on
  the wrong side of the road, this candidate is dead." Then honour them.
- **Imagery is dated, and you are comparing across time.** A missing building may
  have been demolished; a present one may be newer than the photo. Check the
  capture date of the imagery, and check the historical timeline before you reject
  a candidate.
- **Ornamental and introduced vegetation lies constantly.** Eucalyptus grows on
  five continents. Palms are planted far outside their native range. Vegetation is
  a tier-five clue for a reason — it corroborates, it does not decide.
- **Global brands and franchised signage tell you almost nothing** except where a
  company operates. A ubiquitous fast-food logo is not a clue; the local-language
  sub-brand and phone number on the same sign are.
- **Compression invents detail.** Text you "read" at the JPEG artifact level is
  frequently not there. If a plate or a sign only becomes legible after upscaling,
  it is a hypothesis, not a reading. Go back to the original pixels.
- **Reflections and mirrors flip everything.** Text in a shop window, or a scene
  shot into a mirror, reverses. So does a mirrored repost. If the driving side and
  the text direction disagree, suspect a flip before you suspect a country.
- **Photos are not necessarily of one place.** Composites exist, and a video can
  be cut from footage of several locations. Geolocating one frame does not
  geolocate the video. Verify frames independently, and hand suspicion to
  `is-this-photo-real`.
- **Border regions and enclaves break single-clue logic.** Signage, plates,
  currency and infrastructure all mix within a few kilometres of a border, and in
  territories with disputed or transitional administration.
- **The claim shapes what you see.** If you are told the photo is from a
  particular city, you will find that city. Try to do the inventory before you
  read the caption, and when you can't, run the exercise as though the caption
  said somewhere else.
- **Long lenses compress and wide lenses stretch.** Apparent distance between a
  foreground subject and a background mountain is a function of focal length. Do
  not judge "how close the hills are" without accounting for it.

## Confidence grading

- **Confirmed location** — a specific coordinate where at least three mutually
  independent, non-transient features match reference imagery: for example
  building footprint geometry, the position and count of utility poles, and
  terrain profile. Independence is the requirement — three photos of the same sign
  is one feature, not three. You should be able to reproduce the camera position
  and bearing and state a radius in metres.
- **Probable location** — the correct locality with a plausible specific site;
  two independent features match, or three match but one reference source is
  undated or low-resolution. Express as a named place plus a radius, not a
  coordinate.
- **Region only** — country or province established from tier-one and tier-two
  clues with no site match. This is a perfectly respectable result and is often
  all a case needs. Say "somewhere in this province", not a point.
- **Unconfirmed** — a candidate that looks right but rests on transient features,
  a single matching element, or your own sense of resemblance.
- **Excluded** — you can affirmatively rule the claimed location out. Often
  easier and more valuable than finding the true one; a disproof needs only one
  hard contradiction, such as driving side.

Always report a radius with a coordinate. A bare six-decimal coordinate implies
sub-metre certainty you do not have.

## Worked example

An image is circulated as an attack on a fuel depot "in country A". No metadata.

Inventory: white centre line, right-hand traffic, concrete utility poles with a
single horizontal crossarm and stubby brown insulators, a warning sign in a Latin
script with a diacritic that does not exist in country A's language, one shop sign
partly legible, low scrubby vegetation, bare deciduous trees, snow patches in
shadowed ground only, a mountain ridge on the left horizon.

The diacritic already contradicts the claim — that is the finding that matters.
Script and orthography narrow to two neighbouring countries. The pole and
insulator style matches one of them.

The shop sign OCRs to a fragment. Searching the fragment as a business name gives
a chain with outlets in one province. Overpass query for fuel depots within that
province returns eleven candidates.

First candidate looks right in satellite view — same tank count. Killed by the
falsification test: the access road approaches from the wrong side and the ridge
would be behind the camera. Dead end, and a good one, because it was cheap.

Fourth candidate matches on tank arrangement, the perimeter fence corner, and the
ridgeline profile generated from elevation data for that viewpoint. Street-level
crowdsourced imagery from a nearby road shows the same pole line.

Chronolocation: shadow azimuth and a shadow-length ratio off the fence post give
mid-morning and a solar elevation consistent with two date bands. Snow in shade
only, plus bare deciduous trees, selects the late-winter band over the
early-autumn one. A weather archive for the nearest station shows precipitation
days earlier and clear skies that morning, consistent.

Result: location **confirmed**, 100 m radius, in country B not country A. Date
**probable** to a two-week window. Time of day **probable**, mid-morning local.

## Pivots

| What you got | Send to |
|---|---|
| Coordinates and radius | `where-was-this-taken`, `write-the-intel-brief` |
| Business name, chain, municipal body | `x-ray-a-company`, `who-really-owns-it` |
| Phone number from signage | `whose-number-is-this` |
| Company website on a sign or vehicle | `who-owns-this-domain`, `recon-a-domain-passively` |
| Named individuals visible or credited | `find-anyone` |
| Suspected composite or generated scene | `is-this-photo-real` |
| Need for earlier copies to date the scene | `find-the-original-image`, `read-deleted-pages` |
| Aircraft or vessel identifiable in frame | `track-planes-and-ships` |
| Multiple locations to relate to one another | `graph-the-network` |

## Legal and ethical notes

Reading public imagery and public map data is passive and lawful. Two limits are
real. First, geolocating a private individual's home, school or routine from their
own posted photographs is the core mechanic of stalking, and the fact that the
technique is impressive does not make the output legitimate; do it for
missing-persons work, authorized investigation, threat assessment, or to show
someone their own exposure, and not otherwise. Publish a rounded location or a
region rather than a doorstep coordinate. Second, in conflict work, publishing a
precise location can endanger the people in the frame or make them a target. Both
of these are judgement calls you must make explicitly and record. See
[../../ETHICS.md](../../ETHICS.md).
