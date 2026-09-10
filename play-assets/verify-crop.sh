#!/usr/bin/env bash
# Proves the developer page header survives the crop Play actually applies to it.
#
#   ./play-assets/verify-crop.sh
#
# Why this exists: Play renders the header with object-fit:cover into a container whose aspect
# ratio depends on the viewport, so the uploaded 16:9 image is never what a desktop visitor sees.
# Measured on the live store page:
#
#   desktop  1424x480  = 2.97:1  → only the middle ~60% of the height survives
#   mobile    412x232  = 1.78:1  → the whole image is shown
#
# A header that reads well as a 16:9 rectangle can still lose its tagline on desktop, and looking
# at the source PNG will never reveal it. This writes out both crops so the centre-safe zone is
# checked by eye against the real framing rather than assumed.
#
# Also enforces Play's hard limits: 4096x2304, non-transparent, under 1 MB.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Check the JPEG, because that is the file that gets uploaded. Verifying the PNG would pass the
# size check against an artifact Play never receives.
IN="$SRC/developer-header-4096x2304.jpg"
OUT="$SRC/crop-preview"

[[ -f "$IN" ]] || { echo "Missing $IN — run ./play-assets/render.sh first." >&2; exit 1; }

mkdir -p "$OUT"
fail=0

# ---- Hard limits Play enforces on upload -------------------------------------------------
dims=$(sips -g pixelWidth -g pixelHeight "$IN" | awk '/pixel/{printf "%s ", $2}')
read -r w h <<< "$dims"
if [[ "$w" != "4096" || "$h" != "2304" ]]; then
  echo "FAIL  dimensions are ${w}x${h}, Play requires 4096x2304"
  fail=1
else
  echo "ok    dimensions 4096x2304"
fi

bytes=$(stat -f%z "$IN")
limit=$((1024 * 1024))
if (( bytes > limit )); then
  echo "FAIL  $((bytes / 1024)) KB exceeds Play's 1 MB limit — export JPEG instead (see render.sh)"
  fail=1
else
  echo "ok    $((bytes / 1024)) KB, under the 1 MB limit"
fi

if sips -g hasAlpha "$IN" | grep -q 'hasAlpha: yes'; then
  echo "FAIL  image has an alpha channel; Play requires a non-transparent 24-bit PNG or JPEG"
  fail=1
else
  echo "ok    no alpha channel"
fi

fmt=$(sips -g format "$IN" | awk '/format:/{print $2}')
echo "ok    format $fmt"

# ---- The crops a real visitor sees -------------------------------------------------------
# sips -c takes HEIGHT then WIDTH and crops from the centre, which is exactly what
# object-position:50% 50% does.
crop() {
  local ratio="$1" name="$2"
  local ch
  ch=$(awk -v r="$ratio" 'BEGIN{printf "%d", 4096 / r}')
  cp "$IN" "$OUT/$name.png"
  sips -s format png -c "$ch" 4096 "$OUT/$name.png" >/dev/null
  sips -Z 1400 "$OUT/$name.png" >/dev/null
  echo "  $name.png   ${ratio}:1  (kept middle ${ch}px of 2304)"
}

echo
echo "Crop previews → $OUT"
crop 2.97 desktop
crop 1.78 mobile
# A deliberately harsher ratio than anything measured, as headroom against Play changing the
# container. If the copy still reads here, the design is not living dangerously.
crop 3.60 desktop-worst-case

echo
if (( fail )); then
  echo "FAILED — fix the above before uploading."
  exit 1
fi
echo "Limits pass. Open the three crops and confirm no wording is cut."
