# Artwork-Briefing

14 Motive für 65 Karten. Diese Datei ist die Vorlage für Bildgenerierung oder Auftragsarbeit.

> **Wichtig:** Den *Stil* nachzuahmen ist erlaubt, die *konkreten Bilder* eines anderen
> Spiels nicht. Keine Katzen, keine bekannten Gags, keine nachgezeichneten Kompositionen.
> Der Stil unten ist eine Beschreibung, kein Künstlername — und das ist Absicht.

---

## Stil-Block (immer voranstellen)

```
Hand-inked webcomic illustration. Bold, wobbly black brush-pen outlines with visible
line-weight variation and slightly broken, hand-drawn edges. Heavy cross-hatching for
shadow. Flat spot colors only — no gradients, no 3D, no photorealism. Palette strictly
limited to paper white #F4F1E8, ink black #1C1B18, stamp red #A8322F plus the one accent
color named below. Deadpan bureaucratic absurdity, exaggerated proportions, one small
detail that rewards a second look. Off-white paper background with faint halftone dots.
Subject centered, generous negative space, square-ish framing.
No text, no letters, no numbers, no logos, no watermark, no signature.
```

## Technik

| | |
|---|---|
| Auflösung | 1600 × 900 px (16:9) — der Builder beschneidet mittig |
| Format | PNG oder JPG, max. 2 MB pro Bild |
| Ablage | `art/<id>.png` — Dateiname **exakt** wie in der Tabelle |
| Danach | `python tools/build-cards/build.py` |

Der Builder erkennt automatisch, ob ein Bild existiert, und meldet am Ende, welche Motive
noch Platzhalter sind.

---

## Die 14 Motive

| # | Datei | Akzent | Motiv |
|---|---|---|---|
| 1 | `auflagenbescheid` | Rot | Ein Amtsbescheid springt aus einem Aktenschrank, übersät mit roten Stempeln und Warndreiecken, Papier zerknittert, bedrohliches rotes Leuchten, Staub in der Luft. |
| 2 | `widerspruch` | Grün | Ein riesiger Gummistempel schlägt auf ein rotes Warnschreiben, ein grünes Schutzschild aus Licht fängt den Schlag ab, Funken fliegen, triumphierender Blickwinkel von unten. |
| 3 | `formfehler` | Rot | Ein Formular wird in der Mitte durchgerissen, ein wuchtiges rotes X darüber gestempelt, Papierfetzen fliegen, dramatische Bewegungslinien. |
| 4 | `vorgang-vertagen` | Blaugrau | Eine Wanduhr läuft über einen Aktenstapel, Spinnweben am Schreibtisch, Staubschichten, absurde Langsamkeit, eine Motte sitzt auf der Uhr. |
| 5 | `fristverlaengerung` | Blaugrau | Eine endlose Treppe aus Papierformularen führt nach unten, am unteren Ende hängt ein tonnenschweres Gewicht an einem dünnen Faden. |
| 6 | `amtshilfe` | Türkis | Zwei Hände reichen sich ein einzelnes Blatt über einen Schreibtisch, die eine Hand zieht es widerwillig zurück, übertriebene Mimik in den Fingern. |
| 7 | `zustaendigkeit-wechseln` | Grau | Ein Aktenstapel wird zum Wirbelwind, Papiere fliegen im Kreis, Pfeile drehen sich, alles schwindlig. |
| 8 | `akteneinsicht` | Ocker | Ein riesiges Auge blickt durch eine Lupe auf drei Dokumente, Detektiv-Stimmung, grünliches Glas, ein zweites kleineres Auge blinzelt im Hintergrund. |
| 9 | `aus-dem-archiv` | Grau | Ein staubiger Archivkeller, ein gewaltiger Aktenschrank, eine Hand zieht ein Dokument aus der untersten Schublade, Lichtschächte, Spinnweben. |
| 10 | `bauantrag` | Blau | Ein Zirkel und eine gerollte blaue Bauzeichnung auf einem Werktisch, technisches Zeichnen, ein Lineal liegt schief, Kaffeetasse als Beschwerer. |
| 11 | `laermprotokoll` | Grün | Ein Schallpegelmesser schleudert konzentrische Wellen gegen eine Schlafzimmerwand, im Fenster die Silhouette eines sehr wachen Nachbarn. |
| 12 | `grundriss` | Gelb | Ein Grundriss auf vergilbtem Papier, ein unmöglicher Flur führt ins Nichts, Klebeband und Bleistiftmarkierungen, ein Pfeil zeigt auf eine Wand, die nicht existiert. |
| 13 | `statiknachweis` | Rot | Ein Stahlträger unter Lasttest, rote Risslinien breiten sich aus, ein Spannungsdiagramm liegt halbtransparent darüber, Gewicht drückt von oben. |
| 14 | `nachbarschaftsbeschwerde` | Lila | Ein überquellender Briefumschlag voller handschriftlicher Seiten und Fotos, lilafarbenes Siegel, im Hintergrund ein wütender Nachbar am Fenster. |

---

## Falls Auftragsarbeit

Ein Illustrationsbudget für 14 Motive liegt typischerweise bei 30–80 € pro Motiv bei
einem Anfänger-Portfolio (Fiverr, ArtStation, r/HungryArtists) bis 150–300 € bei
etablierten Künstlern. Für einen Prototypen reichen 2–3 fertige Motive: eine Karte mit
finalem Artwork sagt mehr über die Wirkung als 14 halbe.

**Reihenfolge, falls etappenweise:** erst `auflagenbescheid` (die Karte, die man am
häufigsten sieht), dann `widerspruch` und `formfehler` — das sind die drei Karten, die
jede Runde in jeder Hand liegen.
