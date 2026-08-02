# High-value tag catalogue by file type

Tags are grouped by what they answer, not by where they sit in the format. Group
prefixes shown as exiftool reports them with `-G1`. Not every tag exists in every
file; treat this as a checklist to run against a dump.

## Images — location

| Tag | Reads as | Investigative value |
|---|---|---|
| `GPSLatitude` / `GPSLongitude` + `GPSLatitudeRef` / `GPSLongitudeRef` | Degrees, with hemisphere in the Ref | The position. Use `-n` for signed decimals. Without the Ref tags you can land in the wrong hemisphere. |
| `GPSPosition` `[Composite]` | Lat/long combined | exiftool's convenience value, not a stored tag. Fine to use, wrong to cite as device-written. |
| `GPSAltitude` + `GPSAltitudeRef` | Metres, Ref says above/below sea level | Distinguishes a rooftop, a valley floor, an aircraft. Cross-check against terrain elevation for the coordinates. |
| `GPSHPositioningError` | Metres | The device's own accuracy estimate. Use it as the confidence radius instead of inventing one. |
| `GPSImgDirection` + `GPSImgDirectionRef` | Degrees; Ref says true or magnetic north | Which way the camera faced. Lets you reproduce the exact view in street-level imagery, and validates the coordinates — if the bearing points at a wall, the position is wrong. |
| `GPSDestBearing` + `GPSDestBearingRef` | Degrees | Bearing to the subject. Some phones write this alongside `GPSImgDirection`. |
| `GPSSpeed` + `GPSSpeedRef` | Speed and unit | Photo taken from a moving vehicle. Combined with `GPSTrack`, gives a direction of travel. |
| `GPSDateStamp` / `GPSTimeStamp` / `GPSDateTime` | UTC | The only timezone-anchored clock in the file. Anchor every other timestamp to this. |
| `GPSProcessingMethod` | e.g. GPS, network-derived | Network-derived positions can be off by a great deal more than satellite fixes. |

## Images — device identity

| Tag | Investigative value |
|---|---|
| `Make`, `Model` | Device type. Narrows a claim ("shot on a DSLR") and dates the file loosely, since a model cannot pre-date its release. |
| `SerialNumber`, `BodySerialNumber`, `InternalSerialNumber`, `CameraSerialNumber` | One physical body. The strongest link-analysis tag in any image file. Same serial across two accounts is a hard association. |
| `LensSerialNumber`, `LensModel`, `LensInfo`, `LensMake` | A second fingerprint. Body plus lens plus focal-length habits is close to unique. |
| `ShutterCount`, `ImageNumber`, `FileNumber`, `ImageCount` (vendor, in MakerNotes) | Sequence numbers. Order a device's photos even when timestamps are wrong; estimate how many frames were shot between two images. |
| `OwnerName`, `CameraOwnerName`, `Artist`, `Copyright` | User-configured. Often a real name, sometimes a studio or employer. |
| `HostComputer` | The machine that processed the file — hostnames leak usernames and org naming conventions. |
| `ImageUniqueID` | Per-image identifier some devices write. Useful for matching a derivative to an original. |
| Apple `ContentIdentifier`, `MediaGroupUUID` | Pairs a still with its Live Photo video, and pairs burst frames. If you have one half, the identifier tells you the other exists. |
| `RunTimeSincePowerUp` (Apple) | Uptime at capture. Two photos from one session share a plausible progression; a spliced set does not. |

## Images — time

| Tag | Meaning |
|---|---|
| `DateTimeOriginal` `[ExifIFD]` | Shutter fired. Local device time, no timezone. |
| `CreateDate` `[ExifIFD]` | Digital file created. Equals the above on-camera; diverges on scan, export, re-encode. |
| `ModifyDate` `[IFD0]` | Last written. Later than `DateTimeOriginal` means processing occurred. |
| `OffsetTime`, `OffsetTimeOriginal`, `OffsetTimeDigitized` | The timezone offset. Present only on newer devices. Their absence is why EXIF time is ambiguous. |
| `SubSecTimeOriginal` | Fractional seconds. Distinguishes burst frames and exposes fabricated timestamps, which are almost always whole seconds. |
| `FileModifyDate`, `FileAccessDate`, `FileInodeChangeDate` `[File]` | Filesystem, not content. Changes on copy. Never evidence about the photograph. |

