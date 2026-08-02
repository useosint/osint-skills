---
name: media-verification
description: Verify whether an image or video is authentic, original, and correctly described. Use when fact-checking a photo or video, detecting deepfakes or AI-generated media, spotting manipulation, or confirming when and where footage first appeared.
---

# Media Verification

Confirm that a piece of media is real, original, and shows what it claims.
Standard practice for journalism and disinformation work.

## The checklist

1. **Provenance** — is this the original or a repost? Run `reverse-image-search`
   (video: search keyframes) to find the earliest copy and its true date and
   caption. Recycled old media in a new context is the most common deception.
2. **Metadata** — run `exif-metadata-analysis` for capture time, GPS, and
   editing-software traces (often stripped by platforms — absence isn't proof).
3. **Location** — does the scene match the claimed place? Verify with
   `chronolocation`.
4. **Time** — do shadows, weather, and season fit the claimed date? Cross-check
   weather archives.
5. **Internal consistency** — signage language, currency, plates, and license
   details should all agree with the claimed setting.

## Manipulation & AI

- **Edits** — error-level analysis (FotoForensics), clone/splice artifacts,
  inconsistent lighting/shadows and reflections, warped edges near pasted
  objects.
- **AI-generated** — check hands, teeth, ears, text/logos, jewelry, and
  background coherence; watch for too-smooth skin and nonsensical fine print.
  Detection tools help but are **not** reliable alone — corroborate.
- **Video/deepfake** — unnatural blinking, mismatched lip-sync, flickering face
  edges, inconsistent head/neck lighting; inspect frame by frame.

## Verdict

Report a graded conclusion — authentic / altered / misattributed / AI-generated
/ inconclusive — with the specific evidence, never a bare yes/no. When unsure,
say inconclusive; a wrong "verified" is worse than an honest gap.
