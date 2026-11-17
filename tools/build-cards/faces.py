"""Rendert die Kartenvorderseiten als PNG-Texturen fuer das 3D-Spiel.

Nutzt dieselbe HTML-Vorlage wie der Druck (build.py + style.css), damit Spiel und
Druckvorlage identisch aussehen. Ergebnis: assets/faces/<id>.png + _back.png
"""

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))

import build as B  # noqa: E402

OUT = ROOT / "assets" / "faces"
SCALE = 3  # 63 mm * 3 = 714 px breit

BACK_CSS = """
body.back-page { background: #2a2825; }
.card.back {
  background: #a8322f;
  border: 0.5mm solid #1c1b18;
  padding: 2.4mm;
}
.card.back .plate {
  height: 100%;
  border: 0.5mm solid #f4f1e8;
  border-radius: 1.2mm;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4mm;
  padding: 3mm;
}
.card.back .plate svg { width: 26mm; height: 26mm; }
.card.back .mark {
  font-size: 5.6pt;
  font-weight: 800;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: #f4f1e8;
  text-align: center;
  line-height: 1.5;
}
.card.back .rule {
  width: 26mm;
  height: 0.3mm;
  background: rgba(244, 241, 232, 0.55);
}
"""

SEAL = """
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" fill="none"
     stroke="#f4f1e8" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="50" cy="50" r="44"/>
  <circle cx="50" cy="50" r="35"/>
  <circle cx="50" cy="50" r="20"/>
  <path d="M50 34 L54.6 46.4 L67.8 46.9 L57.4 55.2 L61.1 67.9 L50 60.6 L38.9 67.9 L42.6 55.2 L32.2 46.9 L45.4 46.4 Z"
        fill="#f4f1e8" stroke="none"/>
  <g stroke-width="1.8">
    <path d="M50 2.5 V8"/><path d="M50 92 V97.5"/>
    <path d="M2.5 50 H8"/><path d="M92 50 H97.5"/>
    <path d="M16.4 16.4 L20.2 20.2"/><path d="M79.8 79.8 L83.6 83.6"/>
    <path d="M83.6 16.4 L79.8 20.2"/><path d="M20.2 79.8 L16.4 83.6"/>
  </g>
</svg>
"""


def main() -> None:
    data = json.loads((ROOT / "data" / "cards.json").read_text(encoding="utf-8"))
    cards = data["cards"]
    total = sum(c["copies"] for c in cards)

    art = {}
    css_rules = []
    for card in cards:
        rule, markup, _ = B.load_art(card["art"])
        art[card["art"]] = markup
        if rule:
            css_rules.append(rule)

    faces = [
        f'<div class="facewrap">{B.render_card(c, art[c["art"]], c["no"], total)}</div>'
        for c in cards
    ]

    css = (Path(__file__).resolve().parent / "style.css").read_text(encoding="utf-8")
    page_css = f"""
{css}
{BACK_CSS}
html, body {{ background: #2a2825; }}
.facewrap {{ width: 63mm; height: 88mm; }}
.faces {{ display: flex; flex-wrap: wrap; gap: 5mm; padding: 8mm; width: 227mm; }}
{chr(10).join(css_rules)}
"""

    back = f"""
<div class="facewrap">
  <div class="card back">
    <div class="plate">
      {SEAL}
      <div class="rule"></div>
      <div class="mark">Amt &amp; Ordnung</div>
      <div class="mark" style="font-size:3.4pt;letter-spacing:0.14em;opacity:0.72">
        Amt f&uuml;r allgemeine Ordnung
      </div>
    </div>
  </div>
</div>"""

    OUT.mkdir(parents=True, exist_ok=True)

    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.chromium.launch(channel="chrome")
        ctx = browser.new_context(viewport={"width": 900, "height": 1200},
                                  device_scale_factor=SCALE)
        page = ctx.new_page()
        page.set_content(
            f"<!doctype html><html lang='de'><head><meta charset='utf-8'><style>{page_css}</style>"
            f"</head><body><div class='faces'>{''.join(faces)}</div></body></html>"
        )
        page.wait_for_timeout(400)

        wraps = page.locator(".faces .facewrap .card")
        for i, card in enumerate(cards):
            wraps.nth(i).screenshot(path=str(OUT / f"{card['art']}.png"))

        page.set_content(
            f"<!doctype html><html lang='de'><head><meta charset='utf-8'><style>{page_css}</style>"
            f"</head><body class='back-page'>{back}</body></html>"
        )
        page.wait_for_timeout(300)
        page.locator(".card.back").screenshot(path=str(OUT / "_back.png"))

        browser.close()

    sizes = sorted(p.stat().st_size for p in OUT.glob("*.png"))
    print(f"{len(cards) + 1} Texturen -> {OUT}")
    print(f"Aufloesung: {SCALE * 238} x {SCALE * 333} px, "
          f"{sizes[0] // 1024}-{sizes[-1] // 1024} KB pro Datei")


if __name__ == "__main__":
    main()