## Images — editing chain

| Tag | Investigative value |
|---|---|
| `Software`, `ProcessingSoftware` | What wrote the file. An editor name on a photo claimed to be straight out of camera is a contradiction. |
| `[XMP-xmp] CreatorTool` | Same, from the XMP side. The two can disagree, which is itself informative. |
| `[XMP-xmpMM] DocumentID`, `OriginalDocumentID` | Stable across a document's whole edit lineage. Two exports sharing an `OriginalDocumentID` came from one source file. |
| `[XMP-xmpMM] InstanceID` | Unique per save. Distinguishes near-identical exports. |
| `[XMP-xmpMM] DerivedFrom` | Points at the parent file, sometimes by filename you have never seen. |
| `[XMP-xmpMM] History...` | Per-action edit log some tools write: software agent, action, timestamp. |
| `ThumbnailImage`, `PreviewImage`, `JpgFromRaw`, `OtherImage` | Embedded renditions. Compare against the main image for pre-edit content and pre-crop aspect ratio. |
| `Orientation` | Rotation flag. A file that "looks" rotated but has an unrotated flag was re-saved by something that honoured the flag. |
| `MakerNotes` (whole group) | Vendor-specific and rarely reproduced by editors. MakerNotes present but internally inconsistent with EXIF is a manipulation tell; MakerNotes absent on a file claimed to be camera-original is another. |

## Images — editorial and rights (IPTC / XMP)

| Tag | Value |
|---|---|
| `[IPTC] By-line`, `By-lineTitle` | Photographer name and role. |
| `[IPTC] Credit`, `Source` | Agency and originating organisation. The provenance chain in two fields. |
| `[IPTC] Caption-Abstract`, `Headline` | The editor's own description of who and what. Compare against the caption on the post you are investigating; a mismatch is recontextualisation. |
| `[IPTC] DateCreated`, `TimeCreated`, `DigitalCreationDate` | Editorially asserted capture time. |
| `[IPTC] City`, `Sub-location`, `Province-State`, `Country-PrimaryLocationName` | A human-written location, often more specific than GPS would be. |
| `[IPTC] SpecialInstructions`, `OriginalTransmissionReference` | Embargo notes and wire transmission slugs — searchable strings that can find the original wire item. |
| `[XMP-dc] creator`, `description`, `rights` | Dublin Core equivalents; frequently populated when IPTC is not. |
| `[XMP-iptcExt] PersonInImage` | Named individuals. Direct pivot to `find-anyone`. |
| `[XMP-iptcExt] LocationCreated` structure | Structured location. Read with `-struct`. |
| `[XMP-plus] Licensor` | Rights holder contact details, sometimes an email or phone. |

## Office (DOCX / XLSX / PPTX and legacy DOC / XLS)

Via exiftool:

| Tag | Value |
|---|---|
| `Author` / `Creator` | Original author as configured in Office. |
| `LastModifiedBy` / `LastSavedBy` | Who saved it last. Different from `Author` means the file changed hands — often the more interesting name. |
| `Company`, `Manager` | Organisation fields from the install. `Company` surviving on a supposedly independent document links it to an employer. |
| `Template` | Path to the template used. Frequently a UNC path: server hostname, share, department folder. One of the best internal-infrastructure leaks in OSINT. |
| `RevisionNumber` | Save count. A "long-negotiated contract" with a revision number of 1 was written in one sitting. |
| `TotalEditTime` | Cumulative editing minutes. Minutes on a lengthy technical report means it was pasted from elsewhere. |
| `CreateDate`, `ModifyDate`, `LastPrinted` | `LastPrinted` proves a hard copy existed and dates it. |
| `AppVersion`, `Software` | Office build, sometimes narrowing to a platform and era. |
| `HyperlinkBase` | A base path or URL for relative links — another internal-path leak. |

