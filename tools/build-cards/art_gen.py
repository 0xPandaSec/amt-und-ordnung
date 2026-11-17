"""Erzeugt die Karten-Illustrationen als SVG (Flat-Comic-Stil, 300x170)."""

from pathlib import Path

INK = "#1C1B18"
PAPER = "#F4F1E8"

COLORS = {
    "bedrohung": "#A8322F",
    "rettung": "#3F7A4C",
    "reaktion": "#1C1B18",
    "verzoegerung": "#3A5A6B",
    "information": "#D9A521",
    "kontrolle": "#5C5C56",
    "interaktion": "#2E7A78",
    "bauantrag": "#2C5F8A",
    "laermprotokoll": "#3F7A4C",
    "grundriss": "#D9A521",
    "statiknachweis": "#A8322F",
    "nachbarschaftsbeschwerde": "#6B4B8A",
}


def light(hex_color: str, amount: float = 0.20) -> str:
    """Mischt eine Farbe mit Papierweiss zu einem hellen Hintergrundton."""
    def ch(c: str) -> int:
        return int(c, 16)

    r = ch(hex_color[1:3])
    g = ch(hex_color[3:5])
    b = ch(hex_color[5:7])
    pr, pg, pb = ch(PAPER[1:3]), ch(PAPER[3:5]), ch(PAPER[5:7])
    return "#%02X%02X%02X" % (
        round(pr + (r - pr) * amount),
        round(pg + (g - pg) * amount),
        round(pb + (b - pb) * amount),
    )


# Illustration -> Kategorie-/Dokumentfarbe
TINTS = {
    "auflagenbescheid": COLORS["bedrohung"],
    "widerspruch": COLORS["rettung"],
    "formfehler": COLORS["reaktion"],
    "vorgang-vertagen": COLORS["verzoegerung"],
    "fristverlaengerung": COLORS["verzoegerung"],
    "amtshilfe": COLORS["interaktion"],
    "zustaendigkeit-wechseln": COLORS["kontrolle"],
    "akteneinsicht": COLORS["information"],
    "aus-dem-archiv": COLORS["kontrolle"],
    "bauantrag": COLORS["bauantrag"],
    "laermprotokoll": COLORS["laermprotokoll"],
    "grundriss": COLORS["grundriss"],
    "statiknachweis": COLORS["statiknachweis"],
    "nachbarschaftsbeschwerde": COLORS["nachbarschaftsbeschwerde"],
}


def frame(tint: str) -> str:
    """Handgezeichnet wirkender Hintergrund: Strahlen, Halbton, Tuscheschraffur."""
    return f"""<defs>
  <filter id="ink" x="-8%" y="-8%" width="116%" height="116%">
    <feTurbulence type="fractalNoise" baseFrequency="0.026" numOctaves="3" seed="11" result="n"/>
    <feDisplacementMap in="SourceGraphic" in2="n" scale="3.4" xChannelSelector="R" yChannelSelector="G"/>
  </filter>
  <pattern id="dots" width="10" height="10" patternUnits="userSpaceOnUse">
    <circle cx="2" cy="2" r="1.5" fill="{INK}" opacity="0.20"/>
  </pattern>
  <pattern id="hatch" width="7" height="7" patternUnits="userSpaceOnUse" patternTransform="rotate(42)">
    <line x1="0" y1="0" x2="0" y2="7" stroke="{INK}" stroke-width="1.5" opacity="0.42"/>
  </pattern>
  <pattern id="hatch2" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(-38)">
    <line x1="0" y1="0" x2="0" y2="8" stroke="{INK}" stroke-width="1.2" opacity="0.26"/>
  </pattern>
</defs>
<rect width="300" height="170" fill="{tint}"/>
<g opacity="0.5">
  <path d="M150 120 L-30 -40 L40 -60 Z" fill="#fff" opacity="0.55"/>
  <path d="M150 120 L340 -30 L300 -70 Z" fill="#fff" opacity="0.55"/>
  <path d="M150 120 L120 200 L40 190 Z" fill="{INK}" opacity="0.10"/>
  <path d="M150 120 L250 210 L330 175 Z" fill="{INK}" opacity="0.10"/>
</g>
<rect x="0" y="0" width="300" height="170" fill="url(#dots)" opacity="0.7"/>
<rect x="0" y="142" width="300" height="28" fill="url(#hatch2)" opacity="0.55"/>
"""


