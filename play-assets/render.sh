#!/usr/bin/env bash
# Renders the Google Play *developer page* assets — the ones that belong to the account rather
# than to any single app, which is why they live in this repo alongside app-ads.txt instead of in
# an app repo. The previous header was built inside doc_scanner_app and ended up advertising
# DocScan on a page that lists every app.
#
#   ./play-assets/render.sh
#
# Verify the crop afterwards with ./play-assets/verify-crop.sh, which is the part that actually
# matters: Play covers this image and only the middle ~60% survives on desktop.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -x "$CHROME" ]]; then
  echo "Chrome not found at: $CHROME" >&2
  echo "Set CHROME=/path/to/chrome and re-run." >&2
  exit 1
fi

shoot() {
  local url="$1" width="$2" height="$3" out="$4"
  # virtual-time-budget gives the webfonts time to land; without it the wordmark renders in a
  # fallback face and the header silently stops matching the site.
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=1 \
    --virtual-time-budget=8000 \
    --window-size="$width,$height" --screenshot="$out" "$url" >/dev/null 2>&1
  echo "  $(basename "$out")  ${width}x${height}  $(du -h "$out" | cut -f1)"
}

echo "Play developer page assets → $SRC"
shoot "file://$SRC/developer-header.html" 4096 2304 "$SRC/developer-header-4096x2304.png"

# Play caps this asset at 1 MB and a 4096x2304 PNG of a gradient lands around 3.5 MB, so the
# uploaded artifact is JPEG. The content is smooth washes and flat tiles, which JPEG handles well:
# even q92 comes in around 500 KB, only half the budget. Quality is set high deliberately rather
# than tuned down to the smallest file that fits — large flat gradients are exactly where JPEG
# banding shows, and there is no prize for using less of the allowance.
JPEG_QUALITY="${JPEG_QUALITY:-92}"
cp "$SRC/developer-header-4096x2304.png" "$SRC/developer-header-4096x2304.jpg"
sips -s format jpeg -s formatOptions "$JPEG_QUALITY" "$SRC/developer-header-4096x2304.jpg" >/dev/null
echo "  developer-header-4096x2304.jpg  4096x2304  $(du -h "$SRC/developer-header-4096x2304.jpg" | cut -f1)  (q$JPEG_QUALITY, this is the file to upload)"

# The icon is small enough that PNG stays far under the 1 MB limit, so it is uploaded as-is and
# avoids putting JPEG artefacts around the glyph edges.
shoot "file://$SRC/developer-icon.html" 512 512 "$SRC/developer-icon-512.png"

echo "Done."