Inside the container (`unzip`, then read the XML):

| Path | What's in it |
|---|---|
| `docProps/core.xml` | Author, last-modified-by, timestamps, revision, category, keywords. |
| `docProps/app.xml` | Application, company, manager, template, total edit time, page/word counts. |
| `docProps/custom.xml` | Custom properties — often DMS identifiers, matter numbers, classification labels. |
| `word/document.xml` | Tracked changes as `w:ins` and `w:del` elements, each with `w:author` and `w:date`. Accepted-but-not-cleaned documents can retain deleted text verbatim. |
| `word/comments.xml`, `commentsExtended.xml` | Comment text, author names, initials, timestamps. |
| `word/settings.xml` | `w:rsid` revision-save identifiers. Two documents sharing rsids share an editing lineage — the same original file, even after renaming and rewriting. |
| `word/media/`, `xl/media/`, `ppt/media/` | Embedded images with their own untouched EXIF, including GPS. Run exiftool over this whole directory. |
| `word/_rels/document.xml.rels` | Relationship targets — external links, linked images by local or network path, referenced documents. |
| `xl/externalLinks/`, `xl/calcChain.xml` | Spreadsheets linking to other workbooks by path, revealing filenames and shares you did not know about. |
| `xl/sharedStrings.xml` | Every string in the workbook, including in hidden sheets and filtered-out rows. |
| `docProps/thumbnail.*` | A rendered preview of the first page, sometimes of an earlier version. |

## PDF

| Tag | Value |
|---|---|
| `Producer` | The library or driver that generated the PDF. The strongest single tell: a document presented as a scan but produced by a word processor, or a "bank statement" produced by a browser print dialogue. |
| `Creator` | The authoring application. |
| `Author`, `Title`, `Subject`, `Keywords` | Carried over from the source document, often with the real author when the visible document is anonymous. |
| `CreationDate`, `ModDate` | Unlike EXIF, these include a timezone offset — usable directly. A `ModDate` after `CreationDate` means the file was rewritten. |
| `PDFVersion`, `Linearized`, `PageCount` | Structural context. |
| XMP block inside the PDF | Duplicates and sometimes contradicts the document info dictionary. Compare them; forgers usually edit only one. |

Structure worth enumerating beyond tags:

```bash
pdfimages -list  file.pdf      # every embedded image, dimensions, colourspace, compression
pdfimages -all   file.pdf out  # extract them, then run exiftool over the extractions
pdfdetach -list  file.pdf      # embedded file attachments
pdftotext -layout file.pdf -   # text layer; compare against what the page appears to say
qpdf --qdf --object-streams=disable file.pdf expanded.pdf
```

Two structural findings that matter. **Incremental updates**: a PDF can be
appended to rather than rewritten, leaving the previous revision's objects in the
file — so an earlier version of a redacted or altered page may still be present.
**Redaction that isn't**: black rectangles drawn over text leave the text in the
content stream, and `pdftotext` will print it.

## Video and audio

| Source | Tag / field | Value |
|---|---|---|
| `[QuickTime]` | `CreateDate`, `ModifyDate`, `TrackCreateDate`, `MediaCreateDate` | MP4/MOV timestamps. Container-level ones are nominally UTC; device-written ones frequently are not. Compare all of them. |
| `[QuickTime]` | `Make`, `Model`, `Software` | Recording device and encoder. |
| `[QuickTime]` | `GPSCoordinates` | Some phones write a single position; some write a track. Use `-ee` to pull per-sample data. |
| `[QuickTime]` | `CompressorName`, `HandlerDescription` | Encoder identity — distinguishes an original capture from a platform re-encode. |
| `ffprobe -show_format -show_streams` | encoder tag, bitrate, frame rate, rotation | A frame rate or rotation matrix inconsistent with the claimed device is a tell. Platform re-encodes normalise these. |
| `[ID3]` on audio | artist, encoder, comment | Recording apps and DAWs write identifying strings. |
