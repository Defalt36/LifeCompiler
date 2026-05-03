#!/usr/bin/env python3
from PIL import Image

INPUT = "output/canvas.png"
OUTPUT = "output/canvas_cropped.png"

CELL = 32
GRID = 16

# Hardcoded characters to KEEP (everything else gets nuked)
#KEEP_CHARS = (" !'()+,-./0123456789:=?ABCDEFGHIJKLMNOPQRSTUVWXYZx")
KEEP_CHARS = (" !'+,-./0123456789:?ABCDEFGHIJKLMNOPQRSTUVWXYZ")

KEEP_CODES = {ord(c) for c in KEEP_CHARS}

img = Image.open(INPUT).convert("RGBA")

if img.size != (512, 512):
    raise ValueError(f"Expected 512x512, got {img.size}")

pixels = img.load()

for code in range(256):
    if code in KEEP_CODES:
        continue

    row = code // GRID
    col = code % GRID

    x0 = col * CELL
    y0 = row * CELL

    for y in range(y0, y0 + CELL):
        for x in range(x0, x0 + CELL):
            r, g, b, a = pixels[x, y]
            pixels[x, y] = (r, g, b, 0)

img.save(OUTPUT)
