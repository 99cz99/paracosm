# -*- coding: utf-8 -*-
"""Generate the app launcher icon (pixel-art speech bubble, typing-dots mark).

Chosen design: "暗夜青" palette + typing-dots ("...") mark + left tail.

Outputs:
  - legacy PNGs: res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png
  - adaptive icon (API 26+): res/mipmap-anydpi-v26/ic_launcher{,_round}.xml
  - vector foreground:          res/drawable/ic_launcher_foreground.xml
  - background color:           res/values/colors.xml

Run: python tool/gen_icon.py
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, 'android', 'app', 'src', 'main', 'res')

# Palette (hex + rgb)
BG      = 0x1F1B4D   # deep indigo  #1F1B4D
OUTLINE = 0x6EE7F0   # cyan         #6EE7F0
FILL    = 0x12242E   # dark cyan    #12242E
MARK    = 0xBFF3FA   # light cyan   #BFF3FA

N = 28  # logical grid


def rgb(c):
    return ((c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF)


def hexs(c):
    return '#%06X' % c


def in_rr(x, y, x0, y0, x1, y1, r):
    if x < x0 or x > x1 or y < y0 or y > y1:
        return False
    dx = max(x0 + r - x, 0, x - (x1 - r))
    dy = max(y0 + r - y, 0, y - (y1 - r))
    return dx * dx + dy * dy <= r * r


def draw_rr(g, x0, y0, x1, y1, r, c):
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            if in_rr(x, y, x0, y0, x1, y1, r):
                g[y][x] = c


def mark_dots(g, cx, cy, c):
    for ox in (-5, -1, 3):  # three 2x2 dots
        for dx in (0, 1):
            for dy in (-1, 0):
                g[cy + dy][cx + ox + dx] = c


def build_grid():
    g = [[BG for _ in range(N)] for _ in range(N)]
    draw_rr(g, 5, 4, 22, 16, 4, OUTLINE)
    draw_rr(g, 6, 5, 21, 15, 3, FILL)
    # left tail
    tx = 11
    for x, y in [(tx - 2, 17), (tx + 2, 17), (tx - 1, 18), (tx + 1, 18), (tx, 19)]:
        g[y][x] = OUTLINE
    for x, y in [(tx - 1, 16), (tx, 16), (tx + 1, 16),
                 (tx - 1, 17), (tx, 17), (tx + 1, 17),
                 (tx, 18)]:
        g[y][x] = FILL
    mark_dots(g, 13, 9, MARK)
    return g


def write_legacy_pngs(g):
    densities = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}
    for name, size in densities.items():
        img = Image.new('RGB', (N, N))
        px = img.load()
        for y in range(N):
            for x in range(N):
                px[x, y] = rgb(g[y][x])
        img = img.resize((size, size), Image.NEAREST)
        d = os.path.join(RES, 'mipmap-' + name)
        os.makedirs(d, exist_ok=True)
        img.save(os.path.join(d, 'ic_launcher.png'))
        print('wrote', os.path.join(d, 'ic_launcher.png'))


def build_foreground_xml(g):
    # center the art (bbox x=5..22, y=4..19) in a 108x108 viewport, cell = 3.5dp
    groups = {OUTLINE: [], FILL: [], MARK: []}
    for gy in range(N):
        for gx in range(N):
            c = g[gy][gx]
            if c == BG:
                continue
            x = 22.5 + (gx - 5) * 3.5
            y = 26.0 + (gy - 4) * 3.5
            groups[c].append('M%.1f,%.1fh3.5v3.5h-3.5z' % (x, y))
    parts = ['<vector xmlns:android="http://schemas.android.com/apk/res/android"',
             '    android:width="108dp"',
             '    android:height="108dp"',
             '    android:viewportWidth="108"',
             '    android:viewportHeight="108">']
    for c in (OUTLINE, FILL, MARK):
        parts.append('    <path android:fillColor="%s" android:pathData="%s"/>'
                     % (hexs(c), ''.join(groups[c])))
    parts.append('</vector>')
    return '\n'.join(parts)


def write_adaptive(g):
    d = os.path.join(RES, 'drawable')
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, 'ic_launcher_foreground.xml'), 'w', encoding='utf-8') as f:
        f.write(build_foreground_xml(g) + '\n')
    print('wrote', os.path.join(d, 'ic_launcher_foreground.xml'))

    vd = os.path.join(RES, 'values')
    os.makedirs(vd, exist_ok=True)
    with open(os.path.join(vd, 'colors.xml'), 'w', encoding='utf-8') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>\n'
                '<resources>\n'
                '    <color name="ic_launcher_background">%s</color>\n'
                '</resources>\n' % hexs(BG))
    print('wrote', os.path.join(vd, 'colors.xml'))

    ad = os.path.join(RES, 'mipmap-anydpi-v26')
    os.makedirs(ad, exist_ok=True)
    body = ('<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@color/ic_launcher_background"/>\n'
            '    <foreground android:drawable="@drawable/ic_launcher_foreground"/>\n'
            '</adaptive-icon>\n')
    for name in ('ic_launcher.xml', 'ic_launcher_round.xml'):
        with open(os.path.join(ad, name), 'w', encoding='utf-8') as f:
            f.write(body)
        print('wrote', os.path.join(ad, name))


if __name__ == '__main__':
    grid = build_grid()
    write_legacy_pngs(grid)
    write_adaptive(grid)
    print('done')