def svg(card_id: str, inner: str, tint: str) -> str:
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 170"
  shape-rendering="geometricPrecision">{frame(tint)}
  <g filter="url(#ink)">
    <ellipse cx="150" cy="150" rx="74" ry="9" fill="url(#hatch)" opacity="0.55" stroke="none"/>
    <g stroke="{INK}" stroke-width="4.6" stroke-linejoin="round" stroke-linecap="round">
{inner}
    </g>
  </g></svg>"""


# ---------------------------------------------------------------- Illustrationen
ILLU = {}

ILLU["auflagenbescheid"] = f"""
  <g transform="rotate(-5 150 90)">
    <rect x="96" y="22" width="108" height="126" rx="3" fill="{PAPER}"/>
    <line x1="112" y1="48" x2="188" y2="48" stroke-width="5"/>
    <line x1="112" y1="62" x2="188" y2="62" stroke-width="3" opacity="0.55"/>
    <line x1="112" y1="72" x2="176" y2="72" stroke-width="3" opacity="0.55"/>
    <line x1="112" y1="82" x2="188" y2="82" stroke-width="3" opacity="0.55"/>
    <line x1="112" y1="92" x2="164" y2="92" stroke-width="3" opacity="0.55"/>
    <line x1="112" y1="126" x2="150" y2="126" stroke-width="2" opacity="0.4"/>
  </g>
  <circle cx="196" cy="118" r="30" fill="none" stroke="{COLORS['bedrohung']}" stroke-width="7" opacity="0.9"/>
  <path d="M196 104 v16" stroke="{COLORS['bedrohung']}" stroke-width="7"/>
  <path d="M196 128 v2" stroke="{COLORS['bedrohung']}" stroke-width="8"/>
  <path d="M62 44 L92 96 H32 Z" fill="#fff" stroke-width="4"/>
  <path d="M62 62 v18" stroke-width="5"/>
  <path d="M62 88 v2" stroke-width="6"/>
"""

ILLU["widerspruch"] = f"""
  <path d="M150 18 L222 46 V96 C222 132 190 152 150 162 C110 152 78 132 78 96 V46 Z" fill="{PAPER}"/>
  <path d="M150 34 L206 56 V95 C206 123 181 139 150 147 C119 139 94 123 94 95 V56 Z"
        fill="{COLORS['rettung']}" opacity="0.16" stroke="none"/>
  <path d="M116 92 L140 118 L188 62" fill="none" stroke="{COLORS['rettung']}" stroke-width="13"/>
  <path d="M46 40 l14 -14 M40 62 l20 -20" stroke-width="3" opacity="0.5"/>
  <path d="M254 40 l-14 -14 M260 62 l-20 -20" stroke-width="3" opacity="0.5"/>
"""

ILLU["formfehler"] = f"""
  <path d="M92 26 L208 26 L200 44 L206 62 L196 80 L206 98 L196 116 L204 134 L92 134 L100 116
           L92 98 L102 80 L92 62 L100 44 Z" fill="{PAPER}"/>
  <line x1="114" y1="58" x2="186" y2="58" stroke-width="3" opacity="0.45"/>
  <line x1="114" y1="72" x2="186" y2="72" stroke-width="3" opacity="0.45"/>
  <line x1="114" y1="100" x2="186" y2="100" stroke-width="3" opacity="0.45"/>
  <line x1="114" y1="114" x2="164" y2="114" stroke-width="3" opacity="0.45"/>
  <path d="M108 46 L192 124" stroke="{COLORS['bedrohung']}" stroke-width="14"/>
  <path d="M192 46 L108 124" stroke="{COLORS['bedrohung']}" stroke-width="14"/>
"""

ILLU["vorgang-vertagen"] = f"""
  <circle cx="150" cy="80" r="52" fill="{PAPER}"/>
  <circle cx="150" cy="80" r="52" fill="none" stroke-width="6"/>
  <path d="M150 80 V44" stroke-width="6"/>
  <path d="M150 80 L178 94" stroke-width="6"/>
  <circle cx="150" cy="80" r="5" fill="{INK}" stroke="none"/>
  <path d="M132 134 q10 26 -6 34" fill="none" stroke-width="5" opacity="0.8"/>
  <path d="M168 134 q-10 24 8 32" fill="none" stroke-width="5" opacity="0.8"/>
  <path d="M56 124 h22 M270 124 h-22" stroke-width="3" opacity="0.4"/>
