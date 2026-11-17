# AGENTS.md — Auftrag für den Bild-Agenten

> **Status: erledigt.** Die 14 Illustrationen liegen als `art/*.png` vor. Diese Datei
> gilt, wenn Motive überarbeitet oder ergänzt werden sollen.

Dieses Repository enthält ein Kartenspiel in Entwicklung. **Deine einzige Aufgabe: die
Karten-Illustrationen erzeugen.** Ändere nichts anderes.

---

## Was hier liegt

| Pfad | Inhalt |
|---|---|
| `art/PROMPTS.md` | **Dein Briefing.** 14 Motivbeschreibungen mit Akzentfarbe und Stilvorgabe |
| `art/*.svg` | Platzhalter-Illustrationen (werden von dir ersetzt) |
| `data/cards.json` | Karteninhalte — **nicht anfassen** |
| `tools/build-cards/` | Build-Pipeline — **nicht anfassen** |
| `out/preview-*.png` | So sieht das Deck aktuell aus |
| `out/amt-und-ordnung-karten.pdf` | Druckvorlage, 8 Seiten A4 |
| `docs/GDD.md` | Game Design Document (Kontext, warum die Karten so sind) |

## Auftrag

1. Lies `art/PROMPTS.md` vollständig.
2. Erzeuge für **jedes** der 14 Motive ein Bild nach dem dortigen Stil-Block und der
   jeweiligen Motivbeschreibung.
3. Speichere als `art/<id>.png` — die IDs stehen in der Tabelle in `art/PROMPTS.md`
   (z. B. `art/auflagenbescheid.png`).

**Fertig, wenn alle 14 Dateien existieren.**

## Harte Vorgaben

- **Format:** 1600 × 900 px, 16:9, PNG oder JPG
- **Kein Text im Bild.** Keine Buchstaben, Zahlen, Logos, Wasserzeichen, Signaturen.
  Schrift in KI-Bildern ist immer fehlerhaft und macht die Karte unbrauchbar.
- **Palette:** Papierweiß `#F4F1E8`, Tuscheschwarz `#1C1B18`, Stempelrot `#A8322F`
  plus die pro Motiv genannte Akzentfarbe. Nichts anderes.
- **Stil:** handgezeichnete, wackelige Tuschelinien, Cross-Hatching, flache Farben.
  Kein 3D, keine Fotorealistik, keine Verläufe.
- **Bildaufbau:** Motiv zentriert, großzügiger Rand. Das Bild wird mittig auf 57 × 40 mm
  beschnitten — was am Rand liegt, fällt weg.
- **Keine Kopien.** Keine Katzen, keine Figuren oder Gags aus bestehenden Kartenspielen.
  Der Stil ist frei, fremde Motive nicht.

## Qualitätsprüfung vor Abgabe

Für jedes Bild:

1. Ist es bei **57 mm Breite** noch lesbar? Zu viel Detail verschwindet.
2. Ist der Kontrast stark genug? Auf der Karte liegen Farbbalken und Stempel darüber.
3. Enthält es wirklich keinen Text?
4. Passt der Bildausschnitt in 16:9, ohne dass das Motiv abgeschnitten wird?

## Optional: Ergebnis prüfen

```bash
python tools/build-cards/build.py
```

Setzt Python 3.10+ und `playwright` voraus (`pip install playwright`). Das Skript baut
`build/cards.html` und `out/amt-und-ordnung-karten.pdf` neu und meldet am Ende, welche
Motive noch Platzhalter sind. Wenn du das nicht ausführen kannst, ist das kein Problem —
die PNGs reichen.

## Reihenfolge, falls nicht alle 14 machbar sind

Priorität nach Sichtbarkeit im Spiel:

1. `auflagenbescheid`
2. `widerspruch`
3. `formfehler`
4. `bauantrag`, `laermprotokoll`, `grundriss`, `statiknachweis`,
   `nachbarschaftsbeschwerde`
5. der Rest
