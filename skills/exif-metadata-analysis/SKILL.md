---
name: exif-metadata-analysis
description: Extract and interpret embedded metadata from files. Use when analyzing EXIF/GPS data in photos, checking a document's author or software, reading camera model or timestamps, or investigating file provenance from images, PDFs, or Office docs.
---

# EXIF & Metadata Analysis

Embedded metadata can reveal GPS coordinates, timestamps, device model, author
names, and editing software — often the fastest lead in an investigation.

## Extract

`exiftool` is the tool for everything:

```bash
exiftool image.jpg                       # all tags
exiftool -gps:all -createdate image.jpg  # just location + time
exiftool -a -u -g1 file.pdf              # documents (author, producer)
exiftool -r -csv DIR > meta.csv          # whole folder to CSV
```

Online (no install): metadata2go, Jimpl, or the Pillow/`hachoir` Python libs.

## What to look for

- **GPS** — `GPSLatitude`/`GPSLongitude`; paste into a map. Feed to `geoint-photo`.
- **Timestamps** — `DateTimeOriginal` (capture) vs `ModifyDate` (last edit);
  divergence hints at editing. Note timezone offset if present.
- **Device** — `Make`/`Model` fingerprints a phone/camera; the same serial
  (`SerialNumber`) links photos to one device.
- **Software** — `Photoshop`, `GIMP`, or AI-tool tags flag manipulation.
- **Documents** — `Author`, `Creator`, `Company`, template paths, and tracked
  revisions leak real names and org info.

## Critical caveats

- **Absence proves nothing.** Social platforms and messengers strip EXIF on
  upload; a clean file is normal, not suspicious.
- **Metadata is trivially forged.** Treat every tag as a *claim* to corroborate,
  not proof. Confirm GPS against visual `chronolocation`.
