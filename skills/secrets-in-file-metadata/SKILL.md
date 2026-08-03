---
name: secrets-in-file-metadata
description: >-
  Extract and interpret embedded file metadata with exiftool — EXIF GPS coordinates, camera
  make, model and serial, DateTimeOriginal and CreateDate timestamps, XMP and IPTC fields, and
  Office and PDF properties such as Author, Company, LastModifiedBy, template paths and
  revision counts. Use when reading EXIF from a photo, checking who really wrote a document,
  dating a file, fingerprinting a camera or phone, or investigating provenance in JPEG, HEIC,
  RAW, MP4, DOCX, XLSX or PDF. Applies to document-provenance disputes, insider-leak
  attribution, evidence handling, and pre-publication redaction checks. Reference at
  useosint.com/skills/secrets-in-file-metadata.

---

# Secrets in file metadata

The fastest lead in an investigation is often already inside the file: GPS to six
decimal places, a camera serial that ties four "unrelated" images to one body, a
document author who is a real employee, a template path containing a corporate
share name.

Two things beginners get wrong. Absent metadata is not suspicious — it is the
normal state of anything that passed through a social platform. And present
metadata is not proof: every tag is a **claim written by whatever software touched
the file last**, and all of it is editable with one command.

## Where to look first, given what you have

| You have | Reach for | Because |
|---|---|---|
| A photo downloaded from a social platform | Expect nothing | Delivery pipelines re-encode. Use `find-the-original-image` to reach an un-stripped upstream copy. |
| A photo from a forum, CMS, or direct file link | Full exiftool dump | These serve your bytes back. GPS survives here more often than people expect. |
| A messaging attachment | Full dump, and note how it was sent | Sent-as-photo is usually re-encoded; sent-as-file usually is not. |
| A folder from one source | `exiftool -r -csv` triage | You want the outlier, and the tags shared across files. |
| A DOCX/XLSX/PPTX | exiftool, then unzip the container | Tracked changes, comment authors, revision identifiers and embedded images with intact EXIF are not surfaced by exiftool. |
| A PDF | exiftool, then a structural parser | Producer strings, incremental revisions, embedded files and images with their own metadata. |
| A press or agency photo | IPTC and XMP blocks specifically | Newsroom workflows write caption, credit, named persons and location there, and it often survives when EXIF does not. |
| A RAW or HEIC straight off a device | Full dump including MakerNotes | The richest case: serials, shutter counts, lens data, sub-second timing. |
| A video | exiftool plus `ffprobe` | Container creation time, encoder string, per-track metadata, embedded GPS tracks. |

## exiftool, properly

```bash
exiftool -G1 -a -u -g1 file.jpg        # everything, grouped into sections — best for reading
exiftool -G -a -u -s file.jpg          # everything, one line per tag, real tag names
exiftool -time:all -G1 -a -s file.jpg  # every timestamp anywhere in the file
exiftool -gps:all -n file.jpg          # GPS as raw signed decimals, ready to paste into a map
```

Why the defaults lose evidence:

- **`-G` / `-G1`** prefixes each tag with its group (`[EXIF]`, `[XMP]`, `[IPTC]`,
  `[MakerNotes]`, `[File]`, `[Composite]`). Without it you cannot distinguish a
  tag the device wrote from a `Composite` value exiftool calculated, or an EXIF
  timestamp from a filesystem one. `-G1` gives the finer group.
- **`-a`** keeps duplicate tags instead of showing only the last. Inconsistencies
  live here: the same timestamp with two different values in two blocks means two
  programs disagreed, which means the file was edited.
- **`-u`** shows tags exiftool has no name for. Vendor blocks are often the point.
- **`-n`** disables pretty-printing — signed decimal degrees instead of
  `52 deg 22' 8.40" N`.
- **`-s`** prints tag names rather than descriptions, so you can query them again.
- **`-ee`** extracts embedded data, including GPS tracks inside video streams.

Bulk triage, then sort the CSV looking for which files carry GPS at all, a
recurring `SerialNumber`, timestamps outside the claimed window, and the one file
whose `Software` differs:

```bash
exiftool -r -csv -filename -createdate -datetimeoriginal -modifydate \
  -make -model -serialnumber -gpslatitude -gpslongitude -software DIR > triage.csv
exiftool -r -if '$gpslatitude' -p '$directory/$filename  $gpsposition' DIR
```

Full command patterns: [reference/exiftool-cookbook.md](reference/exiftool-cookbook.md).

## Reading the high-value fields

