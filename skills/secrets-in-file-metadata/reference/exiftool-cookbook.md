# exiftool command cookbook

Every command here reads. Nothing here writes to the evidence file. Before
anything else:

```bash
sha256sum evidence.jpg | tee evidence.sha256
cp -p evidence.jpg work/evidence.jpg      # -p preserves filesystem timestamps
```

Work on the copy. exiftool is generally non-destructive when reading, but other
tools in your pipeline are not.

## Single file, read everything

```bash
exiftool -G1 -a -u -g1 file.jpg
```

The one command to memorise. `-G1` fine group prefixes, `-a` keep duplicates,
`-u` include unknown tags, `-g1` organise output into group sections. Read it top
to bottom once; the shape of which groups are present is itself evidence.

```bash
exiftool -G -a -u -s file.jpg          # flat, real tag names — best for grepping
exiftool -a -u -G1 -s -sort file.jpg   # alphabetical within groups
exiftool -json -G1 -a -u file.jpg      # machine-readable
exiftool -X file.jpg                   # XML/RDF
exiftool -htmlDump file.jpg > dump.html # byte-level structure map in a browser
```

`-htmlDump` is the deep-forensics view: it shows you every block at its file
offset, including data exiftool does not parse. Use it when you suspect something
is hiding in a segment or when a file behaves oddly.

## Targeted reads

```bash
exiftool -gps:all -n file.jpg                          # signed decimals
exiftool -c "%.6f" -GPSPosition file.jpg               # formatted lat,long
exiftool -time:all -G1 -a -s file.jpg                  # every timestamp
exiftool -make -model -serialnumber -lensserialnumber -s file.jpg
exiftool -software -processingsoftware -creatortool -hostcomputer -s file.jpg
exiftool "-*serial*" -s file.jpg                       # wildcard tag match
exiftool "-*date*" -a -G1 -s file.jpg
exiftool -makernotes:all -a -u -G1 file.jpg
exiftool -xmp:all -a -G1 -struct file.jpg              # -struct keeps nested XMP intact
exiftool -iptc:all -G1 -s file.jpg
exiftool -common file.jpg                              # short built-in summary
```

`-struct` matters for XMP: without it, nested structures such as
location-created or person-in-image get flattened and you lose which value
belonged to which field.

## Extract embedded binaries

```bash
exiftool -b -ThumbnailImage file.jpg > thumb.jpg
exiftool -b -PreviewImage   file.jpg > preview.jpg
exiftool -ee -b -JpgFromRaw file.cr2 > embedded.jpg
exiftool -b -ICC_Profile    file.jpg > profile.icc
exiftool -ee -a -u -G1 video.mp4                       # embedded/streamed metadata incl. GPS tracks
```

Then compare the extraction against the main image: dimensions, aspect ratio,
visible content. `magick identify` on both is the fastest check.

## Directory triage

```bash
exiftool -r -G -a -u -s DIR > all_meta.txt

exiftool -r -csv -filename -filesize -createdate -datetimeoriginal -modifydate \
  -offsettimeoriginal -make -model -serialnumber -lensmodel \
  -gpslatitude -gpslongitude -gpsimgdirection -software DIR > triage.csv

exiftool -r -ext jpg -ext jpeg -ext heic -ext png -ext tif DIR   # restrict by extension
exiftool -r --ext txt --ext md DIR                                # exclude extensions
```

With the CSV open in a spreadsheet, sort each column in turn. What you are looking
for: rows with GPS at all; a `SerialNumber` that repeats across files you thought
were unrelated; a `DateTimeOriginal` outside the claimed window; one row whose
`Software` differs from every other; files with no `Make` at all, which are the
downloads rather than the originals.

## Filtering with conditions

```bash
exiftool -r -if '$gpslatitude' -p '$directory/$filename  $gpsposition' DIR
exiftool -r -if '$make' -p '$filename: $make $model' DIR
exiftool -r -if '$datetimeoriginal lt "2019:01:01"' -filename -datetimeoriginal DIR
exiftool -r -if '$software =~ /Photoshop/i' -filename -software DIR
exiftool -r -if '$serialnumber eq "0123456789"' -filename -createdate DIR
exiftool -r -if 'not $datetimeoriginal' -filename DIR    # which files lack a capture time
```

