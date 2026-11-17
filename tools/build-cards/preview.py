"""Rendert Vorschau-PNGs (ganzes Blatt + Einzelkarte) für die Sichtprüfung."""

import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[2]


def main() -> None:
    src = ROOT / "build" / "cards.html"
    out = ROOT / "out"
    out.mkdir(parents=True, exist_ok=True)

    with sync_playwright() as p:
        browser = p.chromium.launch(channel="chrome")
        page = browser.new_page(
            viewport={"width": 794, "height": 1123},
            device_scale_factor=2,
        )
        page.goto(src.as_uri())
        page.screenshot(path=str(out / "preview-sheet1.png"), clip={
            "x": 0, "y": 0, "width": 794, "height": 1123,
        })

        # letztes Blatt (Dokumente)
        sheets = page.locator(".sheet")
        last = sheets.nth(sheets.count() - 1)
        last.scroll_into_view_if_needed()
        box = last.bounding_box()
        page.screenshot(path=str(out / "preview-sheet-last.png"), clip=box)
        page.evaluate("window.scrollTo(0,0)")

        # drei Karten des ersten Blattes als Detail
        page.evaluate("window.scrollTo(0,0)")
        boxes = page.locator(".card").evaluate_all(
            "els => els.slice(0,3).map(e => { const r = e.getBoundingClientRect();"
            " return {x:r.x, y:r.y, width:r.width, height:r.height}; })"
        )
        x = min(b["x"] for b in boxes)
        y = min(b["y"] for b in boxes)
        w = max(b["x"] + b["width"] for b in boxes) - x
        h = max(b["y"] + b["height"] for b in boxes) - y
        page.screenshot(path=str(out / "preview-detail.png"), clip={
            "x": x, "y": y, "width": w, "height": h,
        })

        for arg in sys.argv[1:]:
            idx = int(arg)
            sheet = sheets.nth(idx)
            sheet.scroll_into_view_if_needed()
            box = sheet.bounding_box()
            page.screenshot(path=str(out / f"preview-sheet{idx + 1}.png"), clip=box)
            print(out / f"preview-sheet{idx + 1}.png")

        browser.close()

    print(out / "preview-sheet1.png")
    print(out / "preview-detail.png")


if __name__ == "__main__":
    main()
