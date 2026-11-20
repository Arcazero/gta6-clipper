#!/usr/bin/env python3
"""Render the Ken Burns zoom as JPEG frames with PIL, fast.

ffmpeg's zoompan filter re-scales the whole input per output frame in a
single thread and took ~2s/frame on this VM. PIL resize is C-speed, so we
pre-render every frame: a centred crop window that shrinks a little each
frame (zoom 1.00 -> ~1.08), resized to 1080x1920. ffmpeg then only has to
encode the image sequence and draw the text overlays.
"""
import os
import sys
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(HERE, "assets")
FRAMES = os.path.join(HERE, "frames")
W, H = 1080, 1920

SEGMENTS = [
    # (name, source webp, frame count, zoom end)
    ("seg1", "media-generation-gta6-chase-frame1-0-2ca58a12-3d7e-40d5-8c40-cca348425d29.webp", 180, 1.08),
    ("seg2", "media-generation-gta6-chase-frame2-0-8f61f190-9076-45c9-9bcb-7b6390454892.webp", 180, 1.08),
    ("seg3", "media-generation-gta6-ghost-frame3-0-19c559ca-8657-4182-b2f0-fd14e180bffa.webp", 240, 1.07),
]

for name, src, n, zend in SEGMENTS:
    outdir = os.path.join(FRAMES, name)
    os.makedirs(outdir, exist_ok=True)
    img = Image.open(os.path.join(ASSETS, src)).convert("RGB")
    iw, ih = img.size
    for i in range(n):
        z = 1.0 + (zend - 1.0) * (i / max(n - 1, 1))
        cw, ch = int(iw / z), int(ih / z)
        x0, y0 = (iw - cw) // 2, (ih - ch) // 2
        frame = img.crop((x0, y0, x0 + cw, y0 + ch)).resize((W, H), Image.LANCZOS)
        frame.save(os.path.join(outdir, f"{i:04d}.jpg"), quality=88)
    print(f"{name}: {n} frames from {src} ({iw}x{ih})", flush=True)
print("done")
