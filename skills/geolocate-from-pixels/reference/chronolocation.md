# Chronolocation method sheet

Chronolocation answers *when*. It almost always requires that you already know
*where*, because the sun's position is a function of location as well as time. So
geolocate first, then come back here. The rare exception runs the other way: if
you know the date and time from an independent source, sun geometry constrains
latitude.

What this method actually produces, honestly: **time of day to within tens of
minutes, and date to within a band of days to weeks — two bands, not one.** Anyone
claiming a single calendar date from shadows alone has either used another clue or
is overstating.

## Step 1 — Establish hemisphere and rough time from shadow behaviour

Before any arithmetic:

- In the northern hemisphere, north of the Tropic of Cancer, the sun is always in
  the southern half of the sky. Shadows at local solar noon point **true north**,
  and over the course of a day shadows sweep **clockwise**. South of the Tropic of
  Capricorn, both reverse: noon shadows point true south and sweep
  anticlockwise.
- Between the tropics the sun passes overhead twice a year, so noon shadows can
  point either way depending on the date. Do not assume hemisphere from shadow
  direction in the tropics.
- Short shadows mean high sun: near midday, and/or low latitude, and/or summer.
  Long shadows mean the opposite. A shadow much longer than its object means the
  sun is below 45° — early, late, high latitude, or winter.
- If you have video or a sequence of stills, the *direction of rotation* of the
  shadows is the cheapest hemisphere determination available, and it is unambiguous.

## Step 2 — Measure the shadow azimuth

You need the compass bearing the shadow points along.

1. Locate the scene first, then open the satellite view of that exact spot with
   north up.
2. Identify a ground line visible in both the photograph and the satellite image —
   a kerb, a wall, a fence, a road centreline, a building edge. Read that line's
   true bearing off the map.
3. Measure the angle between that reference line and the shadow *in the
   photograph*, correcting for the oblique view. Working on a plan-view sketch is
   more reliable than eyeballing the photo.
4. Shadow bearing plus reference bearing gives the shadow's true azimuth.

Then: **the sun's azimuth is the shadow's azimuth plus 180°** (mod 360). A shadow
falling toward 040° means the sun bore 220°.

Sanity checks that catch real mistakes: all shadows cast by vertical objects on
level ground in one photograph must be **parallel**, because the sun is effectively
at infinity. Converging shadows mean either the ground is not level, the objects are
not vertical, or the scene is lit artificially or composited — hand that to
`is-this-photo-real`. And shadows on a slope are lengthened or shortened by the
slope; only measure length on ground you can confirm is flat.

## Step 3 — Measure the solar elevation angle

For a vertical object of height `h` casting a shadow of length `L` on level ground:

```
solar elevation = arctan(h / L)
```

So an object whose shadow is exactly as long as it is tall sits under a 45° sun; a
shadow twice the height means about 27°; half the height means about 63°.

Getting `h` and `L` from a photograph is where the error comes from:

- Best case: object and shadow both roughly perpendicular to the camera axis, on
  visibly flat ground, with the whole shadow visible. Measure in pixels and take
  the ratio.
- Use an object whose height you can establish rather than assume. A standing adult
  is roughly 1.7 m but posture and footwear cost you several centimetres. A
  standard interior door is about 2 m. A shipping container is 2.59 m tall in
  standard height, 2.90 m high-cube. Traffic-sign and signal mounting heights are
  specified in national standards — look up the standard for the country you
  identified rather than guessing.
- Better than any assumed height: measure the same object's shadow in reference
  imagery you can date, or use two objects and check they give the same elevation.
- If the shadow runs away from or toward the camera, the foreshortening will make
  your `L` badly wrong. Find a different object.

Propagate the error honestly. A 20% error in `L` around a 45° sun moves your
elevation by roughly eight degrees, which is a lot of calendar.

## Step 4 — Solve for time and date

With coordinates, an azimuth and an elevation, use a solar position calculator —
SunCalc (suncalc.org) for a fast interactive read with a shadow-direction overlay,
or the NOAA Solar Calculator for a numerical answer. Set the location, then sweep
date and time until both the computed azimuth and the computed elevation match your
measurements.

Two constraints, two unknowns (time of day, day of year), so the geometry is
solvable — with a catch.

**The two-solutions-per-year problem.** Solar position depends on the sun's
declination, which sweeps from about −23.44° to +23.44° and back every year. Every
declination value except the two solstice extremes occurs **twice**: once while the
sun is moving north and once while it is moving south, symmetric about the
solstice. So your solution is always a *pair* of date bands — for example a band in
late April and a matching band in mid-August. Both fit the shadows perfectly.

An approximation good enough for a first pass, with `N` as day of year:

```
declination ≈ -23.44° × cos( 360/365 × (N + 10) )
```

And at local solar noon:

```
noon elevation = 90° - | latitude - declination |
```

which is the form to use if you have the date and want latitude instead.

**Date resolution is wildly uneven across the year, and this matters more than
people realise.** Near the equinoxes declination changes by roughly 0.4° per day,
so a shadow measurement good to a degree gives you a date to within a few days.
Near the solstices declination barely moves for weeks, so the same measurement
gives you a month or worse. Say which regime you are in when you report.

**Converting solar time to clock time.** The calculators handle this, but know what
they are doing, because it is where a "two hour discrepancy" usually comes from:

- Local solar noon differs from clock noon by four minutes per degree of longitude
  away from the timezone's central meridian, which in wide timezones is over an
  hour.
- The equation of time adds a seasonal offset of up to roughly a quarter of an hour
  either way.
- Daylight saving, where observed, shifts an hour — and whether it was in force on
  a given date is itself a date clue.