"""

ILLU["fristverlaengerung"] = f"""
  <path d="M46 140 H100 V110 H154 V80 H208 V50 H258" fill="none" stroke-width="6"/>
  <g stroke="none">
    <rect x="52" y="126" width="48" height="14" fill="{PAPER}"/>
    <rect x="106" y="96" width="48" height="14" fill="{PAPER}"/>
    <rect x="160" y="66" width="48" height="14" fill="{PAPER}"/>
  </g>
  <g stroke-width="3" opacity="0.5">
    <line x1="58" y1="133" x2="94" y2="133"/>
    <line x1="112" y1="103" x2="148" y2="103"/>
    <line x1="166" y1="73" x2="202" y2="73"/>
  </g>
  <path d="M228 34 h44 v34 h-44 z" fill="{INK}"/>
  <path d="M236 34 v-9 h28 v9" fill="none" stroke-width="4"/>
  <path d="M222 96 v18 M296 96 v18" stroke-width="5"/>
"""

ILLU["amtshilfe"] = f"""
  <rect x="118" y="52" width="64" height="76" rx="2" fill="{PAPER}"/>
  <line x1="130" y1="70" x2="170" y2="70" stroke-width="3" opacity="0.5"/>
  <line x1="130" y1="82" x2="170" y2="82" stroke-width="3" opacity="0.5"/>
  <line x1="130" y1="94" x2="156" y2="94" stroke-width="3" opacity="0.5"/>
  <path d="M22 92 h52 a12 12 0 0 0 0 -24 h-20" fill="none" stroke-width="6"/>
  <path d="M46 60 l-16 8 16 8" fill="{PAPER}" stroke-width="4"/>
  <path d="M278 92 h-52 a12 12 0 0 1 0 -24 h20" fill="none" stroke-width="6"/>
  <path d="M254 60 l16 8 -16 8" fill="{PAPER}" stroke-width="4"/>
  <path d="M150 24 v-8 M120 30 l-6 -8 M180 30 l6 -8" stroke-width="3" opacity="0.4"/>
"""

ILLU["zustaendigkeit-wechseln"] = f"""
  <g stroke-width="6" fill="none">
    <path d="M104 84 A52 40 0 0 1 196 70"/>
    <path d="M196 84 A52 40 0 0 1 104 70"/>
  </g>
  <path d="M196 70 l14 4 -10 12 z" fill="{INK}" stroke-width="3"/>
  <path d="M104 70 l-14 4 10 12 z" fill="{INK}" stroke-width="3"/>
  <g stroke-width="3">
    <rect x="126" y="62" width="26" height="34" fill="{PAPER}" transform="rotate(-14 139 79)"/>
    <rect x="150" y="60" width="26" height="34" fill="{PAPER}" transform="rotate(12 163 77)"/>
  </g>
  <path d="M40 130 q14 -10 26 2 M262 132 q-14 -10 -26 2" stroke-width="3" opacity="0.4"/>
"""

ILLU["akteneinsicht"] = f"""
  <path d="M34 84 C74 40 226 40 266 84 C226 128 74 128 34 84 Z" fill="{PAPER}"/>
  <circle cx="150" cy="84" r="34" fill="{COLORS['information']}" opacity="0.35" stroke-width="5"/>
  <circle cx="150" cy="84" r="18" fill="{INK}" stroke="none"/>
  <circle cx="141" cy="75" r="6" fill="#fff" stroke="none"/>
  <path d="M70 40 l-10 -12 M230 40 l10 -12" stroke-width="4"/>
  <path d="M96 132 h30 M174 132 h30" stroke-width="3" opacity="0.45"/>
