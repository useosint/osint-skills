---
name: reverse-image-search
description: Find where an image appears online and its original source. Use when reverse image searching, identifying a photo, face, product, or logo, finding the earliest/original version of a picture, or verifying a profile avatar across engines.
---

# Reverse Image Search

Find earlier or matching copies of an image to establish source, date, and
context. No single engine wins — run several.

## Engine strengths

- **Yandex** — best overall, especially faces, places, and cropped/rotated
  images. Start here.
- **Google Lens** — strong for objects, products, landmarks, and text in image.
- **Bing Visual Search** — good object/product matches Google misses.
- **TinEye** — best for finding the *earliest* copy and tracking edits; sort by
  oldest.
- **PimEyes / FaceCheck** — face-specific engines (paid; consider consent and
  legality before use).

## Method

1. Submit the full image to Yandex, Lens, Bing, and TinEye.
2. **Crop** to the distinctive element (a face, a sign, a logo) and re-search —
   full-frame matches often fail while a crop succeeds.
3. Try **flipping** horizontally; mirrored reposts are common.
4. On TinEye, sort by oldest to find the **original** and its first publication
   date.
5. Follow matches to their pages for names, dates, and captions to pivot on.

## Pitfalls

- A match proves the image exists elsewhere, not that people/text in it are
  correctly labeled — verify captions independently.
- Stock photos and AI-generated images produce misleading "matches"; check with
  `media-verification`.
- Engines cache; a fresh upload may not be indexed yet.

Feed any location hits to `geoint-photo` and any named people to `person-osint`.