`-if` takes a Perl expression against tag values, so regex, `lt`/`gt`, `and`/`or`
and `not` all work. `-p` formats the output line however you want, which makes it
easy to produce a table you can paste into notes.

## Custom output formats

```bash
exiftool -p '$filename,$gpslatitude#,$gpslongitude#,$datetimeoriginal' -r DIR
exiftool -p '$filename: $model / $lensmodel / $focallength' -q -r DIR
```

A `#` suffix on a tag name in `-p` gives the raw unformatted value, which is what
you want for coordinates you intend to paste into a mapping tool.

## Grouping and correlating a set

```bash
# Which distinct cameras produced this set?
exiftool -r -p '$make|$model|$serialnumber' -q DIR | sort | uniq -c | sort -rn

# Chronological order by capture time, ignoring filenames
exiftool -r -p '$datetimeoriginal $directory/$filename' -q -f DIR | sort

# Which software touched these files?
exiftool -r -p '$software' -q -f DIR | sort | uniq -c | sort -rn
```

The first of these is the single most useful aggregate query in this file. Counting
distinct camera bodies over a folder of images tells you immediately whether a
"collection from one witness" came from one device or seven.

## Performance on large sets

```bash
exiftool -fast2 -r -csv -common DIR > quick.csv
exiftool -api largefilesupport=1 -a -G1 hugefile.mov
exiftool -progress -r DIR
```

`-fast` stops reading after the metadata segments; `-fast2` is more aggressive
still and will skip trailing metadata some files carry. Use them for triage, then
re-run a full read on the files you care about — never grade a finding off a
`-fast2` pass.

## Character encoding

```bash
exiftool -charset utf8 -G1 -a file.jpg
exiftool -charset filename=utf8 -r DIR
exiftool -lang en -G1 file.jpg
```

Non-Latin author names, Cyrillic or CJK document properties, and Windows `XP*`
tags all mis-render under the wrong charset. If a name looks like mojibake it
probably is — try `-charset utf8` before concluding the field is corrupt.

## Validation

```bash
exiftool -validate -warning -a -G1 file.jpg
```

Reports structural problems and warnings. A camera-original file is usually clean;
a stack of warnings about malformed or duplicated directories suggests the file
has been rewritten by something that did not fully understand the format. Not
proof of manipulation, but a reason to look harder.

## Documents

```bash
exiftool -G1 -a -u -g1 report.docx
exiftool -G1 -a -u -g1 report.pdf
exiftool -r -G1 -a -u -s report_x/word/media/     # after unzipping the container
```

For Office containers, exiftool reads the property parts. Everything else needs
`unzip` and the XML — see the tag catalogue for which paths matter.

For PDFs, pair exiftool with the Poppler and QPDF tools:

```bash
pdfimages -list file.pdf
pdfimages -all  file.pdf extracted/img
pdfdetach -list file.pdf
pdftotext -layout file.pdf -
qpdf --qdf --object-streams=disable file.pdf expanded.pdf
```

## Geotag correlation

If you have a GPX track from another source and a set of untagged photos, exiftool
can tell you where each photo falls on the track. This *writes* tags, so do it on
copies only, in a separate directory, and record that you did it:

```bash
exiftool -geotag track.gpx -api GeoMaxIntSecs=120 work_copies/
```

Useful when the photos are yours or the client's and the track is authoritative.
Never do this to evidence: you will have created metadata that a later reader
cannot distinguish from original.

## Scrubbing your own files

The other direction, for when you are the one publishing:

```bash
exiftool -all= -overwrite_original outgoing.jpg
exiftool -all= -tagsfromfile @ -icc_profile -overwrite_original outgoing.jpg
```

The second keeps the colour profile so the image still renders correctly while
removing everything else. Note that `-all=` does not remove data hidden in
unparsed segments; re-encoding the image is the only reliable scrub. Relevant to
`investigate-without-getting-made` — do not publish or send files that carry your
own device fingerprint.
