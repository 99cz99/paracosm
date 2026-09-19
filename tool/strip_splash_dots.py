# -*- coding: utf-8 -*-
"""Strip the three typing dots from the native splash icon.

The native splash (`drawable/ic_splash.png`) keeps its three dots so they show
from the first frame; the Flutter splash overlays *animated* dots on top, so it
needs a dot-free copy of the same icon (`assets/ic_splash.png`). This script
derives that dot-free asset by repainting the MARK-colored dots to FILL.

Run: python tool/strip_splash_dots.py
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'android', 'app', 'src', 'main', 'res', 'drawable', 'ic_splash.png')
DST = os.path.join(ROOT, 'assets', 'ic_splash.png')

# Palette (must match tool/gen_icon.py).
MARK = (0xBF, 0xF3, 0xFA)  # #BFF3FA light-cyan dots
FILL = (0x12, 0x24, 0x2E)  # #12242E dark-cyan bubble body
TOL = 16


def is_mark(px):
    return all(abs(px[i] - MARK[i]) <= TOL for i in range(3))


def main():
    img = Image.open(SRC).convert('RGBA')
    w, h = img.size
    px = img.load()
    stripped = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a > 0 and is_mark((r, g, b)):
                px[x, y] = FILL + (a,)
                stripped += 1
    os.makedirs(os.path.dirname(DST), exist_ok=True)
    img.save(DST)
    print('wrote %s (stripped %d dot pixels)' % (DST, stripped))


if __name__ == '__main__':
    main()
