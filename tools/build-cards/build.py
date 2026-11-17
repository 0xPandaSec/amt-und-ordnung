"""Baut aus data/cards.json ein druckfertiges A4-PDF (9 Karten pro Seite)."""

import html
import io
import json
import sys
from base64 import b64encode
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))

import art_gen  # noqa: E402

LABELS = {
    "bedrohung": "Bedrohung",
    "rettung": "Rettung",
    "reaktion": "Reaktion",
    "verzoegerung": "Verzögerung",
    "information": "Information",
    "kontrolle": "Kontrolle",
    "interaktion": "Interaktion",
    "dokument": "Dokument",
}

PER_SHEET = 9

# Zielbreite der eingebetteten Bilder. 57 mm Kartenbreite bei 400 dpi = ~900 px.
ART_WIDTH = 1100
ART_QUALITY = 92


def color_of(card: dict) -> str:
    if card["category"] == "dokument":
        return art_gen.COLORS[card["id"]]
    return art_gen.COLORS[card["category"]]


def expand(cards: list[dict]) -> list[dict]:
    deck = []
    for card in cards:
        for _ in range(card["copies"]):
            deck.append(card)
    return deck


def encode_image(path: Path) -> str:
    """Verkleinert das Bild und gibt es als base64-JPEG zurueck."""
    from PIL import Image

    img = Image.open(path)
    if img.mode in ("RGBA", "LA", "P"):
        img = img.convert("RGBA")
        flat = Image.new("RGB", img.size, (244, 241, 232))
        flat.paste(img, mask=img.split()[-1])
        img = flat
    else:
        img = img.convert("RGB")

    if img.width > ART_WIDTH:
        height = round(img.height * ART_WIDTH / img.width)
        img = img.resize((ART_WIDTH, height), Image.LANCZOS)

    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=ART_QUALITY, optimize=True, progressive=True)
    return b64encode(buf.getvalue()).decode("ascii")


def load_art(stem: str) -> tuple[str, str, bool]:
    """Liefert (CSS-Regel, Karten-Markup, ist_platzhalter)."""
    for ext in ("png", "jpg", "jpeg", "webp"):
        path = ROOT / "art" / f"{stem}.{ext}"
        if path.exists():
            data = encode_image(path)
            css = f".shot-{stem}{{background-image:url(data:image/jpeg;base64,{data})}}"
            return css, f'<div class="shot shot-{stem}"></div>', False

    svg = (ROOT / "art" / f"{stem}.svg").read_text(encoding="utf-8")
    return "", svg, True


def render_card(card: dict, art: str, number: int, total: int) -> str:
    e = html.escape
    return f"""
<div class="card" style="--c:{color_of(card)}">
  <div class="head">
    <div class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke-linejoin="round">{art_gen.ICONS[card["icon"]]}</svg>
    </div>
    <div class="titles">
      <div class="overline">Amt f&uuml;r allgemeine Ordnung &middot; Formular {card["no"]:03d}</div>
      <div class="title">{e(card["name"])}</div>
    </div>
  </div>
  <div class="art">
    {art}
    <div class="stamp">{e(LABELS[card["category"]])}</div>
  </div>
  <div class="body">
    <div class="field">
      <div class="field-label">Wirkung</div>
      <div class="effect">{e(card["effect"])}</div>
      <div class="filler"><span>Aktenzeichen</span><i></i></div>
    </div>
    <div class="flavor">{e(card["flavor"])}</div>
  </div>
  <div class="foot">
    <span>Nr. {number:03d} / {total:03d}</span>
    <span>{card["copies"]}&times; im Deck</span>
  </div>
</div>"""


def build_html(cards: list[dict]) -> tuple[str, list[str]]:
    deck = expand(cards)
    total = len(deck)

    art = {}
    css_rules = []
    placeholders = []
    for card in cards:
        rule, markup, is_placeholder = load_art(card["art"])
        art[card["art"]] = markup
        if rule:
            css_rules.append(rule)
        if is_placeholder:
            placeholders.append(card["name"])

    rendered = [
        render_card(card, art[card["art"]], i + 1, total)
        for i, card in enumerate(deck)
    ]

    sheets = []
    for start in range(0, len(rendered), PER_SHEET):
        chunk = rendered[start:start + PER_SHEET]
        sheets.append('<div class="sheet">' + "".join(chunk) + "</div>")

    css = (Path(__file__).resolve().parent / "style.css").read_text(encoding="utf-8")
    extra = "\n".join(css_rules)

    return f"""<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<title>Amt &amp; Ordnung — Prototyp</title>
<style>
{css}
{extra}
</style>
</head>
<body>
{"".join(sheets)}
</body>
</html>""", placeholders


def main() -> None:
    data = json.loads((ROOT / "data" / "cards.json").read_text(encoding="utf-8"))

    art_gen.build(ROOT / "art")

    out_html = ROOT / "build" / "cards.html"
    out_html.parent.mkdir(parents=True, exist_ok=True)
    markup, placeholders = build_html(data["cards"])
    out_html.write_text(markup, encoding="utf-8")

    deck = expand(data["cards"])
    pdf_path = ROOT / "out" / "amt-und-ordnung-karten.pdf"
    pdf_path.parent.mkdir(parents=True, exist_ok=True)

    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.chromium.launch(channel="chrome")
        page = browser.new_page()
        page.goto(out_html.as_uri())
        page.emulate_media(media="print")
        page.pdf(
            path=str(pdf_path),
            format="A4",
            print_background=True,
            prefer_css_page_size=True,
            margin={"top": "0", "right": "0", "bottom": "0", "left": "0"},
        )
        browser.close()

    pages = (len(deck) + PER_SHEET - 1) // PER_SHEET
    print(f"Deck:   {len(deck)} Karten aus {len(data['cards'])} Typen")
    print(f"Seiten: {pages}")
    if placeholders:
        print(f"Artwork: {len(placeholders)} Motive sind noch SVG-Platzhalter:")
        for name in placeholders:
            print(f"         - {name}")
    else:
        print("Artwork: alle 14 Motive sind echte Bilder")
    print(f"HTML:   {out_html}  ({out_html.stat().st_size // 1024} KB)")
    print(f"PDF:    {pdf_path}  ({pdf_path.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