- Some countries run a single timezone across a huge longitude span, so solar and
  clock time diverge dramatically. If your case is in one of them, work in solar
  time and convert only at the end.

## Step 5 — Break the two-date ambiguity

This is the step that produces a usable answer. The sun cannot do it; the rest of
the frame can.

- **Deciduous foliage state.** Bare, budding, full leaf, autumn colour, leaf fall.
  A late-April and a mid-August solution look completely different on a birch. This
  is the single most effective discriminator in temperate latitudes.
- **Snow, and *where* the snow is.** Fresh even cover versus patches surviving only
  in shade versus dirty compacted ridges at road edges distinguishes early winter,
  late winter and a thaw.
- **Crop stage.** Bare soil, green shoots, full height, harvested stubble, ploughed.
  Combined with a known crop and region this is tight.
- **Water level** in rivers and reservoirs, and the visible tide line on a coast.
- **Human seasonal markers.** Clothing, heating, awnings and outdoor seating,
  Christmas or Ramadan or national-holiday decoration, school in or out of session,
  seasonal retail displays, sports fixtures in season.
- **Dated objects in frame.** A newspaper, a poster with an event date, a
  television chyron, a wall calendar, a clock, a receipt, an expiry date. These
  outrank everything else here, so look for them first.
- **Vehicle registration series and model years.** A plate from a series introduced
  in a known year makes the photo no earlier than that year. So does the newest
  vehicle model visible.
- **Construction state.** Cross-reference against dated historical imagery: if a
  building in the frame is half-built, the imagery timeline brackets the date
  directly, and often more tightly than the sun ever will.

## Step 6 — Corroborate with weather

Weather turns a date band into a date. Get the archive for the nearest reporting
station and compare against what the image shows: cloud cover, precipitation,
standing water, wet or dry road surface, wind direction from flags and smoke,
visibility, whether the ground is frozen.

Sources: Ogimet serves historical METAR and SYNOP observations by station; the
Iowa Environmental Mesonet hosts a large downloadable ASOS/METAR archive; NOAA's
NCEI holds the Integrated Surface Database; Meteostat aggregates station data with
an API; rp5.ru is the practical archive for Russian and post-Soviet stations. For
locations with no nearby station, the ERA5 reanalysis distributed through the
Copernicus Climate Data Store gives modelled hourly conditions on a grid.

Use it as elimination. If your date band contains one clear morning and four wet
ones, and the image shows dry pavement and hard shadows, you have your day. State
the station used and its distance from the scene; a station 60 km away across a
mountain range is not evidence about your street.

## Step 7 — Night imagery

- **Moon phase, and the orientation of the terminator**, give a date band
  independently of the sun. Illuminated fraction narrows the phase; which side is
  lit plus the moon's altitude and azimuth narrows the time. SunCalc's companion
  moon functions and planetarium software both compute this.
- **Star field.** With enough visible stars, planetarium software such as
  Stellarium can be run backwards: set the candidate location and sweep time until
  the pattern, altitudes and azimuths match. This is genuinely decisive when the
  sky is clear and the exposure is long enough, and useless in a city.
- **Artificial-light flicker in video.** Rolling brightness bands from a mains-lit
  scene reflect mains frequency, which is 50 Hz across most of the world and 60 Hz
  in North America, much of Central America and the Caribbean, Taiwan, Korea, Saudi
  Arabia, the Philippines and parts of Brazil and Japan — Japan being split, 50 Hz
  in the east and 60 Hz in the west. That is a *location* clue extracted from a
  temporal artifact. Matching the fine frequency drift against grid records to fix
  an absolute time is a real forensic technique, but the reference recordings are
  not publicly available for most grids, so treat it as out of reach unless you have
  that data.

## Step 8 — Dating a scene rather than a photograph

Sometimes the question is "when did this change happen", not "when was this taken".
Different tooling:

- Google Earth's desktop historical imagery timeline and the Esri World Imagery
  Wayback archive both give you versioned, dated basemaps. Step through them to
  bracket construction, demolition, earthworks or damage.
- Sentinel-2 time series in a Copernicus or Sentinel Hub browser gives a
  ten-metre-resolution optical revisit every few days — coarse for buildings,
  excellent for fire scars, flooding, new roads, reservoir levels and vegetation
  change. Landsat extends the same approach back decades at thirty metres.
- Vegetation indices computed over that time series date leaf-on and leaf-off
  transitions for the specific field or woodland in your frame, which is a much
  better seasonal reference than general regional knowledge.
- NASA FIRMS thermal-anomaly detections carry timestamps and will date a fire,
  flare or large explosion to within hours.
- Street-level imagery capture dates bracket changes at street scale, and the
  Street View time machine gives you several dated passes of the same spot.
- Aircraft or vessels visible in frame can be identified and their historical track
  looked up — see `track-planes-and-ships` — which is an absolute timestamp if you
  can pin the object.

## Reporting

State separately, each with its own grade:

- **Time of day**, as a range in local clock time, and say whether you converted
  from solar time and what offset you applied.
- **Date**, as one or two bands, naming which discriminator you used to drop the
  second band — and if you could not drop it, report both.
- **What you assumed.** Object height, ground flatness, which reference bearing,
  which weather station and how far away. Every one of these is a place a reviewer
  can challenge you, and pre-empting it is what makes the finding hold.

Grade **confirmed** only when sun geometry, an independent seasonal indicator and a
dated external record (weather, imagery timeline, or an object in frame) all agree.
Two of the three is **probable**. Sun geometry alone, with the two-band ambiguity
unresolved, is **unconfirmed** — and still worth reporting, because it excludes
most of the year.
