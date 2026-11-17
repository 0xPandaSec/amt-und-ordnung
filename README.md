# Amt & Ordnung — Karten-Prototyp

Druckfertiges Kartendeck zum Papier-Testen. 65 Karten aus 14 Typen, A4, 9 Karten pro Seite.

## Ergebnis

| Datei | Zweck |
|---|---|
| `out/amt-und-ordnung-karten.pdf` | **Druckvorlage**, 8 Seiten A4 |
| `out/preview-sheet1.png` | Bildschirmvorschau Seite 1 |
| `out/preview-detail.png` | Nahaufnahme von 3 Karten |
| `build/cards.html` | HTML-Quelle (im Browser ansehbar) |

## Drucken

1. PDF auf **A4, 100 % Skalierung** drucken (nicht „an Seite anpassen").
2. **250–300 g/m²** Karton, beidseitig nicht nötig — Rückseite bleibt weiß.
3. An den Kartenkanten schneiden: 63 × 88 mm (Standard-TCG-Format).
4. In **63,5 × 88,9 mm Sleeves** stecken — dann sind die Karten gemischt und fühlen sich echt an.

Ohne Schneidemaschine: Lineal + Cutter + Kartonunterlage reichen.

## Karten ändern

Alles Inhaltliche steht in `data/cards.json` — Text, Anzahl, Farbe, Icon:

```json
{
  "id": "widerspruch",
  "name": "Widerspruch",
  "category": "rettung",
  "copies": 6,
  "icon": "schild",
  "effect": "Entschärfe einen Auflagenbescheid. …",
  "flavor": "Frist: ein Monat. Sie haben vier Sekunden.",
  "art": "widerspruch"
}
```

Danach neu bauen:

```powershell
python tools/build-cards/build.py
```

## Grafik

Die 14 Illustrationen liegen als PNG in `art/`. Der Builder skaliert sie beim Einbau auf
1100 px Breite herunter und bettet sie als JPEG ein — sonst würde das PDF durch die
65-fache Verwendung explodieren.

Ersetzen ohne Codeänderung: `art/<id>.png` austauschen (oder `.jpg` / `.webp` daneben
legen). Die SVGs sind nur Fallback, falls ein Bild fehlt.

- Format: 16:9, mindestens 900 px breit
- Der Bildausschnitt wird mittig auf 57 × 40 mm beschnitten (`background-size: cover`)
- IDs stehen im Feld `art` in `cards.json`
- Bild-Briefing: `art/PROMPTS.md`

## Struktur

```
amt-und-ordnung/
├── data/cards.json          Karteninhalte
├── art/                     Illustrationen (SVG-Platzhalter oder eigene Bilder)
├── tools/build-cards/
│   ├── art_gen.py           erzeugt die 14 SVG-Illustrationen + Icons
│   ├── style.css            Kartenlayout (63 × 88 mm)
│   ├── build.py             JSON → HTML → PDF
│   └── preview.py           PNG-Vorschauen
├── build/cards.html         generiert
├── out/                     PDF + Vorschauen
└── docs/GDD.md              Game Design Document
```

## Layout

| Zone | Höhe | Inhalt |
|---|---|---|
| Kopf | 10 mm | Symbol (7 mm) oben links, Formularzeile, Kartentitel |
| Artwork | 40 mm | Comic-Illustration, Kategorie-Stempel unten rechts |
| Wirkung | flexibel | Effekttext im Formularfeld |
| Flavor | ~5 mm | kursiver Begleittext |
| Fußzeile | 4,5 mm | Kartennummer, Anzahl im Deck |

## Voraussetzungen

- Python 3.10+
- `playwright` (`pip install playwright`) — nutzt das installierte Chrome, kein Browser-Download nötig
- `pillow` (`pip install pillow`) — verkleinert die Illustrationen für den Druck