"""

ILLU["aus-dem-archiv"] = f"""
  <rect x="88" y="20" width="124" height="104" rx="3" fill="{PAPER}"/>
  <line x1="88" y1="54" x2="212" y2="54" stroke-width="4"/>
  <line x1="88" y1="88" x2="212" y2="88" stroke-width="4"/>
  <rect x="108" y="34" width="84" height="12" rx="2" fill="{INK}" stroke="none"/>
  <rect x="108" y="68" width="84" height="12" rx="2" fill="{INK}" stroke="none"/>
  <rect x="70" y="104" width="160" height="34" rx="3" fill="{PAPER}"/>
  <rect x="96" y="112" width="108" height="12" rx="2" fill="{INK}" stroke="none"/>
  <path d="M126 104 V84 h48 v20" fill="{PAPER}" stroke-width="4"/>
  <path d="M150 60 v14 M142 66 l8 10 8 -10" fill="none" stroke-width="4"/>
"""

ILLU["bauantrag"] = f"""
  <g opacity="0.28" stroke-width="2">
    <line x1="40" y1="40" x2="260" y2="40"/>
    <line x1="40" y1="80" x2="260" y2="80"/>
    <line x1="40" y1="120" x2="260" y2="120"/>
    <line x1="90" y1="20" x2="90" y2="150"/>
    <line x1="150" y1="20" x2="150" y2="150"/>
    <line x1="210" y1="20" x2="210" y2="150"/>
  </g>
  <path d="M128 24 L110 134" fill="none" stroke-width="7"/>
  <path d="M172 24 L192 134" fill="none" stroke-width="7"/>
  <circle cx="150" cy="26" r="10" fill="{PAPER}" stroke-width="5"/>
  <path d="M150 26 V150" fill="none" stroke-width="3" opacity="0.6"/>
  <path d="M118 96 A46 46 0 0 1 182 96" fill="none" stroke-width="3" opacity="0.6"/>
"""

ILLU["laermprotokoll"] = f"""
  <path d="M96 62 h26 l34 -28 v92 l-34 -28 h-26 z" fill="{PAPER}"/>
  <g fill="none" stroke="{COLORS['laermprotokoll']}" stroke-width="6">
    <path d="M172 60 q14 24 0 48"/>
    <path d="M192 46 q24 38 0 76"/>
    <path d="M212 32 q34 52 0 104"/>
  </g>
  <g stroke-width="3" opacity="0.4">
    <path d="M46 48 l16 8 M42 84 h18 M46 120 l16 -8"/>
  </g>
  <path d="M150 138 h80" stroke-width="5"/>
"""

ILLU["grundriss"] = f"""
  <rect x="86" y="22" width="130" height="120" fill="{PAPER}"/>
  <line x1="86" y1="76" x2="170" y2="76" stroke-width="4"/>
  <line x1="140" y1="76" x2="140" y2="142" stroke-width="4"/>
  <line x1="170" y1="40" x2="170" y2="76" stroke-width="4"/>
  <path d="M126 76 v14 M140 76 v14" stroke-width="3" opacity="0.5"/>
  <path d="M170 60 a16 16 0 0 1 16 16" fill="none" stroke-width="3" opacity="0.7"/>
  <path d="M86 142 h130" stroke-width="3" opacity="0.4"/>
  <path d="M60 34 l16 -12 M244 34 l-16 -12" stroke-width="3" opacity="0.45"/>
"""

ILLU["statiknachweis"] = f"""
  <path d="M118 26 h64 v20 h-20 v78 h20 v20 h-64 v-20 h20 v-78 h-20 z" fill="{PAPER}"/>
  <g stroke="none" opacity="0.75">
    <rect x="132" y="52" width="36" height="6" fill="{COLORS['statiknachweis']}"/>
    <rect x="132" y="66" width="36" height="6" fill="{COLORS['statiknachweis']}"/>
    <rect x="132" y="80" width="36" height="6" fill="{COLORS['statiknachweis']}"/>
  </g>
  <path d="M150 26 v-10 M134 14 l16 -8 16 8" fill="none" stroke-width="4"/>
  <path d="M60 140 q90 -22 180 0" fill="none" stroke-width="3" opacity="0.4" stroke-dasharray="8 8"/>
"""

ILLU["nachbarschaftsbeschwerde"] = f"""
  <rect x="70" y="52" width="160" height="92" rx="2" fill="{PAPER}"/>
  <path d="M70 52 L150 106 L230 52" fill="none" stroke-width="5"/>
  <rect x="126" y="30" width="48" height="34" rx="2" fill="{COLORS['nachbarschaftsbeschwerde']}" opacity="0.85"/>
  <path d="M150 38 v12" stroke="#fff" stroke-width="6"/>
  <path d="M150 56 v2" stroke="#fff" stroke-width="7"/>
  <path d="M108 116 h48 M108 128 h34" stroke-width="3" opacity="0.45"/>
  <path d="M44 44 l12 -12 M256 44 l-12 -12" stroke-width="3" opacity="0.45"/>
