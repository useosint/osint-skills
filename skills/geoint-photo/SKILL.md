---
name: geoint-photo
description: Geolocate and verify a photo or video — extract metadata, find the source, and identify where and when it was captured from visual evidence.
disable-model-invocation: true
---

# GEOINT — Photo & Video

Determine **where** and **when** an image was taken and whether it is authentic.
Input: a photo or video file or URL.

## Step 1 — Authorized scope

Read [../../ETHICS.md](../../ETHICS.md). Note the objective (verification,
missing person, disinformation). **Done when noted.**

## Step 2 — Metadata (fast win)

Run `exif-metadata-analysis`: EXIF may contain exact GPS coordinates, a
timestamp, and the camera/phone model. If present, you may be done — but treat
metadata as a claim to verify, since it is easily stripped or faked. **Done
when** EXIF is extracted or confirmed absent.

## Step 3 — Provenance

Run `reverse-image-search` (Google Lens, Yandex — strongest for places — Bing,
TinEye) to find earlier appearances, the original source, and the true date.
Run `media-verification` to check for manipulation and confirm it isn't a
recycled or AI-generated image. **Done when** the earliest known appearance and
authenticity are established.

## Step 4 — Chronolocation from pixels

When there's no metadata, geolocate from the image itself. Run `chronolocation`:
read signs, languages, license plates, architecture, flora, power/utility
styles, road markings, and business names; match to satellite/street imagery
(Google Earth, Yandex Maps, Mapillary); use sun position and shadows to bound
the time of day and season. **Done when** you have a candidate location, ideally
narrowed to a specific site.

## Step 5 — Confirm

Corroborate the candidate against a second source: Street View match of the same
building, a geotagged photo of the same spot, or terrain overlap. Location is
**confirmed** only when independent imagery matches. **Done when** the location
is confirmed or listed as best-estimate with confidence.

## Step 6 — Report

Run `osint-report`. Give coordinates, a confidence level, and the specific visual
clues that pin the location, with reference imagery links.