**GPS.** Position comes from `GPSLatitude`/`GPSLongitude` and their `Ref` tags,
height from `GPSAltitude` plus `GPSAltitudeRef`. The forgotten ones matter more:
`GPSImgDirection` is the compass bearing the **camera was pointed**, which places
the photographer *and* orients the view — decisive when matching street-level
imagery. `GPSDestBearing` is the bearing to the subject.
`GPSHPositioningError` is the device's own accuracy estimate in metres and is the
honest radius for your finding. `GPSDateStamp`/`GPSTimeStamp` are UTC, making them
the only trustworthy clock in the file.

**Device fingerprint.** `Make` and `Model` give a device type. `SerialNumber`,
`BodySerialNumber`, `InternalSerialNumber` or `CameraSerialNumber` identify **one
physical body** — the highest-value tag in the file for link analysis, tying images
across accounts, platforms and years to a single camera. `LensSerialNumber` does
the same for glass, and a body/lens pair is tighter still. Vendor shutter-count and
image-number tags let you order a device's output and estimate how much shooting
happened between two frames. `OwnerName`, `CameraOwnerName` and `Artist` are
user-set and frequently hold a real name.

**Timestamps.** `DateTimeOriginal` is when the shutter fired. `CreateDate` is when
this digital file was created — identical on a camera, different on a scan, export
or re-encode. `ModifyDate` is when it was last written; later than
`DateTimeOriginal` means processing. The trap: **EXIF datetimes carry no
timezone.** They are local device time unless `OffsetTime`, `OffsetTimeOriginal`
or `OffsetTimeDigitized` is present, which many devices omit. So reconcile against
the UTC `GPSDateTime` to derive the device's offset — which itself tells you what
longitude band the device was set for. Never quote `FileModifyDate` as evidence
about a photograph; it belongs to the filesystem you are looking at and changes on
copy.

**Thumbnail versus image.** Sloppy editors update the main image and leave the
embedded preview alone, so the preview can show the scene *before* the crop or
retouch.

```bash
exiftool -b -ThumbnailImage file.jpg > thumb.jpg
exiftool -b -PreviewImage   file.jpg > preview.jpg
exiftool -ee -b -JpgFromRaw file.cr2 > embedded.jpg
```

A different aspect ratio proves a crop. Different content is the whole case.

**Editing chain.** `Software`, `ProcessingSoftware`, `HostComputer` and XMP's
`CreatorTool` name what touched the file. XMP media-management tags go further:
`DocumentID`, `OriginalDocumentID`, `InstanceID` and `DerivedFrom` link an exported
derivative back to a source file you have never seen, and to sibling derivatives of
that same source.

**IPTC/XMP on press images.** `By-line`, `Credit`, `Source`, `Caption-Abstract`,
`Headline`, `DateCreated`, `City`, `Country-PrimaryLocationName`, plus XMP's
person-in-image and location-created structures. On a wire photo this is a
complete human-written answer to who, where and when — written by an editor, so
treat it as a sourced claim, not a sensor reading.

**Documents.** `Author` and `LastModifiedBy` are the two names. `Company` and
`Manager` come from the Office install. `Template` can contain a full UNC path
exposing an internal server and department. `RevisionNumber` and `TotalEditTime`
show whether a document was worked on or produced in one pass to look official.
`LastPrinted` proves a physical copy existed. Then open the container, because
per-author identities in tracked changes are not exposed by exiftool:

```bash
unzip -o report.docx -d report_x
# docProps/core.xml, docProps/app.xml  — properties
# word/document.xml                    — w:ins / w:del carry w:author and w:date
# word/comments.xml                    — comment authors and initials
# word/settings.xml                    — revision identifiers, a document-lineage fingerprint
# word/media/                          — embedded images, each with its own intact EXIF
# word/_rels/, xl/externalLinks/       — links to internal paths and other documents
```

Embedded images are the most-missed source of GPS in practice: the document was
scrubbed, the photograph pasted into page four was not.

**PDF.** `Producer` names the library or driver that wrote the file and is a strong
tell — a "scanned" document produced by a word processor was never scanned.
`Creator` names the authoring application. PDF dates, unlike EXIF, do carry a
timezone offset. PDFs support incremental updates, so earlier revisions of the
content can still be inside the file, and they can carry attachments and images
retaining their own metadata. Enumerate with `pdfimages -list` and
`pdfdetach -list`, and expand the structure with `qpdf --qdf` before reading it.

Per-format tag catalogue: [reference/tag-catalogue.md](reference/tag-catalogue.md).

## Where this goes wrong

- **Stripping happens on the way in.** The mechanism: a host that *re-encodes* to
  generate delivery renditions discards EXIF; a host that serves your original
  bytes keeps it. Large social platforms re-encode. Many forums, self-hosted
  CMSes, object-storage buckets, photo-community sites and mail attachments do
  not. CMSes are the interesting middle case — the resized image on the page is
  stripped while the original upload in the media directory is intact, so try to
  reach the original path.