"""


# ------------------------------------------------------------ kleine Kopf-Icons
ICONS = {
    "warnung": '<path d="M12 3 L22 21 H2 Z" fill="#fff"/><path d="M12 9 v6" stroke="#000" stroke-width="2.4"/><path d="M12 17.4 v1.6" stroke="#000" stroke-width="2.6"/>',
    "schild": '<path d="M12 2 L21 6 V12 C21 17.5 17 21 12 22.5 C7 21 3 17.5 3 12 V6 Z" fill="#fff"/><path d="M7.5 12 L11 15.5 L17 8.5" stroke="#000" stroke-width="2.6" fill="none"/>',
    "x": '<path d="M5 5 L19 19 M19 5 L5 19" stroke="#fff" stroke-width="3.6"/>',
    "uhr": '<circle cx="12" cy="12" r="9.2" fill="#fff"/><path d="M12 6.5 V12 L16 14.5" stroke="#000" stroke-width="2.4" fill="none"/>',
    "pfeile": '<path d="M4 8 H18 V3 L22 8 L18 13 V8" fill="#fff"/><path d="M20 16 H6 V11 L2 16 L6 21 V16" fill="#fff"/>',
    "haende": '<circle cx="6" cy="12" r="4" fill="#fff"/><circle cx="18" cy="12" r="4" fill="#fff"/><path d="M9 12 H15" stroke="#000" stroke-width="2.4"/>',
    "kreuzpfeile": '<path d="M4 9 A9 9 0 0 1 19 7" stroke="#fff" stroke-width="2.8" fill="none"/><path d="M20 15 A9 9 0 0 1 5 17" stroke="#fff" stroke-width="2.8" fill="none"/><path d="M19 3 L21 8 L16 8.5 Z" fill="#fff"/><path d="M5 21 L3 16 L8 15.5 Z" fill="#fff"/>',
    "auge": '<path d="M2 12 C6 5 18 5 22 12 C18 19 6 19 2 12 Z" fill="#fff"/><circle cx="12" cy="12" r="3.4" fill="#000"/>',
    "archiv": '<rect x="4" y="3" width="16" height="12" fill="#fff"/><rect x="2" y="15" width="20" height="6" fill="#fff"/><path d="M4 7 H20 M4 11 H20" stroke="#000" stroke-width="1.6"/>',
    "zirkel": '<path d="M12 3 L6 20 M12 3 L18 20" stroke="#fff" stroke-width="2.6" fill="none"/><circle cx="12" cy="3" r="2.2" fill="#fff"/>',
    "schall": '<path d="M4 9 H8 L13 5 V19 L8 15 H4 Z" fill="#fff"/><path d="M16 8 Q19 12 16 16" stroke="#fff" stroke-width="2" fill="none"/><path d="M19 5.5 Q24 12 19 18.5" stroke="#fff" stroke-width="2" fill="none"/>',
    "plan": '<rect x="3" y="3" width="18" height="18" stroke="#fff" stroke-width="2.4" fill="none"/><path d="M3 11 H12 V21" stroke="#fff" stroke-width="2.4" fill="none"/>',
    "traeger": '<path d="M4 3 H20 V6.5 H13.5 V17.5 H20 V21 H4 V17.5 H10.5 V6.5 H4 Z" fill="#fff"/>',
    "brief": '<rect x="2" y="6" width="20" height="13" rx="1.5" fill="#fff"/><path d="M2 6 L12 13 L22 6" stroke="#000" stroke-width="2"/>',
}


def build(art_dir: Path) -> None:
    art_dir.mkdir(parents=True, exist_ok=True)
    for cid, inner in ILLU.items():
        base = TINTS.get(cid, "#5C5C56")
        (art_dir / f"{cid}.svg").write_text(svg(cid, inner, light(base)), encoding="utf-8")
    print(f"{len(ILLU)} Illustrationen -> {art_dir}")
    print(f"{len(ICONS)} Icons geladen")


if __name__ == "__main__":
    build(Path(__file__).resolve().parents[2] / "art")
