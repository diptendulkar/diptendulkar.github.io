# Play developer page assets

The graphics for the [Google Play developer page](https://play.google.com/store/apps/dev?id=9126871327442435979),
which belong to the account rather than to any single app. They live here, next to `app-ads.txt`,
because that is the other per-developer Play asset — and because the previous header was built
inside `doc_scanner_app` and ended up advertising DocScan on a page that lists every app.

```sh
./play-assets/render.sh        # HTML → PNG → JPEG
./play-assets/verify-crop.sh   # limits, plus the crops a real visitor sees
```

Upload `developer-header-4096x2304.jpg` at
**Play Console → Developer account → Developer profile → Developer page → Header image**.

## The crop is the whole problem

Play sets `object-fit: cover` on the header and the container's aspect ratio changes with the
viewport, so the 16:9 image you upload is never what a desktop visitor sees. Measured on the live
page:

| Where | Container | What survives |
|---|---|---|
| Desktop | 2.97:1 | middle ~60% of the height |
| Mobile | 1.78:1 | the whole image |

So the design has to do two things at once: keep every word inside a centred safe band, and still
look composed across the full 16:9 frame that mobile shows. That is why the copy sits in a
centred `.safe` block spanning the middle 52%, and the background carries the top and bottom on
its own with nothing but soft washes near the crop lines.

`verify-crop.sh` writes out the desktop and mobile crops plus a deliberately harsher 3.6:1, so
this gets checked by eye against the real framing rather than assumed from the source file.

## Constraints Play enforces

- 4096 × 2304 exactly
- JPEG or 24-bit PNG, **no alpha channel**
- under 1 MB — a PNG of this gradient is about 3.5 MB, which is why the upload is JPEG

`verify-crop.sh` checks all three and exits non-zero, because these are the kind of thing that is
easy to assert and easy to get wrong.

## Why the design avoids app-specific imagery

The page lists every app and more are coming, so the header cannot belong to one of them. The
tile row stands in for a catalogue without naming anything: eight rounded tiles in the per-app
accent colours from `style.css`, plus a nineth dashed outline for whatever is built next. Adding
an app does not date the image, and no single category speaks for the rest.

If you do add an app and want its colour in the row, add a `--c9` and a `.tile:nth-child(9)` rule
and move the dashed tile along.