- **Absence proves nothing.** Not that a file was scrubbed, not that it is fake,
  not that the uploader was careful. Write "no EXIF present", never "EXIF
  removed", unless you can show a copy that had it.
- **Presence proves only that someone wrote a value.** Corroborate location
  visually with `geolocate-from-pixels` and timing with sun position before
  relying on either.
- **The clock is probably wrong.** Camera clocks drift, stay on the wrong timezone
  after travel, and ignore DST. A bare EXIF datetime is ±hours until anchored
  against `GPSDateTime` or a dated event visible in frame.
- **Composite tags are exiftool's arithmetic, not the file's content.**
  `GPSPosition`, `ImageSize` and `LensID` are derived. Without `-G` you will quote
  a calculated value as though the device wrote it.
- **Screenshots carry the screenshotting device's metadata**, not the
  photograph's. Check whether `Model` is a phone before building a theory on it.
- **Editing before extracting is unrecoverable.** Rotating, cropping, or even
  opening in some editors rewrites tags. Hash and copy first.
- **Online metadata viewers mean uploading your evidence to a stranger.** Install
  exiftool; it is one Perl distribution and runs offline. A browser-local tool
  beats a server-side one, and neither is acceptable for material under a
  protective order, an NDA, or a live criminal matter. Assume anything uploaded is
  retained and may be indexed.

## Confidence grading

- **Confirmed** — a metadata claim corroborated by non-metadata evidence: GPS that
  matches an independent visual geolocation of the same frame; a camera serial
  appearing in files from two unconnected sources; a document author matching a
  known employee found via `find-anyone`.
- **Probable** — internally consistent metadata from a plausible device, in a file
  from a host that does not strip, with timestamps agreeing across EXIF, XMP and
  the embedded thumbnail, and no editor in the chain.
- **Unconfirmed** — a single tag with nothing to check it against. Every GPS
  coordinate you have not visually verified sits here. That is fine, if labelled.
- **Contradicted** — timestamps that disagree, a thumbnail showing a different
  scene, GPS the visual evidence rules out, or an editing tool the source denied
  using. A contradiction is a finding in its own right, often better than the
  original tag would have been.

## Worked example

Verify a PDF "site inspection report" attached to an insurance claim, allegedly
written on site on a stated date.

`exiftool -G1 -a -u -g1 report.pdf`: `Producer` is a word-processor export, not a
scanner driver. `CreationDate` and `ModDate` are eleven minutes apart, both with an
offset three hours from the site's zone. `Author` is an initial and surname.

`pdfimages -list` shows four embedded photographs. Extract them and run exiftool —
nothing. They were re-encoded on insertion. Dead end, and a common one.

The claim email also carried a DOCX. Unzip it: `docProps/app.xml` gives a
`TotalEditTime` under four minutes and a `Template` UNC path whose hostname belongs
to a third-party firm, not the insured. `word/document.xml` has tracked insertions
under a second author. `word/media/image2.jpeg` still has intact EXIF —
`DateTimeOriginal` two months before the claimed inspection, GPS present, `Model` a
phone, `GPSHPositioningError` nine metres.

Author names **probable**, to be corroborated against the firm via
`x-ray-a-company`. Photo capture date **contradicted** against the report's claimed
date. Photo location **unconfirmed**, handed to `geolocate-from-pixels` with a
nine-metre stated radius.

## Pivots

| What you got | Send to |
|---|---|
| GPS coordinates, camera bearing | `where-was-this-taken`, `geolocate-from-pixels` |
| Author, owner, artist, comment author | `find-anyone` |
| Company, template UNC path, internal share names | `x-ray-a-company`, `recon-a-domain-passively` |
| Camera or lens serial linking multiple files | `graph-the-network` |
| Software chain suggesting manipulation | `is-this-photo-real` |
| Editing username resembling a handle | `hunt-a-handle` |
| Need for an un-stripped original | `find-the-original-image`, `read-deleted-pages` |

## Legal notes

Metadata in a file you lawfully hold is yours to read. Two constraints bite.
Names, precise location and device identifiers in metadata are personal data under
GDPR and comparable regimes whatever file they sit in, so minimisation, retention
and purpose limits apply — collect the tags the objective needs, and do not keep a
full dump of a subject's photo library because it was easy. And precise historical
location data about an identifiable person is the most sensitive material in this
skill: legitimate in due diligence, fraud and authorized investigation, and the raw
material of stalking. If the only outcome of extracting a GPS tag is knowing where
a private individual sleeps, stop. See [../../ETHICS.md](../../ETHICS.md).
